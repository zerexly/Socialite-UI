import 'dart:convert';
import 'package:foap/helper/common_import.dart';
import 'package:foap/manager/file_manager.dart';
import 'package:foap/util/constant_util.dart';
import 'package:get/get.dart';

class ChatDetailController extends GetxController {
  final AgoraCallController agoraCallController = Get.find();

  Rx<TextEditingController> messageTf = TextEditingController().obs;

  bool expandActions = false;
  RxBool isOnline = false.obs;
  RxBool isTyping = false.obs;
  Rx<ChatMessageActionMode> actionMode = ChatMessageActionMode.none.obs;
  RxList<ChatMessageModel> selectedMessages = <ChatMessageModel>[].obs;
  RxList<ChatMessageModel> messages = <ChatMessageModel>[].obs;

  RxList<String> smartReplySuggestions = <String>[].obs;

  // RxList<ChatMessageModel> photos = <ChatMessageModel>[].obs;
  // RxList<ChatMessageModel> videos = <ChatMessageModel>[].obs;

  Rx<ChatMessageModel?> selectedMessage = Rx<ChatMessageModel?>(null);

  bool isLoading = false;
  int chatRoomId = 0;
  late ChatRoomModel chatRoom;
  Rx<UserModel?> opponent = Rx<UserModel?>(null);
  DateTime? typingStatusUpdatedAt;

  final smartReply = SmartReply();

  List<ChatMessageModel> get mediaMessages {
    return messages
        .where((element) =>
            element.messageContentType == MessageContentType.photo ||
            element.messageContentType == MessageContentType.video)
        .toList();
  }

  clear() {
    expandActions = false;
    selectedMessages.clear();
    messages.clear();
    // photos.clear();
    // videos.clear();
    chatRoomId = 0;
    opponent.value = null;
    actionMode.value = ChatMessageActionMode.none;
    selectedMessage.value = null;
    typingStatusUpdatedAt = null;
  }

  //create chat room directory
  Future<String> messageMediaDirectory(String localMessageId) async {
    final appDir = await getApplicationDocumentsDirectory();

    final Directory chatRoomDirectory =
        Directory('${appDir.path}/$chatRoomId/$localMessageId');

    if (await chatRoomDirectory.exists()) {
      //if folder already exists return path
      return chatRoomDirectory.path;
    } else {
      //if folder not exists create folder and then return its path
      final Directory newFolder =
          await chatRoomDirectory.create(recursive: true);
      return newFolder.path;
    }
  }

  loadChat(ChatRoomModel? chatRoom, UserModel? opponent) async {
    if (chatRoom == null) {
      this.opponent.value = opponent!;
      createChatRoom(opponent.id, (roomId) async {
        chatRoomId = roomId;

        loadRooms();
        messages.value = await getIt<DBManager>().getAllMessages(chatRoomId);
        update();
      });

      update();
    } else {
      this.opponent.value = chatRoom.opponent;
      chatRoomId = chatRoom.id;

      this.chatRoom = chatRoom;
      messages.value = await getIt<DBManager>().getAllMessages(chatRoom.id);
      update();
    }
  }

  createChatRoom(int userId, Function(int) callback) {
    ApiController().createChatRoom(userId).then((response) {
      getIt<SocketManager>().emit(SocketConstants.addUserInChatRoom,
          {'userId': userId.toString(), 'room': response.roomId.toString()});

      callback(response.roomId);
    });
  }

  loadRooms() {
    ApiController().getChatRooms().then((response) {
      List rooms = response.chatRooms
          .where((element) => element.id == chatRoomId)
          .toList();
      if (rooms.isNotEmpty) {
        chatRoom = rooms.first;
      } else {
        // dummy detail room
        chatRoom = ChatRoomModel(
            id: chatRoomId,
            status: 1,
            createdAt: DateTime.now().millisecondsSinceEpoch,
            createdBy: 1,
            users: [getIt<UserProfileManager>().user!, opponent.value!],
            isOnline: false,
            lastMessage: ChatMessageModel());
      }
    });
  }

  isSelected(ChatMessageModel message) {
    return selectedMessages.contains(message);
  }

  selectMessage(ChatMessageModel message) {
    if (isSelected(message)) {
      selectedMessages.remove(message);
    } else {
      selectedMessages.add(message);
    }
    update();
  }

  setToActionMode({required ChatMessageActionMode mode}) {
    actionMode.value = mode;
    if (mode == ChatMessageActionMode.none) {
      selectedMessages.clear();
    }
    update();
  }

  setReplyMessage({required ChatMessageModel? message}) {
    if (message == null) {
      setToActionMode(mode: ChatMessageActionMode.none);
    } else {
      if (message.messageContentType != MessageContentType.reply) {
        selectedMessage.value = message;
      } else {
        selectedMessage.value = message.reply;
      }
      setToActionMode(mode: ChatMessageActionMode.reply);
    }
    update();
  }

  updateOnlineStatus() {
    isOnline.value = !isOnline.value;
    update();
  }

  expandCollapseActions() {
    expandActions = !expandActions;
    update();
  }

  messageChanges() {
    getIt<SocketManager>().emit(SocketConstants.typing, {'room': chatRoomId});
    messageTf.refresh();
    // update();
  }

