import 'dart:convert';
import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class ChatDetailController extends GetxController {
  final AgoraCallController agoraCallController = Get.find();

  Rx<TextEditingController> messageTf = TextEditingController().obs;

  bool expandActions = false;

  // RxMap<String, dynamic> isOnlineMapping = <String, dynamic>{}.obs;
  RxMap<String, dynamic> isTypingMapping = <String, dynamic>{}.obs;

  // RxBool isOnline = false.obs;
  // RxBool isTyping = false.obs;
  RxString wallpaper = "assets/chatbg/chatbg3.jpg".obs;

  Rx<ChatMessageActionMode> actionMode = ChatMessageActionMode.none.obs;
  RxList<ChatMessageModel> selectedMessages = <ChatMessageModel>[].obs;
  RxList<ChatMessageModel> messages = <ChatMessageModel>[].obs;

  RxList<String> smartReplySuggestions = <String>[].obs;
  Rx<ChatMessageModel?> selectedMessage = Rx<ChatMessageModel?>(null);

  bool isLoading = false;

  // int chatRoomId = 0;

  Rx<ChatRoomModel?> chatRoom = Rx<ChatRoomModel?>(null);

  // RxList<ChatRoomMember> opponents = <ChatRoomMember>[].obs;
  DateTime? typingStatusUpdatedAt;

  RxSet<String> whoIsTyping = RxSet<String>();
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
    chatRoom.value = null;
    // opponents.value = [];
    actionMode.value = ChatMessageActionMode.none;
    selectedMessage.value = null;
    typingStatusUpdatedAt = null;
  }

  //create chat room directory
  Future<String> messageMediaDirectory(String localMessageId) async {
    final appDir = await getApplicationDocumentsDirectory();

    final Directory chatRoomDirectory =
        Directory('${appDir.path}/${chatRoom.value!.id}/$localMessageId');

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

  deleteChat() {
    messages.clear();
    update();
  }

  getChatRoomWithUser(int userId, Function(ChatRoomModel) callback) {
    createChatRoom(userId, (roomId) async {
      ApiController().getChatRoomDetail(roomId).then((response) {
        if (response.room != null) {
          callback(response.room!);
          getIt<DBManager>().saveRoom(response.room!);
        }
      });
    });
  }

  loadChat(ChatRoomModel chatRoom) async {
    this.chatRoom.value = chatRoom;
    this.chatRoom.refresh();

    messages.value = await getIt<DBManager>().getAllMessages(chatRoom.id);
    loadWallpaper(this.chatRoom.value!.id);

    update();
  }

  getRoomDetail(int roomId, Function(ChatRoomModel) callback) async {
    ChatRoomModel? chatRoom = await getIt<DBManager>().getRoomById(roomId);

    if (chatRoom == null) {
      await ApiController().getChatRoomDetail(roomId).then((response) {
        callback(response.room!);
      });
    } else {
      callback(chatRoom);
    }
  }

  loadWallpaper(int roomId) async {
    wallpaper.value = await SharedPrefs().getWallpaper(roomId: roomId);
  }

//1667195394
  createChatRoom(int userId, Function(int) callback) {
    ApiController().createChatRoom(userId).then((response) {
      getIt<SocketManager>().emit(SocketConstants.addUserInChatRoom, {
        'userId': '${getIt<UserProfileManager>().user!.id},$userId'.toString(),
        'room': response.roomId
      });

      callback(response.roomId);
    });
  }

  isSelected(ChatMessageModel message) {
    return selectedMessages.contains(message);
  }

  starMessage(ChatMessageModel message) {
    message.isStar = 1;
    selectedMessages.refresh();
    getIt<DBManager>().starUnStarMessage(
        roomId: message.roomId,
        localMessageId: message.localMessageId,
        isStar: 1);
    update();
  }

  unStarMessage(ChatMessageModel message) {
    message.isStar = 0;
    selectedMessages.refresh();
    getIt<DBManager>().starUnStarMessage(
        roomId: message.roomId,
        localMessageId: message.localMessageId,
        isStar: 0);
    update();
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

  // updateOnlineStatus() {
  //   isOnline.value = !isOnline.value;
  //   update();
  // }

  expandCollapseActions() {
    expandActions = !expandActions;
    update();
  }

  messageChanges() {
    getIt<SocketManager>()
        .emit(SocketConstants.typing, {'room': chatRoom.value!.id});
    messageTf.refresh();
    // update();
  }

  sendMessageAsRead(ChatMessageModel message) {
    messages.value = messages.map((element) {
      element.status = 3;
      return element;
    }).toList();

    getIt<SocketManager>().emit(SocketConstants.readMessage,
        {'id': message.id, 'room': message.roomId});
    // messages.refresh();
    // update();
    getIt<DBManager>().updateMessageStatus(
        roomId: message.roomId,
        localMessageId: message.localMessageId,
        id: message.id,
        status: 3);
  }

  /// Todo : instead of opponent send chatroom id
  Future<bool> sendPostAsMessage(
      {required PostModel post, required ChatRoomModel room}) async {
    bool status = true;
    // await getChatRoomWithUser(toOpponent.id, (room) {
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
      'room': room.id,
      'created_by': getIt<UserProfileManager>().user!.id,
      'created_at': (DateTime.now().millisecondsSinceEpoch / 1000).round(),
    };

    ChatMessageModel localMessageModel = ChatMessageModel();
    localMessageModel.localMessageId = localMessageId;
    localMessageModel.roomId = room.id;
    // localMessageModel.messageTime = LocalizationString.justNow;
    localMessageModel.userName = LocalizationString.you;
    localMessageModel.senderId = getIt<UserProfileManager>().user!.id;
    localMessageModel.messageType = messageTypeId(MessageContentType.post);
    localMessageModel.messageContent =
        json.encode(content).replaceAll('\\', '');
    localMessageModel.createdAt =
        (DateTime.now().millisecondsSinceEpoch / 1000).round();

    addNewMessage(message: localMessageModel, roomId: room.id);
    // save message to database
    getIt<DBManager>().saveMessage(room, localMessageModel);
    // send message to socket server

    status = getIt<SocketManager>().emit(SocketConstants.sendMessage, message);
    update();
    // });

    return status;
  }

  Future<bool> sendUserProfileAsMessage(
      {required UserModel user, required ChatRoomModel room}) async {
    bool status = true;
    String localMessageId = randomId();

    var content = {
      'userId': user.id,
      'userPicture': user.picture,
      'userName': user.userName,
      'location':
          user.city != null ? '${user.city ?? ''}, ${user.country ?? ''}' : '',
    };

    var message = {
      'userId': getIt<UserProfileManager>().user!.id,
      'localMessageId': localMessageId,
      'messageType': messageTypeId(MessageContentType.profile),
      'message': json.encode(content),
      'room': room.id,
      'created_by': getIt<UserProfileManager>().user!.id,
      'created_at': (DateTime.now().millisecondsSinceEpoch / 1000).round(),
    };

    ChatMessageModel localMessageModel = ChatMessageModel();
    localMessageModel.localMessageId = localMessageId;
    localMessageModel.roomId = room.id;
    // localMessageModel.messageTime = LocalizationString.justNow;
    localMessageModel.userName = LocalizationString.you;
    localMessageModel.senderId = getIt<UserProfileManager>().user!.id;
    localMessageModel.messageType = messageTypeId(MessageContentType.profile);
    localMessageModel.messageContent =
        json.encode(content).replaceAll('\\', '');
    localMessageModel.createdAt =
        (DateTime.now().millisecondsSinceEpoch / 1000).round();

    addNewMessage(message: localMessageModel, roomId: room.id);
    // save message to database
    getIt<DBManager>().saveMessage(room, localMessageModel);
    // send message to socket server

    status = getIt<SocketManager>().emit(SocketConstants.sendMessage, message);
    update();

    return status;
  }

  Future<bool> sendTextMessage(
      {required ChatMessageActionMode mode,
      required BuildContext context,
      required ChatRoomModel room}) async {
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
          'room': room.id,
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
        'room': room.id,
        'created_by': getIt<UserProfileManager>().user!.id,
        'created_at': (DateTime.now().millisecondsSinceEpoch / 1000).round()
      };

      //save message to socket server
      status =
          getIt<SocketManager>().emit(SocketConstants.sendMessage, message);

      ChatMessageModel localMessageModel = ChatMessageModel();
      localMessageModel.localMessageId = localMessageId;
      localMessageModel.roomId = room.id;
      // localMessageModel.messageTime = LocalizationString.justNow;
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

      addNewMessage(message: localMessageModel, roomId: room.id);
      // save message to database
      getIt<DBManager>().saveMessage(room, localMessageModel);

      setReplyMessage(message: null);
      messageTf.value.text = '';
      messageTf.refresh();
      update();
    }

    return status;
  }

  Future<bool> sendContactMessage(
      {required Contact contact,
      required ChatMessageActionMode mode,
      required BuildContext context,
      required ChatRoomModel room}) async {
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
        'room': room.id,
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
      'room': room.id,
      'created_by': getIt<UserProfileManager>().user!.id,
      'created_at': (DateTime.now().millisecondsSinceEpoch / 1000).round()
    };

    //save message to socket server
    status = getIt<SocketManager>().emit(SocketConstants.sendMessage, message);

    ChatMessageModel localMessageModel = ChatMessageModel();
    localMessageModel.localMessageId = localMessageId;
    localMessageModel.roomId = room.id;
    // localMessageModel.messageTime = LocalizationString.justNow;
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

    addNewMessage(message: localMessageModel, roomId: room.id);
    // save message to database
    getIt<DBManager>().saveMessage(room, localMessageModel);

    setReplyMessage(message: null);
    update();
    return status;
  }

  Future<bool> sendLocationMessage(
      {required LocationModel location,
      required ChatMessageActionMode mode,
      required BuildContext context,
      required ChatRoomModel room}) async {
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
        'room': room.id,
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
      'room': room.id,
      'created_by': getIt<UserProfileManager>().user!.id,
      'created_at': (DateTime.now().millisecondsSinceEpoch / 1000).round()
    };

    //save message to socket server
    status = getIt<SocketManager>().emit(SocketConstants.sendMessage, message);

    ChatMessageModel localMessageModel = ChatMessageModel();
    localMessageModel.localMessageId = localMessageId;
    localMessageModel.roomId = room.id;
    // localMessageModel.messageTime = LocalizationString.justNow;
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

    addNewMessage(message: localMessageModel, roomId: room.id);
    // save message to database
    getIt<DBManager>().saveMessage(room, localMessageModel);

    setReplyMessage(message: null);
    update();
    return status;
  }

  Future<bool> sendSmartMessage(
      {required String smartMessage, required ChatRoomModel room}) async {
    bool status = true;
    String localMessageId = randomId();

    var message = {
      'userId': getIt<UserProfileManager>().user!.id,
      'localMessageId': localMessageId,
      'messageType': messageTypeId(MessageContentType.text),
      'message': smartMessage,
      'room': room.id,
      'created_by': getIt<UserProfileManager>().user!.id,
      'created_at': (DateTime.now().millisecondsSinceEpoch / 1000).round()
    };

    //save message to socket server
    status = getIt<SocketManager>().emit(SocketConstants.sendMessage, message);

    ChatMessageModel localMessageModel = ChatMessageModel();
    localMessageModel.localMessageId = localMessageId;
    localMessageModel.roomId = room.id;
    // localMessageModel.messageTime = LocalizationString.justNow;
    localMessageModel.userName = LocalizationString.you;
    localMessageModel.senderId = getIt<UserProfileManager>().user!.id;
    localMessageModel.messageType = messageTypeId(MessageContentType.text);
    localMessageModel.messageContent = smartMessage;
    localMessageModel.createdAt =
        (DateTime.now().millisecondsSinceEpoch / 1000).round();

    addNewMessage(message: localMessageModel, roomId: room.id);
    // save message to database
    getIt<DBManager>().saveMessage(room, localMessageModel);
    setReplyMessage(message: null);
    update();
    return status;
  }

  Future<bool> forwardMessage(
      {required ChatMessageModel msg, required ChatRoomModel room}) async {
    bool status = true;

    String localMessageId = randomId();
    // getChatRoomWithUser(opponentUser.id, (room) {
    var originalContent = {
      'originalMessage': msg.messageContentType == MessageContentType.reply
          ? msg.reply.toJson()
          : msg.messageContentType == MessageContentType.forward
              ? msg.originalMessage.toJson()
              : msg.toJson(),
    };

    ChatMessageModel localMessageModel = ChatMessageModel();
    localMessageModel.localMessageId = localMessageId;
    localMessageModel.roomId = room.id;
    // localMessageModel.messageTime = LocalizationString.justNow;
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
      'room': room.id,
      'created_by': getIt<UserProfileManager>().user!.id,
      'created_at': localMessageModel.createdAt,
    };

    status = getIt<SocketManager>().emit(SocketConstants.sendMessage, message);
    getIt<DBManager>().saveMessage(room, localMessageModel);
    // });
    return status;
  }

  Future<bool> sendImageMessage(
      {required BuildContext context,
      required Media media,
      required ChatMessageActionMode mode,
      required ChatRoomModel room}) async {
    bool status = true;

    String localMessageId = randomId();
    String? replyMessageStringContent;

    // store image in local storage
    File mainFile = await FileManager.saveChatMediaToDirectory(
        media, localMessageId, false, chatRoom.value!.id);

    ChatMessageModel topLevelMessageModel = ChatMessageModel();

    if (mode == ChatMessageActionMode.reply) {
      topLevelMessageModel.localMessageId = localMessageId;
      topLevelMessageModel.roomId = room.id;
      topLevelMessageModel.userName = LocalizationString.you;
      topLevelMessageModel.senderId = getIt<UserProfileManager>().user!.id;
      topLevelMessageModel.messageType =
          messageTypeId(MessageContentType.reply);
      topLevelMessageModel.originalMessageContent = selectedMessage.value;

      // reply content start
      ChatMessageModel replyContentMessage = ChatMessageModel();
      replyContentMessage.id = 0;
      replyContentMessage.roomId = room.id;
      replyContentMessage.localMessageId = localMessageId;
      replyContentMessage.senderId = getIt<UserProfileManager>().user!.id;
      replyContentMessage.messageType = messageTypeId(MessageContentType.photo);
      replyContentMessage.messageContent = '';
      replyContentMessage.createdAt =
          (DateTime.now().millisecondsSinceEpoch / 1000).round();

      topLevelMessageModel.replyMessageContent = replyContentMessage;
      // reply content end

      topLevelMessageModel.createdAt =
          (DateTime.now().millisecondsSinceEpoch / 1000).round();
      topLevelMessageModel.messageContent = '';

      addNewMessage(message: topLevelMessageModel, roomId: room.id);
      getIt<DBManager>().saveMessage(room, topLevelMessageModel);
    } else {
      topLevelMessageModel.localMessageId = localMessageId;
      topLevelMessageModel.roomId = room.id;
      // localMessageModel.messageTime = LocalizationString.justNow;
      topLevelMessageModel.userName = LocalizationString.you;
      topLevelMessageModel.senderId = getIt<UserProfileManager>().user!.id;
      topLevelMessageModel.messageType = messageTypeId(
          mode == ChatMessageActionMode.reply
              ? MessageContentType.reply
              : MessageContentType.photo);
      topLevelMessageModel.createdAt =
          (DateTime.now().millisecondsSinceEpoch / 1000).round();
      topLevelMessageModel.messageContent = '';
      // localMessageModel.media = media;

      addNewMessage(message: topLevelMessageModel, roomId: room.id);
      getIt<DBManager>().saveMessage(room, topLevelMessageModel);
    }

    update();

    // upload photo and send message

    uploadMedia(
        context: context,
        messageId: localMessageId,
        media: media,
        mainFile: mainFile,
        callback: (uploadedMedia) {
          var content = {
            'image': uploadedMedia.thumbnail!,
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
              'room': room.id
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
            'room': room.id,
            'created_by': getIt<UserProfileManager>().user!.id,
            'created_at': topLevelMessageModel.createdAt,
          };

          // send message to socket
          status =
              getIt<SocketManager>().emit(SocketConstants.sendMessage, message);

          // update in cache message

          topLevelMessageModel.messageContent =
              mode == ChatMessageActionMode.reply
                  ? replyMessageStringContent!
                  : json.encode(content);
          topLevelMessageModel.replyMessageContent = null;
          topLevelMessageModel.originalMessageContent = null;
          // update message in local database
          getIt<DBManager>().updateMessageContent(
              room.id,
              topLevelMessageModel.localMessageId.toString(),
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
      required ChatMessageActionMode mode,
      required ChatRoomModel room}) async {
    bool status = true;

    String localMessageId = randomId();
    String? replyMessageStringContent;

    // store video in local storage
    File mainFile = await FileManager.saveChatMediaToDirectory(
        media, localMessageId, false, chatRoom.value!.id);

    // store image in local storage
    File videoThumbnail = await FileManager.saveChatMediaToDirectory(
        media, localMessageId, true, chatRoom.value!.id);

    ChatMessageModel topLevelMessageModel = ChatMessageModel();

    if (mode == ChatMessageActionMode.reply) {
      topLevelMessageModel.localMessageId = localMessageId;
      topLevelMessageModel.roomId = room.id;
      // localMessageModel.messageTime = LocalizationString.justNow;
      topLevelMessageModel.userName = LocalizationString.you;
      topLevelMessageModel.senderId = getIt<UserProfileManager>().user!.id;
      topLevelMessageModel.messageType =
          messageTypeId(MessageContentType.reply);
      topLevelMessageModel.originalMessageContent = selectedMessage.value;

      // reply content start
      ChatMessageModel replyMessage = ChatMessageModel();
      replyMessage.id = 0;
      replyMessage.roomId = room.id;
      replyMessage.localMessageId = localMessageId;
      replyMessage.senderId = getIt<UserProfileManager>().user!.id;
      replyMessage.messageType = messageTypeId(MessageContentType.video);
      // replyMessage.media = media;
      replyMessage.messageContent = '';
      replyMessage.createdAt =
          (DateTime.now().millisecondsSinceEpoch / 1000).round();

      topLevelMessageModel.replyMessageContent = replyMessage;
      // reply content end

      topLevelMessageModel.createdAt =
          (DateTime.now().millisecondsSinceEpoch / 1000).round();
      topLevelMessageModel.messageContent = '';
      messages.value = [topLevelMessageModel];

      getIt<DBManager>().saveMessage(room, topLevelMessageModel);
    } else {
      topLevelMessageModel.localMessageId = localMessageId;
      topLevelMessageModel.roomId = room.id;
      // localMessageModel.messageTime = LocalizationString.justNow;
      topLevelMessageModel.userName = LocalizationString.you;
      topLevelMessageModel.senderId = getIt<UserProfileManager>().user!.id;
      topLevelMessageModel.messageType = messageTypeId(
          mode == ChatMessageActionMode.reply
              ? MessageContentType.reply
              : MessageContentType.video);
      topLevelMessageModel.createdAt =
          (DateTime.now().millisecondsSinceEpoch / 1000).round();
      topLevelMessageModel.messageContent = '';
      // localMessageModel.media = media;

      addNewMessage(message: topLevelMessageModel, roomId: room.id);
      getIt<DBManager>().saveMessage(room, topLevelMessageModel);
    }

    update();

    // upload video and send message

    uploadMedia(
        context: context,
        messageId: localMessageId,
        media: media,
        mainFile: mainFile,
        thumbnailFile: videoThumbnail,
        callback: (uploadedMedia) {
          var content = {
            'image': uploadedMedia.thumbnail,
            'video': uploadedMedia.video!,
          };

          if (mode == ChatMessageActionMode.reply) {
            var currentMessage = {
              'userId': getIt<UserProfileManager>().user!.id,
              'created_by': getIt<UserProfileManager>().user!.id,
              'username': LocalizationString.you,
              'created_at':
                  (DateTime.now().millisecondsSinceEpoch / 1000).round(),
              'localMessageId': localMessageId,
              'messageType': messageTypeId(MessageContentType.video),
              'message': json.encode(content),
              'room': room.id
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
                : MessageContentType.video),
            'message': mode == ChatMessageActionMode.reply
                ? replyMessageStringContent
                : json.encode(content),
            'room': room.id,
            'created_by': getIt<UserProfileManager>().user!.id,
            'created_at': topLevelMessageModel.createdAt,
          };

          // send message to socket
          status =
              getIt<SocketManager>().emit(SocketConstants.sendMessage, message);

          // update in cache message
          topLevelMessageModel.messageContent =
              mode == ChatMessageActionMode.reply
                  ? replyMessageStringContent!
                  : json.encode(content);
          topLevelMessageModel.replyMessageContent = null;
          topLevelMessageModel.originalMessageContent = null;

          update();

          // update message in local database
          getIt<DBManager>().updateMessageContent(
              room.id,
              topLevelMessageModel.localMessageId.toString(),
              mode == ChatMessageActionMode.reply
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
      required ChatRoomModel room}) async {
    bool status = true;

    String localMessageId = randomId();
    String? replyMessageStringContent;

    // store audio in local storage
    File mainFile = await FileManager.saveChatMediaToDirectory(
        media, localMessageId, false, chatRoom.value!.id);

    ChatMessageModel topLevelMessageModel = ChatMessageModel();

    if (mode == ChatMessageActionMode.reply) {
      topLevelMessageModel.localMessageId = localMessageId;
      topLevelMessageModel.roomId = room.id;
      // localMessageModel.messageTime = LocalizationString.justNow;
      topLevelMessageModel.userName = LocalizationString.you;
      topLevelMessageModel.senderId = getIt<UserProfileManager>().user!.id;
      topLevelMessageModel.messageType =
          messageTypeId(MessageContentType.reply);
      topLevelMessageModel.originalMessageContent = selectedMessage.value;

      // reply content start
      ChatMessageModel replyMessage = ChatMessageModel();
      replyMessage.id = 0;
      replyMessage.roomId = room.id;
      replyMessage.localMessageId = localMessageId;
      replyMessage.senderId = getIt<UserProfileManager>().user!.id;
      replyMessage.messageType = messageTypeId(MessageContentType.audio);
      // replyMessage.media = media;
      replyMessage.messageContent = '';
      replyMessage.createdAt =
          (DateTime.now().millisecondsSinceEpoch / 1000).round();

      topLevelMessageModel.replyMessageContent = replyMessage;
      // reply content end

      topLevelMessageModel.createdAt =
          (DateTime.now().millisecondsSinceEpoch / 1000).round();
      topLevelMessageModel.messageContent = '';

      addNewMessage(message: topLevelMessageModel, roomId: room.id);
      getIt<DBManager>().saveMessage(room, topLevelMessageModel);
    } else {
      topLevelMessageModel.localMessageId = localMessageId;
      topLevelMessageModel.roomId = room.id;
      // localMessageModel.messageTime = LocalizationString.justNow;
      topLevelMessageModel.userName = LocalizationString.you;
      topLevelMessageModel.senderId = getIt<UserProfileManager>().user!.id;
      topLevelMessageModel.messageType = messageTypeId(
          mode == ChatMessageActionMode.reply
              ? MessageContentType.reply
              : MessageContentType.audio);
      topLevelMessageModel.createdAt =
          (DateTime.now().millisecondsSinceEpoch / 1000).round();
      topLevelMessageModel.messageContent = '';
      // localMessageModel.media = media;

      addNewMessage(message: topLevelMessageModel, roomId: room.id);
      getIt<DBManager>().saveMessage(room, topLevelMessageModel);
    }

    update();

    // upload audio and send message

    uploadMedia(
        context: context,
        messageId: localMessageId,
        media: media,
        mainFile: mainFile,
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
              'room': room.id
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
            'room': room.id,
            'created_by': getIt<UserProfileManager>().user!.id,
            'created_at': topLevelMessageModel.createdAt,
          };

          // send message to socket
          status =
              getIt<SocketManager>().emit(SocketConstants.sendMessage, message);

          // update in cache message

          topLevelMessageModel.messageContent =
              mode == ChatMessageActionMode.reply
                  ? replyMessageStringContent!
                  : json.encode(content);
          topLevelMessageModel.replyMessageContent = null;
          topLevelMessageModel.originalMessageContent = null;
          // update message in local database
          getIt<DBManager>().updateMessageContent(
              room.id,
              topLevelMessageModel.localMessageId.toString(),
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
      required ChatRoomModel room}) async {
    bool status = true;
    String localMessageId = randomId();
    String? replyMessage;

    var content = {'image': gif, 'video': ''};

    ChatMessageModel currentMessageModel = ChatMessageModel();

    if (mode == ChatMessageActionMode.reply) {
      currentMessageModel.localMessageId = localMessageId;
      currentMessageModel.roomId = room.id;
      // currentMessageModel. messageTime= LocalizationString.justNow;
      currentMessageModel.userName = LocalizationString.you;
      currentMessageModel.senderId = getIt<UserProfileManager>().user!.id;
      currentMessageModel.messageType = messageTypeId(MessageContentType.reply);
      currentMessageModel.originalMessageContent = selectedMessage.value;

      // reply content start
      ChatMessageModel replyMessage = ChatMessageModel();
      replyMessage.id = 0;
      replyMessage.roomId = room.id;
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

      addNewMessage(message: currentMessageModel, roomId: room.id);
      getIt<DBManager>().saveMessage(room, currentMessageModel);
    } else {
      currentMessageModel.localMessageId = localMessageId;
      currentMessageModel.roomId = room.id;
      // currentMessageModel.messageTime = LocalizationString.justNow;
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

      addNewMessage(message: currentMessageModel, roomId: room.id);
      getIt<DBManager>().saveMessage(room, currentMessageModel);
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
        'room': room.id
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
      'room': room.id,
      'created_by': getIt<UserProfileManager>().user!.id,
      'created_at': currentMessageModel.createdAt,
    };

    status = getIt<SocketManager>().emit(SocketConstants.sendMessage, message);

    // save message to database
    getIt<DBManager>().saveMessage(room, currentMessageModel);
    setReplyMessage(message: null);
    return status;
  }

  Future<bool> sendFileMessage(
      {required BuildContext context,
      required Media media,
      required ChatMessageActionMode mode,
      required ChatRoomModel room}) async {
    bool status = true;

    String localMessageId = randomId();
    String? replyMessageStringContent;

    // store file in local storage
    File mainFile = await FileManager.saveChatMediaToDirectory(
        media, localMessageId, false, chatRoom.value!.id);

    ChatMessageModel localMessageModel = ChatMessageModel();

    if (mode == ChatMessageActionMode.reply) {
      localMessageModel.localMessageId = localMessageId;
      localMessageModel.roomId = room.id;
      // localMessageModel.messageTime = LocalizationString.justNow;
      localMessageModel.userName = LocalizationString.you;
      localMessageModel.senderId = getIt<UserProfileManager>().user!.id;
      localMessageModel.messageType = messageTypeId(MessageContentType.reply);
      localMessageModel.originalMessageContent = selectedMessage.value;

      // reply content start
      ChatMessageModel replyMessage = ChatMessageModel();
      replyMessage.id = 0;
      replyMessage.roomId = room.id;
      replyMessage.localMessageId = localMessageId;
      replyMessage.senderId = getIt<UserProfileManager>().user!.id;
      replyMessage.messageType = messageTypeId(MessageContentType.file);
      replyMessage.media = media;
      replyMessage.messageContent = '';
      replyMessage.createdAt =
          (DateTime.now().millisecondsSinceEpoch / 1000).round();

      localMessageModel.replyMessageContent = replyMessage;
      // reply content end

      localMessageModel.createdAt =
          (DateTime.now().millisecondsSinceEpoch / 1000).round();
      localMessageModel.messageContent = '';

      addNewMessage(message: localMessageModel, roomId: room.id);
      getIt<DBManager>().saveMessage(room, localMessageModel);
    } else {
      localMessageModel.localMessageId = localMessageId;
      localMessageModel.roomId = room.id;
      // localMessageModel.messageTime = LocalizationString.justNow;
      localMessageModel.userName = LocalizationString.you;
      localMessageModel.senderId = getIt<UserProfileManager>().user!.id;
      localMessageModel.messageType = messageTypeId(
          mode == ChatMessageActionMode.reply
              ? MessageContentType.reply
              : MessageContentType.file);
      localMessageModel.createdAt =
          (DateTime.now().millisecondsSinceEpoch / 1000).round();
      localMessageModel.messageContent = '';
      localMessageModel.media = media;

      addNewMessage(message: localMessageModel, roomId: room.id);
      getIt<DBManager>().saveMessage(room, localMessageModel);
    }

    update();

    // upload file and send message

    uploadMedia(
        context: context,
        messageId: localMessageId,
        media: media,
        mainFile: mainFile,
        callback: (uploadedMedia) {
          var fileContent = {
            'path': uploadedMedia.file,
            'type': media.mediaTypeId,
            'name': media.title,
            'size': media.fileSize
          };

          var fileObject = {'file': fileContent};

          if (mode == ChatMessageActionMode.reply) {
            var currentMessage = {
              'userId': getIt<UserProfileManager>().user!.id,
              'created_by': getIt<UserProfileManager>().user!.id,
              'username': LocalizationString.you,
              'created_at':
                  (DateTime.now().millisecondsSinceEpoch / 1000).round(),
              'localMessageId': localMessageId,
              'messageType': messageTypeId(MessageContentType.file),
              'message': json.encode(fileObject),
              'room': room.id
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
                : MessageContentType.file),
            'message': mode == ChatMessageActionMode.reply
                ? replyMessageStringContent
                : json.encode(fileObject),
            'room': room.id,
            'created_by': getIt<UserProfileManager>().user!.id,
            'created_at': localMessageModel.createdAt,
          };

          // send message to socket
          status =
              getIt<SocketManager>().emit(SocketConstants.sendMessage, message);

          // update in cache message

          localMessageModel.messageContent = mode == ChatMessageActionMode.reply
              ? replyMessageStringContent!
              : json.encode(fileObject);
          localMessageModel.replyMessageContent = null;
          localMessageModel.originalMessageContent = null;
          // update message in local database
          getIt<DBManager>().updateMessageContent(
              room.id,
              localMessageModel.localMessageId.toString(),
              mode == ChatMessageActionMode.reply
                  ? replyMessageStringContent!
                  : json.encode(fileObject));
        });

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
      // String dateTimeStr = messages.last.date;
      // if (dateTimeStr != message.date) {
      //   ChatMessageModel separatorMessage = ChatMessageModel();
      //   separatorMessage.createdAt = message.createdAt;
      //   separatorMessage.isDateSeparator = true;
      //   messages.add(separatorMessage);
      // }
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

  Future<bool> forwardSelectedMessages({required ChatRoomModel room}) async {
    bool status = true;
    for (ChatMessageModel msg in selectedMessages) {
      await forwardMessage(msg: msg, room: room).then((value) {
        status = value;
      });
    }
    return status;
  }

  Future<Map<String, String>> uploadMedia(
      {required BuildContext context,
      required String messageId,
      required Media media,
      required File mainFile,
      File? thumbnailFile,
      required Function(UploadedGalleryMedia) callback}) async {
    Map<String, String> gallery = {};

    await AppUtil.checkInternet().then((value) async {
      if (value) {
        // File mainFile;
        String? videoThumbnailPath;
        // String messageMediaDirectoryPath =
        //     await messageMediaDirectory(messageId);

        if (media.mediaType == GalleryMediaType.photo) {
          // mainFile = await FileManager.saveChatMediaToDirectory(
          //     media, messageId, false, chatRoom.value!.id);
          // Uint8List mainFileData;
          // if (media.mediaByte == null) {
          //   mainFileData = await media.file!.compress();
          // } else {
          //   mainFileData = media.mediaByte!;
          // }
          // //image media
          // String imagePath = '$messageMediaDirectoryPath/$messageId.png';
          // mainFile = await File(imagePath).create();
          // mainFile.writeAsBytesSync(mainFileData);
        } else if (media.mediaType == GalleryMediaType.video) {
          // mainFile = await FileManager.saveChatMediaToDirectory(
          //     media, messageId, false, chatRoom.value!.id);
          //
          // File videoThumbnail = await FileManager.saveChatMediaToDirectory(
          //     media, messageId, true, chatRoom.value!.id);

          // String thumbnailPath = '$messageMediaDirectoryPath/$messageId.png';
          // File videoThumbnail = await File(thumbnailPath).create();
          // videoThumbnail.writeAsBytesSync(media.thumbnail!);

          await ApiController()
              .uploadFile(file: thumbnailFile!.path, type: UploadMediaType.chat)
              .then((response) async {
            videoThumbnailPath = response.postedMediaCompletePath!;
            // await videoThumbnail.delete();
          });
        } else if (media.mediaType == GalleryMediaType.audio) {
          // mainFile = await FileManager.saveChatMediaToDirectory(
          //     media, messageId, false, chatRoom.value!.id);

          // Uint8List mainFileData;
          // if (media.mediaByte == null) {
          //   mainFileData = media.file!.readAsBytesSync();
          // } else {
          //   mainFileData = media.mediaByte!;
          // }
          // // audio
          // String audioPath = '$messageMediaDirectoryPath/$messageId.mp3';
          // mainFile = await File(audioPath).create();
          // mainFile.writeAsBytesSync(mainFileData);
        } else {
          // Uint8List mainFileData;
          // if (media.mediaByte == null) {
          //   mainFileData = media.file!.readAsBytesSync();
          // } else {
          //   mainFileData = media.mediaByte!;
          // }
          // // file
          //
          // final extension = p.extension(media.file!.path); // '.dart'
          //
          // String filePath = '$messageMediaDirectoryPath/$messageId$extension';
          // mainFile = await File(filePath).create();
          // mainFile.writeAsBytesSync(mainFileData);
          // mainFile = await FileManager.saveChatMediaToDirectory(
          //     media, messageId, false, chatRoom.value!.id);
        }

        await ApiController()
            .uploadFile(file: mainFile.path, type: UploadMediaType.chat)
            .then((response) async {
          String mainFileUploadedPath = response.postedMediaCompletePath!;

          // await mainFile.delete();

          UploadedGalleryMedia uploadedGalleryMedia = UploadedGalleryMedia(
              mediaType: media.mediaType == GalleryMediaType.photo
                  ? 1
                  : media.mediaType == GalleryMediaType.video
                      ? 2
                      : 3,
              thumbnail: media.mediaType == GalleryMediaType.photo
                  ? mainFileUploadedPath
                  : media.mediaType == GalleryMediaType.video
                      ? videoThumbnailPath!
                      : null,
              video: media.mediaType == GalleryMediaType.video
                  ? mainFileUploadedPath
                  : null,
              audio: media.mediaType == GalleryMediaType.audio
                  ? mainFileUploadedPath
                  : null,
              file: mainFileUploadedPath);
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
    await getIt<DBManager>().deleteMessages(
        chatRoom: chatRoom.value!, messagesToDelete: selectedMessages);

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
    if (chatRoom.value?.id == roomId) {
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
        .messagedDeletedByOtherUser(chatRoomId: roomId, messageId: messageId);
  }

  newMessageReceived(ChatMessageModel message) async {
    if (chatRoom.value?.id == message.roomId) {
      addNewMessage(message: message, roomId: message.roomId);

      isTypingMapping[message.userName] = false;
      // isTyping.value = false;
      isTypingMapping.refresh();
      if (message.messageContentType == MessageContentType.groupAction) {
        await getRoomDetail(chatRoom.value!.id, (chatroom) {
          chatRoom.value = chatroom;
          chatRoom.refresh();
        });
      }
    } else {
      showNewMessageBanner(message, message.roomId);
      // keep this commented as it is already handled in chatcontroller
      // await getIt<DBManager>().updateUnReadCount(roomId: message.roomId);
    }

    ChatRoomModel? existingRoom =
        await getIt<DBManager>().getRoomById(message.roomId);
    if (existingRoom == null) {
      // save room in database

      await getRoomDetail(message.roomId, (chatroom) async {
        await getIt<DBManager>().saveRoom(chatroom);
        await getIt<DBManager>().saveMessage(chatroom, message);
      });
    } else {
      await getIt<DBManager>().saveMessage(existingRoom, message);
    }

    update();
  }

  messageUpdateReceived(Map<String, dynamic> updatedData) {
    String? localMessageId = updatedData['localMessageId'];
    if (localMessageId != null) {
      int messageId = updatedData['id'];
      int status = updatedData['current_status'];
      int createdAt = updatedData['created_at'];
      int roomId = updatedData['room'];

      if (chatRoom.value?.id == roomId) {
        var message =
            messages.where((e) => e.localMessageId == localMessageId).first;
        message.id = messageId;
        message.status = status;
        message.createdAt = createdAt;
        // message.media = null;
        if (message.messageContentType == MessageContentType.reply) {
          // message.reply.media = null;
        }
        messages.refresh();

        update();
      }

      getIt<DBManager>().updateMessageStatus(
          roomId: roomId,
          localMessageId: localMessageId,
          id: messageId,
          status: status);
    }
  }

  userTypingStatusChanged(
      {required String userName, required int roomId, required bool status}) {
    if (chatRoom.value?.id != roomId) {
      return;
    }
    // if (chatRoom.value!.isGroupChat == false) {
    //   if (opponents.first.userDetail.userName == userName) {
    typingStatusUpdatedAt = DateTime.now();

    isTypingMapping[userName] = status;
    // isTyping.value = status;
    isTypingMapping.refresh();

    whoIsTyping.add(userName);

    if (status == true) {
      Timer(const Duration(seconds: 5), () {
        if (typingStatusUpdatedAt != null) {
          if (DateTime.now().difference(typingStatusUpdatedAt!).inSeconds > 4) {
            isTypingMapping[userName] = false;
            isTypingMapping.refresh();
            whoIsTyping.remove(userName);
          }
        } else {
          isTypingMapping[userName] = false;
          isTypingMapping.refresh();
          whoIsTyping.remove(userName);
        }
      });
    }
    //   }
    // }
    // else{
    //
    // }
  }

  userAvailabilityStatusChange({required int userId, required bool isOnline}) {
    if (chatRoom.value != null) {
      if (chatRoom.value?.isGroupChat == false) {
        chatRoom.value!.roomMembers = chatRoom.value!.roomMembers.map((member) {
          if (member.userDetail.id == userId) {
            member.userDetail.isOnline = true;
          }
          return member;
        }).toList();

        chatRoom.refresh();

        // List<ChatRoomMember> matchedMembers = chatRoom.value!.roomMembers
        //     .where((element) => element.userDetail.id == userId)
        //     .toList();
        //
        // if (matchedMembers.isNotEmpty) {
        //   ChatRoomMember matchedMember =
        //   opponents.first.userDetail.isOnline = isOnline;
        //   opponents.refresh();
        // }
      }
    }
  }

  updatedChatGroupAccessStatus(
      {required int chatRoomId, required int chatAccessGroup}) {
    if (chatRoom.value?.id == chatRoomId) {
      chatRoom.value?.groupAccess = chatAccessGroup;
      chatRoom.refresh();
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
          opponent: chatRoom.value!.opponent.userDetail);

      agoraCallController.makeCallRequest(call: call);
    }, permissionDenied: () {
      AppUtil.showToast(
          context: context,
          message: LocalizationString.pleaseAllowAccessToCameraForVideoCall,
          isSuccess: false);
    }, permissionNotAskAgain: () {
      AppUtil.showToast(
          context: context,
          message: LocalizationString.pleaseAllowAccessToCameraForVideoCall,
          isSuccess: false);
    });
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
          opponent: chatRoom.value!.opponent.userDetail);

      agoraCallController.makeCallRequest(call: call);
    }, permissionDenied: () {
      AppUtil.showToast(
          context: context,
          message: LocalizationString.pleaseAllowAccessToMicrophoneForAudioCall,
          isSuccess: false);
    }, permissionNotAskAgain: () {
      AppUtil.showToast(
          context: context,
          message: LocalizationString.pleaseAllowAccessToMicrophoneForAudioCall,
          isSuccess: false);
    });
  }
}