  Future<bool> sendPostAsMessage(
      {required PostModel post, required UserModel toOpponent}) async {
    bool status = true;
    await createChatRoom(toOpponent.id, (roomId) {
      String localMessageId = randomId();

      var content = {
        'postId': post.id,
        'postThumbnail': post.gallery.first.thumbnail()
      };

      var message = {
        'userId': getIt<UserProfileManager>().user!.id,
        'localMessageId': localMessageId,
        'messageType': messageTypeId(MessageContentType.post),
        'message': json.encode(content),
        'room': roomId,
        'created_by': getIt<UserProfileManager>().user!.id,
        'created_at': (DateTime.now().millisecondsSinceEpoch / 1000).round(),
      };

      ChatMessageModel localMessageModel = ChatMessageModel();
      localMessageModel.localMessageId = localMessageId;
      localMessageModel.roomId = roomId;
      localMessageModel.messageTime = LocalizationString.justNow;
      localMessageModel.userName = LocalizationString.you;
      localMessageModel.senderId = getIt<UserProfileManager>().user!.id;
      localMessageModel.messageType = messageTypeId(MessageContentType.post);
      localMessageModel.messageContent =
          json.encode(content).replaceAll('\\', '');
      localMessageModel.createdAt =
          (DateTime.now().millisecondsSinceEpoch / 1000).round();

      addNewMessage(message: localMessageModel, roomId: roomId);
      // save message to database
      getIt<DBManager>().saveMessage(roomId, localMessageModel);
      // send message to socket server

      status =
          getIt<SocketManager>().emit(SocketConstants.sendMessage, message);
      update();
    });

    return status;
  }

  Future<bool> sendTextMessage(
      {required ChatMessageActionMode mode,
      required BuildContext context,
      required int roomId}) async {
    bool status = true;

    final filter = ProfanityFilter();
    bool hasProfanity = filter.hasProfanity(messageTf.value.text);
    if (hasProfanity) {
      AppUtil.showToast(
          context: context,
          message: LocalizationString.notAllowedMessage,
          isSuccess: true);
      return false;
    }
    if (messageTf.value.text.removeAllWhitespace.trim().isNotEmpty) {
      String? replyMessage;
      String localMessageId = randomId();

      if (mode == ChatMessageActionMode.reply) {
        var currentMessage = {
          'id': 0,
          'created_by': getIt<UserProfileManager>().user!.id,
          'created_at': (DateTime.now().millisecondsSinceEpoch / 1000).round(),
          'userId': getIt<UserProfileManager>().user!.id,
          'localMessageId': localMessageId,
          'messageType': messageTypeId(MessageContentType.text),
          'message': messageTf.value.text,
          'room': roomId,
          'username': LocalizationString.you
        };

        var replyContent = {
          'originalMessage': selectedMessage.value!.toJson(),
          'reply': json.encode(currentMessage)
        };

        replyMessage = json.encode(replyContent);
      }

      var message = {
        'userId': getIt<UserProfileManager>().user!.id,
        'localMessageId': localMessageId,
        'messageType': messageTypeId(mode == ChatMessageActionMode.reply
            ? MessageContentType.reply
            : MessageContentType.text),
        'message': mode == ChatMessageActionMode.reply
            ? replyMessage
            : messageTf.value.text,
        'room': roomId,
        'created_by': getIt<UserProfileManager>().user!.id,
        'created_at': (DateTime.now().millisecondsSinceEpoch / 1000).round()
      };

      //save message to socket server
      status =
          getIt<SocketManager>().emit(SocketConstants.sendMessage, message);

      ChatMessageModel localMessageModel = ChatMessageModel();
      localMessageModel.localMessageId = localMessageId;
      localMessageModel.roomId = roomId;
      localMessageModel.messageTime = LocalizationString.justNow;
      localMessageModel.userName = LocalizationString.you;
      localMessageModel.senderId = getIt<UserProfileManager>().user!.id;
      localMessageModel.messageType = messageTypeId(
          mode == ChatMessageActionMode.reply
              ? MessageContentType.reply
              : MessageContentType.text);
      localMessageModel.messageContent = mode == ChatMessageActionMode.reply
          ? replyMessage!
          : messageTf.value.text;
      localMessageModel.createdAt =
          (DateTime.now().millisecondsSinceEpoch / 1000).round();

      addNewMessage(message: localMessageModel, roomId: roomId);
      // save message to database
      getIt<DBManager>().saveMessage(roomId, localMessageModel);

      setReplyMessage(message: null);
      messageTf.value.text = '';

      update();
    }

    return status;
  }

  Future<bool> sendContactMessage(
      {required Contact contact,
      required ChatMessageActionMode mode,
      required BuildContext context,
      required int roomId}) async {
    bool status = true;

    String? replyMessage;
    String localMessageId = randomId();

    var content = {
      'contactCard': contact.toVCard(),
    };

    if (mode == ChatMessageActionMode.reply) {
      var currentMessage = {
        'id': 0,
        'created_by': getIt<UserProfileManager>().user!.id,
        'created_at': (DateTime.now().millisecondsSinceEpoch / 1000).round(),
        'userId': getIt<UserProfileManager>().user!.id,
        'localMessageId': localMessageId,
        'messageType': messageTypeId(MessageContentType.contact),
        'message': json.encode(content),
        'room': roomId,
        'username': LocalizationString.you
      };

      var replyContent = {
        'originalMessage': selectedMessage.value!.toJson(),
        'reply': json.encode(currentMessage)
      };

      replyMessage = json.encode(replyContent);
    }

    var message = {
      'userId': getIt<UserProfileManager>().user!.id,
      'localMessageId': localMessageId,
      'messageType': messageTypeId(mode == ChatMessageActionMode.reply
          ? MessageContentType.reply
          : MessageContentType.contact),
      'message': mode == ChatMessageActionMode.reply
          ? replyMessage
          : json.encode(content),
      'room': roomId,
      'created_by': getIt<UserProfileManager>().user!.id,
      'created_at': (DateTime.now().millisecondsSinceEpoch / 1000).round()
    };

    //save message to socket server
    status = getIt<SocketManager>().emit(SocketConstants.sendMessage, message);

    ChatMessageModel localMessageModel = ChatMessageModel();
    localMessageModel.localMessageId = localMessageId;
    localMessageModel.roomId = roomId;
    localMessageModel.messageTime = LocalizationString.justNow;
    localMessageModel.userName = LocalizationString.you;
    localMessageModel.senderId = getIt<UserProfileManager>().user!.id;
    localMessageModel.messageType = messageTypeId(
        mode == ChatMessageActionMode.reply
            ? MessageContentType.reply
            : MessageContentType.contact);
    localMessageModel.messageContent = mode == ChatMessageActionMode.reply
        ? replyMessage!
        : json.encode(content);
    localMessageModel.createdAt =
        (DateTime.now().millisecondsSinceEpoch / 1000).round();

    addNewMessage(message: localMessageModel, roomId: roomId);
    // save message to database
    getIt<DBManager>().saveMessage(roomId, localMessageModel);

    setReplyMessage(message: null);
    update();
    return status;
  }

  Future<bool> sendLocationMessage(
      {required LocationModel location,
      required ChatMessageActionMode mode,
      required BuildContext context,
      required int roomId}) async {
    bool status = true;

    String? replyMessage;
    String localMessageId = randomId();

    var locationData = {
      'latitude': location.latitude,
      'longitude': location.longitude,
      'name': location.name,
    };

    var locationObject = {'location': locationData};

    if (mode == ChatMessageActionMode.reply) {
      var currentMessage = {
        'id': 0,
        'created_by': getIt<UserProfileManager>().user!.id,
        'created_at': (DateTime.now().millisecondsSinceEpoch / 1000).round(),
        'userId': getIt<UserProfileManager>().user!.id,
        'localMessageId': localMessageId,
        'messageType': messageTypeId(MessageContentType.location),
        'message': json.encode(locationObject),
        'room': roomId,
        'username': LocalizationString.you
      };

      var replyContent = {
        'originalMessage': selectedMessage.value!.toJson(),
        'reply': json.encode(currentMessage)
      };

      replyMessage = json.encode(replyContent);
    }

    var message = {
      'userId': getIt<UserProfileManager>().user!.id,
      'localMessageId': localMessageId,
      'messageType': messageTypeId(mode == ChatMessageActionMode.reply
          ? MessageContentType.reply
          : MessageContentType.location),
      'message': mode == ChatMessageActionMode.reply
          ? replyMessage
          : json.encode(locationObject),
      'room': roomId,
      'created_by': getIt<UserProfileManager>().user!.id,
      'created_at': (DateTime.now().millisecondsSinceEpoch / 1000).round()
    };

    //save message to socket server
    status = getIt<SocketManager>().emit(SocketConstants.sendMessage, message);

    ChatMessageModel localMessageModel = ChatMessageModel();
    localMessageModel.localMessageId = localMessageId;
    localMessageModel.roomId = roomId;
    localMessageModel.messageTime = LocalizationString.justNow;
    localMessageModel.userName = LocalizationString.you;
    localMessageModel.senderId = getIt<UserProfileManager>().user!.id;
    localMessageModel.messageType = messageTypeId(
        mode == ChatMessageActionMode.reply
            ? MessageContentType.reply
            : MessageContentType.location);
    localMessageModel.messageContent = mode == ChatMessageActionMode.reply
        ? replyMessage!
        : json.encode(locationObject);
    localMessageModel.createdAt =
        (DateTime.now().millisecondsSinceEpoch / 1000).round();

    addNewMessage(message: localMessageModel, roomId: roomId);
    // save message to database
    getIt<DBManager>().saveMessage(roomId, localMessageModel);

    setReplyMessage(message: null);
    update();
    return status;
  }

  Future<bool> sendSmartMessage(
      {required String smartMessage, required int roomId}) async {
    bool status = true;
    String localMessageId = randomId();

    var message = {
      'userId': getIt<UserProfileManager>().user!.id,
      'localMessageId': localMessageId,
      'messageType': messageTypeId(MessageContentType.text),
      'message': smartMessage,
      'room': roomId,
      'created_by': getIt<UserProfileManager>().user!.id,
      'created_at': (DateTime.now().millisecondsSinceEpoch / 1000).round()
    };

    //save message to socket server
    status = getIt<SocketManager>().emit(SocketConstants.sendMessage, message);

    ChatMessageModel localMessageModel = ChatMessageModel();
    localMessageModel.localMessageId = localMessageId;
    localMessageModel.roomId = roomId;
    localMessageModel.messageTime = LocalizationString.justNow;
    localMessageModel.userName = LocalizationString.you;
    localMessageModel.senderId = getIt<UserProfileManager>().user!.id;
    localMessageModel.messageType = messageTypeId(MessageContentType.text);
    localMessageModel.messageContent = smartMessage;
    localMessageModel.createdAt =
        (DateTime.now().millisecondsSinceEpoch / 1000).round();

    addNewMessage(message: localMessageModel, roomId: roomId);
    // save message to database
    getIt<DBManager>().saveMessage(roomId, localMessageModel);
    setReplyMessage(message: null);
    update();
    return status;
  }

  Future<bool> forwardMessage(
      {required ChatMessageModel msg, required UserModel opponentUser}) async {
    bool status = true;

    String localMessageId = randomId();
    createChatRoom(opponentUser.id, (roomId) {
      var originalContent = {
        'originalMessage': msg.messageContentType == MessageContentType.reply
            ? msg.reply.toJson()
            : msg.messageContentType == MessageContentType.forward
                ? msg.originalMessage.toJson()
                : msg.toJson(),
      };

      ChatMessageModel localMessageModel = ChatMessageModel();
      localMessageModel.localMessageId = localMessageId;
      localMessageModel.roomId = roomId;
      localMessageModel.messageTime = LocalizationString.justNow;
      localMessageModel.userName = LocalizationString.you;
      localMessageModel.senderId = getIt<UserProfileManager>().user!.id;
      localMessageModel.messageType = messageTypeId(MessageContentType.forward);
      localMessageModel.messageContent = json.encode(originalContent);
      localMessageModel.createdAt =
          (DateTime.now().millisecondsSinceEpoch / 1000).round();

      // addNewMessage(localMessageModel);

      var message = {
        'userId': getIt<UserProfileManager>().user!.id,
        'localMessageId': localMessageId,
        'messageType': messageTypeId(MessageContentType.forward),
        'message': json.encode(originalContent),
        'room': roomId,
        'created_by': getIt<UserProfileManager>().user!.id,
        'created_at': localMessageModel.createdAt,
      };

      status =
          getIt<SocketManager>().emit(SocketConstants.sendMessage, message);
      getIt<DBManager>().saveMessage(roomId, localMessageModel);
    });
    return status;
  }

  Future<bool> sendImageMessage(
      {required BuildContext context,
      required Media media,
      required ChatMessageActionMode mode,
      required int roomId}) async {
    bool status = true;

    String localMessageId = randomId();
    String? replyMessageStringContent;

    ChatMessageModel localMessageModel = ChatMessageModel();

    if (mode == ChatMessageActionMode.reply) {
      localMessageModel.localMessageId = localMessageId;
      localMessageModel.roomId = roomId;
      localMessageModel.messageTime = LocalizationString.justNow;
      localMessageModel.userName = LocalizationString.you;
      localMessageModel.senderId = getIt<UserProfileManager>().user!.id;
      localMessageModel.messageType = messageTypeId(
          mode == ChatMessageActionMode.reply
              ? MessageContentType.reply
              : MessageContentType.photo);
      localMessageModel.originalMessageContent = selectedMessage.value;

      // reply content start
      ChatMessageModel replyMessage = ChatMessageModel();
      replyMessage.id = 0;
      replyMessage.roomId = roomId;
      replyMessage.localMessageId = localMessageId;
      replyMessage.senderId = getIt<UserProfileManager>().user!.id;
      replyMessage.messageType = messageTypeId(MessageContentType.photo);
      replyMessage.media = media;
      replyMessage.messageContent = '';
      replyMessage.createdAt =
          (DateTime.now().millisecondsSinceEpoch / 1000).round();

      localMessageModel.replyMessageContent = replyMessage;
      // reply content end

      localMessageModel.createdAt =
          (DateTime.now().millisecondsSinceEpoch / 1000).round();
      localMessageModel.messageContent = '';

      addNewMessage(message: localMessageModel, roomId: roomId);
      getIt<DBManager>().saveMessage(roomId, localMessageModel);
    } else {
      localMessageModel.localMessageId = localMessageId;
      localMessageModel.roomId = roomId;
      localMessageModel.messageTime = LocalizationString.justNow;
      localMessageModel.userName = LocalizationString.you;
      localMessageModel.senderId = getIt<UserProfileManager>().user!.id;
      localMessageModel.messageType = messageTypeId(
          mode == ChatMessageActionMode.reply
              ? MessageContentType.reply
              : MessageContentType.photo);
      localMessageModel.createdAt =
          (DateTime.now().millisecondsSinceEpoch / 1000).round();
      localMessageModel.messageContent = '';
      localMessageModel.media = media;

      addNewMessage(message: localMessageModel, roomId: roomId);
      getIt<DBManager>().saveMessage(roomId, localMessageModel);
    }

    update();

    // upload photo and send message

    uploadMedia(
        context: context,
        messageId: localMessageId,
        media: media,
        callback: (uploadedMedia) {
          var content = {
            'image': uploadedMedia.thumbnail,
            'video': uploadedMedia.video ?? ''
          };

          if (mode == ChatMessageActionMode.reply) {
            var currentMessage = {
              'userId': getIt<UserProfileManager>().user!.id,
              'created_by': getIt<UserProfileManager>().user!.id,
              'username': LocalizationString.you,
              'created_at':
                  (DateTime.now().millisecondsSinceEpoch / 1000).round(),
              'localMessageId': localMessageId,
              'messageType': messageTypeId(MessageContentType.photo),
              'message': json.encode(content),
              'room': roomId
            };

            var replyContent = {
              'originalMessage': selectedMessage.value!.toJson(),
              'reply': json.encode(currentMessage)
            };

            replyMessageStringContent = json.encode(replyContent);
          }

          var message = {
            'userId': getIt<UserProfileManager>().user!.id,
            'localMessageId': localMessageId,
            'messageType': messageTypeId(mode == ChatMessageActionMode.reply
                ? MessageContentType.reply
                : MessageContentType.photo),
            'message': mode == ChatMessageActionMode.reply
                ? replyMessageStringContent
                : json.encode(content),
            'room': roomId,
            'created_by': getIt<UserProfileManager>().user!.id,
            'created_at': localMessageModel.createdAt,
          };

          // send message to socket
          status =
              getIt<SocketManager>().emit(SocketConstants.sendMessage, message);

          // update in cache message

          localMessageModel.messageContent = mode == ChatMessageActionMode.reply
              ? replyMessageStringContent!
              : json.encode(content);
          localMessageModel.replyMessageContent = null;
          localMessageModel.originalMessageContent = null;
          // update message in local database
          getIt<DBManager>().updateMessageContent(
              roomId,
              localMessageModel.localMessageId.toString(),
              mode == ChatMessageActionMode.reply
                  ? replyMessageStringContent!
                  : json.encode(content));
        });

    setReplyMessage(message: null);
    return status;
  }

  Future<bool> sendVideoMessage(
      {required BuildContext context,
      required Media media,
      required ChatMessageActionMode model,
      required int roomId}) async {
    bool status = true;

    String localMessageId = randomId();
    String? replyMessageStringContent;

    ChatMessageModel localMessageModel = ChatMessageModel();

    if (model == ChatMessageActionMode.reply) {
      localMessageModel.localMessageId = localMessageId;
      localMessageModel.roomId = roomId;
      localMessageModel.messageTime = LocalizationString.justNow;
      localMessageModel.userName = LocalizationString.you;
      localMessageModel.senderId = getIt<UserProfileManager>().user!.id;
      localMessageModel.messageType = messageTypeId(
          model == ChatMessageActionMode.reply
              ? MessageContentType.reply
              : MessageContentType.video);
      localMessageModel.originalMessageContent = selectedMessage.value;

      // reply content start
      ChatMessageModel replyMessage = ChatMessageModel();
      replyMessage.id = 0;
      replyMessage.roomId = roomId;
      replyMessage.localMessageId = localMessageId;
      replyMessage.senderId = getIt<UserProfileManager>().user!.id;
      replyMessage.messageType = messageTypeId(MessageContentType.video);
      replyMessage.media = media;
      replyMessage.messageContent = '';
      replyMessage.createdAt =
          (DateTime.now().millisecondsSinceEpoch / 1000).round();

      localMessageModel.replyMessageContent = replyMessage;
      // reply content end

      localMessageModel.createdAt =
          (DateTime.now().millisecondsSinceEpoch / 1000).round();
      localMessageModel.messageContent = '';
      // messages.add(localMessageModel);
      messages.value = [localMessageModel];

      getIt<DBManager>().saveMessage(roomId, localMessageModel);
    } else {
      localMessageModel.localMessageId = localMessageId;
      localMessageModel.roomId = roomId;
      localMessageModel.messageTime = LocalizationString.justNow;
      localMessageModel.userName = LocalizationString.you;
      localMessageModel.senderId = getIt<UserProfileManager>().user!.id;
      localMessageModel.messageType = messageTypeId(
          model == ChatMessageActionMode.reply
              ? MessageContentType.reply
              : MessageContentType.video);
      localMessageModel.createdAt =
          (DateTime.now().millisecondsSinceEpoch / 1000).round();
      localMessageModel.messageContent = '';
      localMessageModel.media = media;

      addNewMessage(message: localMessageModel, roomId: roomId);
      getIt<DBManager>().saveMessage(roomId, localMessageModel);
    }

    update();

    // upload video and send message

    uploadMedia(
        context: context,
        messageId: localMessageId,
        media: media,
        callback: (uploadedMedia) {
          var content = {
            'image': uploadedMedia.thumbnail,
            'video': uploadedMedia.video ?? ''
          };

          if (model == ChatMessageActionMode.reply) {
            var currentMessage = {
              'userId': getIt<UserProfileManager>().user!.id,
              'created_by': getIt<UserProfileManager>().user!.id,
              'username': LocalizationString.you,
              'created_at':
                  (DateTime.now().millisecondsSinceEpoch / 1000).round(),
              'localMessageId': localMessageId,
              'messageType': messageTypeId(MessageContentType.video),
              'message': json.encode(content),
              'room': roomId
            };

            var replyContent = {
              'originalMessage': selectedMessage.value!.toJson(),
              'reply': json.encode(currentMessage)
            };

            replyMessageStringContent = json.encode(replyContent);
          }

          var message = {
            'userId': getIt<UserProfileManager>().user!.id,
            'localMessageId': localMessageId,
            'messageType': messageTypeId(model == ChatMessageActionMode.reply
                ? MessageContentType.reply
                : MessageContentType.video),
            'message': model == ChatMessageActionMode.reply
                ? replyMessageStringContent
                : json.encode(content),
            'room': roomId,
            'created_by': getIt<UserProfileManager>().user!.id,
            'created_at': localMessageModel.createdAt,
          };

          // send message to socket
          status =
              getIt<SocketManager>().emit(SocketConstants.sendMessage, message);

          // update in cache message
          localMessageModel.messageContent =
              model == ChatMessageActionMode.reply
                  ? replyMessageStringContent!
                  : json.encode(content);
          localMessageModel.replyMessageContent = null;
          localMessageModel.originalMessageContent = null;

          update();

          // update message in local database
          getIt<DBManager>().updateMessageContent(
              roomId,
              localMessageModel.localMessageId.toString(),
              model == ChatMessageActionMode.reply
                  ? replyMessageStringContent!
                  : json.encode(content));
        });

    setReplyMessage(message: null);
    return status;
  }

  Future<bool> sendAudioMessage(
      {required BuildContext context,
      required Media media,
      required ChatMessageActionMode mode,
      required int roomId}) async {
    bool status = true;

    String localMessageId = randomId();
    String? replyMessageStringContent;

    ChatMessageModel localMessageModel = ChatMessageModel();

    if (mode == ChatMessageActionMode.reply) {
      localMessageModel.localMessageId = localMessageId;
      localMessageModel.roomId = roomId;
      localMessageModel.messageTime = LocalizationString.justNow;
      localMessageModel.userName = LocalizationString.you;
      localMessageModel.senderId = getIt<UserProfileManager>().user!.id;
      localMessageModel.messageType = messageTypeId(
          mode == ChatMessageActionMode.reply
              ? MessageContentType.reply
              : MessageContentType.audio);
      localMessageModel.originalMessageContent = selectedMessage.value;

      // reply content start
      ChatMessageModel replyMessage = ChatMessageModel();
      replyMessage.id = 0;
      replyMessage.roomId = roomId;
      replyMessage.localMessageId = localMessageId;
      replyMessage.senderId = getIt<UserProfileManager>().user!.id;
      replyMessage.messageType = messageTypeId(MessageContentType.audio);
      replyMessage.media = media;
      replyMessage.messageContent = '';
      replyMessage.createdAt =
          (DateTime.now().millisecondsSinceEpoch / 1000).round();

      localMessageModel.replyMessageContent = replyMessage;
      // reply content end

      localMessageModel.createdAt =
          (DateTime.now().millisecondsSinceEpoch / 1000).round();
      localMessageModel.messageContent = '';

      addNewMessage(message: localMessageModel, roomId: roomId);
      getIt<DBManager>().saveMessage(roomId, localMessageModel);
    } else {
      localMessageModel.localMessageId = localMessageId;
      localMessageModel.roomId = roomId;
      localMessageModel.messageTime = LocalizationString.justNow;
      localMessageModel.userName = LocalizationString.you;
      localMessageModel.senderId = getIt<UserProfileManager>().user!.id;
      localMessageModel.messageType = messageTypeId(
          mode == ChatMessageActionMode.reply
              ? MessageContentType.reply
              : MessageContentType.audio);
      localMessageModel.createdAt =
          (DateTime.now().millisecondsSinceEpoch / 1000).round();
      localMessageModel.messageContent = '';
      localMessageModel.media = media;

      addNewMessage(message: localMessageModel, roomId: roomId);
      getIt<DBManager>().saveMessage(roomId, localMessageModel);
    }

    update();

    // upload photo and send message

    uploadMedia(
        context: context,
        messageId: localMessageId,
        media: media,
        callback: (uploadedMedia) {
          var content = {
            'audio': uploadedMedia.audio,
          };

          if (mode == ChatMessageActionMode.reply) {
            var currentMessage = {
              'userId': getIt<UserProfileManager>().user!.id,
              'created_by': getIt<UserProfileManager>().user!.id,
              'username': LocalizationString.you,
              'created_at':
                  (DateTime.now().millisecondsSinceEpoch / 1000).round(),
              'localMessageId': localMessageId,
              'messageType': messageTypeId(MessageContentType.audio),
              'message': json.encode(content),
              'room': roomId
            };

            var replyContent = {
              'originalMessage': selectedMessage.value!.toJson(),
              'reply': json.encode(currentMessage)
            };

            replyMessageStringContent = json.encode(replyContent);
          }

          var message = {
            'userId': getIt<UserProfileManager>().user!.id,
            'localMessageId': localMessageId,
            'messageType': messageTypeId(mode == ChatMessageActionMode.reply
                ? MessageContentType.reply
                : MessageContentType.audio),
            'message': mode == ChatMessageActionMode.reply
                ? replyMessageStringContent
                : json.encode(content),
            'room': roomId,
            'created_by': getIt<UserProfileManager>().user!.id,
            'created_at': localMessageModel.createdAt,
          };

          // send message to socket
          status =
              getIt<SocketManager>().emit(SocketConstants.sendMessage, message);

          // update in cache message

          localMessageModel.messageContent = mode == ChatMessageActionMode.reply
              ? replyMessageStringContent!
              : json.encode(content);
          localMessageModel.replyMessageContent = null;
          localMessageModel.originalMessageContent = null;
          // update message in local database
          getIt<DBManager>().updateMessageContent(
              roomId,
              localMessageModel.localMessageId.toString(),
              mode == ChatMessageActionMode.reply
                  ? replyMessageStringContent!
                  : json.encode(content));
        });

    setReplyMessage(message: null);
    return status;
  }

  Future<bool> sendGifMessage(
      {required String gif,
      required ChatMessageActionMode mode,
      required int roomId}) async {
    bool status = true;
    String localMessageId = randomId();
    String? replyMessage;

    var content = {'image': gif, 'video': ''};

    ChatMessageModel currentMessageModel = ChatMessageModel();

    if (mode == ChatMessageActionMode.reply) {
      currentMessageModel.localMessageId = localMessageId;
      currentMessageModel.roomId = roomId;
      currentMessageModel.messageTime = LocalizationString.justNow;
      currentMessageModel.userName = LocalizationString.you;
      currentMessageModel.senderId = getIt<UserProfileManager>().user!.id;
      currentMessageModel.messageType = messageTypeId(
          mode == ChatMessageActionMode.reply
              ? MessageContentType.reply
              : MessageContentType.gif);
      currentMessageModel.originalMessageContent = selectedMessage.value;

      // reply content start
      ChatMessageModel replyMessage = ChatMessageModel();
      replyMessage.id = 0;
      replyMessage.roomId = roomId;
      replyMessage.localMessageId = localMessageId;
      replyMessage.senderId = getIt<UserProfileManager>().user!.id;
      replyMessage.messageType = messageTypeId(MessageContentType.gif);
      replyMessage.messageContent = json.encode(content).replaceAll('\\', '');
      replyMessage.createdAt =
          (DateTime.now().millisecondsSinceEpoch / 1000).round();

      currentMessageModel.replyMessageContent = replyMessage;
      // reply content end

      currentMessageModel.createdAt =
          (DateTime.now().millisecondsSinceEpoch / 1000).round();
      currentMessageModel.messageContent = '';

      addNewMessage(message: currentMessageModel, roomId: roomId);
      getIt<DBManager>().saveMessage(roomId, currentMessageModel);
    } else {
      currentMessageModel.localMessageId = localMessageId;
      currentMessageModel.roomId = roomId;
      currentMessageModel.messageTime = LocalizationString.justNow;
      currentMessageModel.userName = LocalizationString.you;
      currentMessageModel.senderId = getIt<UserProfileManager>().user!.id;
      currentMessageModel.messageType = messageTypeId(
          mode == ChatMessageActionMode.reply
              ? MessageContentType.reply
              : MessageContentType.gif);
      currentMessageModel.createdAt =
          (DateTime.now().millisecondsSinceEpoch / 1000).round();
      currentMessageModel.messageContent =
          json.encode(content).replaceAll('\\', '');

      addNewMessage(message: currentMessageModel, roomId: roomId);
      getIt<DBManager>().saveMessage(roomId, currentMessageModel);
    }

    update();

    // send message to socket
    if (mode == ChatMessageActionMode.reply) {
      var currentMessage = {
        'userId': getIt<UserProfileManager>().user!.id,
        'created_by': getIt<UserProfileManager>().user!.id,
        'username': LocalizationString.you,
        'created_at': (DateTime.now().millisecondsSinceEpoch / 1000).round(),
        'localMessageId': localMessageId,
        'messageType': messageTypeId(MessageContentType.gif),
        'message': json.encode(content).replaceAll('\\', ''),
        'room': roomId
      };

      var replyContent = {
        'originalMessage': selectedMessage.value!.toJson(),
        'reply': json.encode(currentMessage).replaceAll('\\', '')
      };

      replyMessage = json.encode(replyContent).replaceAll('\\', '');
    }

    var message = {
      'userId': getIt<UserProfileManager>().user!.id,
      'localMessageId': localMessageId,
      'messageType': messageTypeId(mode == ChatMessageActionMode.reply
          ? MessageContentType.reply
          : MessageContentType.gif),
      'message': mode == ChatMessageActionMode.reply
          ? replyMessage
          : json.encode(content).replaceAll('\\', ''),
      'room': roomId,
      'created_by': getIt<UserProfileManager>().user!.id,
      'created_at': currentMessageModel.createdAt,
    };

    status = getIt<SocketManager>().emit(SocketConstants.sendMessage, message);

    // save message to database
    getIt<DBManager>().saveMessage(roomId, currentMessageModel);
    setReplyMessage(message: null);
    return status;
  }

  addNewMessage(
      {required ChatMessageModel message, required int roomId}) async {
    if (roomId != message.roomId) {
      return;
    }
    // add date separator
    if (messages.isNotEmpty) {
      String dateTimeStr = messages.last.date;
      if (dateTimeStr != message.date) {
        ChatMessageModel separatorMessage = ChatMessageModel();
        separatorMessage.createdAt = message.createdAt;
        separatorMessage.isDateSeparator = true;
        messages.add(separatorMessage);
      }
    }

    messages.add(message);

    // prepare smart reply suggestion messages
    if (message.messageContentType == MessageContentType.text &&
        message.isDateSeparator == false &&
        message.isMineMessage == false) {
      // TextMessage lastMsg = TextMessage(
      //   text: message.messageContent,
      //   timestamp: DateTime.now(),
      //   userId: message.senderId.toString(),
      //   isLocalUser: message.isMineMessage(),
      // );

      // smartReply.suggestReplies(message.messageContent,
      //     message.createdAt, message.senderId.toString());

      smartReply.addMessageToConversationFromRemoteUser(message.messageContent,
          DateTime.now().millisecondsSinceEpoch, message.senderId.toString());

      // var result = await smartReply.suggestReplies([lastMsg]);
      final response = await smartReply.suggestReplies();

      smartReplySuggestions.value = List.from(response.suggestions);
      update();
    } else {
      smartReplySuggestions.clear();
      update();
    }
  }

  Future<bool> forwardSelectedMessages(UserModel user) async {
    bool status = true;
    for (ChatMessageModel msg in selectedMessages) {
      await forwardMessage(msg: msg, opponentUser: user).then((value) {
        status = value;
      });
    }
    return status;
    // selectedMessages.clear();
    // update();
  }

  Future<Map<String, String>> uploadMedia(
      {required BuildContext context,
      required String messageId,
      required Media media,
      required Function(UploadedGalleryMedia) callback}) async {
    Map<String, String> gallery = {};

    await AppUtil.checkInternet().then((value) async {
      if (value) {
        Uint8List mainFileData = media.mediaByte!;
        File mainFile;
        String? videoThumbnailPath;
        String messageMediaDirectoryPath =
            await messageMediaDirectory(messageId);

        if (media.mediaType == GalleryMediaType.image) {
          //image media

          String imagePath = '$messageMediaDirectoryPath/$messageId.png';
          mainFile = await File(imagePath).create();
          mainFile.writeAsBytesSync(mainFileData);
        } else if (media.mediaType == GalleryMediaType.video) {
          // video
          String videoPath = '$messageMediaDirectoryPath/$messageId.mp4';

          mainFile = await File(videoPath).create();
          mainFile.writeAsBytesSync(mainFileData);

          String thumbnailPath = '$messageMediaDirectoryPath/$messageId.png';
          File videoThumbnail = await File(thumbnailPath).create();
          videoThumbnail.writeAsBytesSync(media.thumbnail!);

          await ApiController()
              .uploadFile(file: videoThumbnail.path, type: UploadMediaType.chat)
              .then((response) async {
            videoThumbnailPath = response.postedMediaCompletePath!;
            // await videoThumbnail.delete();
          });
        } else {
          // audio
          String audioPath = '$messageMediaDirectoryPath/$messageId.mp3';
          mainFile = await File(audioPath).create();
          mainFile.writeAsBytesSync(mainFileData);
        }

        // EasyLoading.show(status: LocalizationString.loading);
        await ApiController()
            .uploadFile(file: mainFile.path, type: UploadMediaType.chat)
            .then((response) async {
          String mainFileUploadedPath = response.postedMediaCompletePath!;

          // await mainFile.delete();

          UploadedGalleryMedia uploadedGalleryMedia = UploadedGalleryMedia(
              mediaType: media.mediaType == GalleryMediaType.image
                  ? 1
                  : media.mediaType == GalleryMediaType.video
                      ? 2
                      : 3,
              thumbnail: media.mediaType == GalleryMediaType.image
                  ? mainFileUploadedPath
                  : media.mediaType == GalleryMediaType.video
                      ? videoThumbnailPath!
                      : null,
              video: media.mediaType == GalleryMediaType.image
                  ? mainFileUploadedPath
                  : null,
              audio: media.mediaType == GalleryMediaType.audio
                  ? mainFileUploadedPath
                  : null);
          callback(uploadedGalleryMedia);
        });
      } else {
        AppUtil.showToast(
            context: context,
            message: LocalizationString.noInternet,
            isSuccess: false);
      }
    });
    return gallery;
  }

  deleteMessage({required int deleteScope}) async {
    // remove message in local database
    await getIt<DBManager>()
        .deleteMessages(chatRoom: chatRoom, messagesToDelete: selectedMessages);

    // remove saved media
    getIt<FileManager>().multipleDeleteMessageMedia(selectedMessages);

    // delete message in local cache
    messages.value = messages.map((element) {
      if (selectedMessages
          .map((element) => element.localMessageId)
          .toList()
          .contains(element.localMessageId)) {
        element.isDeleted = 1;
      } else {}
      return element;
    }).toList();
    messages.refresh();

    //delete message from server
    for (ChatMessageModel message in selectedMessages) {
      getIt<SocketManager>().emit(SocketConstants.deleteMessage, {
        'id': message.id,
        'room': message.roomId,
        'deleteScope': deleteScope
      });
    }
    // selectedMessages.clear();
    setToActionMode(mode: ChatMessageActionMode.none);
    update();
  }

  addNewContact(Contact contact) async {
    await contact.insert();
  }

  //*************** updates from socket *******************//

  messagedDeleted({required int messageId, required int roomId}) async {
    // update message in local cache
    if (chatRoomId == roomId) {
      messages.value = messages.map((element) {
        if (element.id == messageId) {
          element.isDeleted = 1;
        } else {}
        return element;
      }).toList();
      messages.refresh();
    }

    // delete media messages
    List<ChatMessageModel> messagesList = await getIt<DBManager>()
        .getMessagesById(messageId: messageId, roomId: roomId);

    // remove saved media
    getIt<FileManager>().multipleDeleteMessageMedia(messagesList);

    // delete message in local database
    getIt<DBManager>()
        .messagedDeleted(chatRoomId: roomId, messageId: messageId);
  }

  newMessageReceived(ChatMessageModel message) {
    if (chatRoomId == message.roomId) {
      addNewMessage(message: message, roomId: message.roomId);

      isTyping.value = false;
      isTyping.refresh();
    } else {
      showNewMessageBanner(message);
      getIt<DBManager>().updateUnReadCount(roomId: message.roomId);
    }

    getIt<DBManager>().saveMessage(message.roomId, message);
    update();
  }

  messageUpdateReceived(Map<String, dynamic> updatedData) {
    String localMessageId = updatedData['localMessageId'];
    int messageId = updatedData['id'];
    int status = updatedData['current_status'];
    int createdAt = updatedData['created_at'];
    int roomId = updatedData['room'];

    if (chatRoomId == roomId) {
      var message =
          messages.where((e) => e.localMessageId == localMessageId).first;
      message.id = messageId;
      message.status = status;
      message.createdAt = createdAt;
      message.media = null;
      if (message.messageContentType == MessageContentType.reply) {
        message.reply.media = null;
      }
      messages.refresh();

      update();
    }

    getIt<DBManager>().updateMessageStatus(
        roomId: roomId,
        localMessageId: localMessageId,
        id: messageId,
        status: status,
        createdAt: createdAt);
  }

  userTypingStatusChanged({required String userName, required bool status}) {
    if (opponent.value?.userName == userName) {
      typingStatusUpdatedAt = DateTime.now();
      isTyping.value = status;
      isTyping.refresh();

      if (status == true) {
        Timer(const Duration(seconds: 5), () {
          if (typingStatusUpdatedAt != null) {
            if (DateTime.now().difference(typingStatusUpdatedAt!).inSeconds >
                4) {
              isTyping.value = false;
              isTyping.refresh();
            }
          } else {
            isTyping.value = false;
            isTyping.refresh();
          }
        });
      }
    }
  }

  userAvailabilityStatusChange({required int userId, required bool isOnline}) {
    if (userId == opponent.value?.id) {
      opponent.value?.isOnline = isOnline;
      opponent.refresh();
    }
  }

  // call
  void initiateVideoCall(BuildContext context) {
    PermissionUtils.requestPermission(
        [Permission.camera, Permission.microphone], context,
        isOpenSettings: false, permissionGrant: () async {
      Call call = Call(
          uuid: '',
          callId: 0,
          channelName: '',
          token: '',
          isOutGoing: true,
          callType: 2,
          opponent: opponent.value!);

      agoraCallController.makeCallRequest(call: call);
    }, permissionDenied: () {}, permissionNotAskAgain: () {});
  }

  void initiateAudioCall(BuildContext context) {
    PermissionUtils.requestPermission([Permission.microphone], context,
        isOpenSettings: false, permissionGrant: () async {
      Call call = Call(
          uuid: '',
          callId: 0,
          channelName: '',
          token: '',
          isOutGoing: true,
          callType: 1,
          opponent: opponent.value!);

      agoraCallController.makeCallRequest(call: call);
    }, permissionDenied: () {}, permissionNotAskAgain: () {});
  }
}
