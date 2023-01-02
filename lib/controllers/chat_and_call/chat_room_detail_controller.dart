import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class ChatRoomDetailController extends GetxController {
  RxList<ChatMessageModel> photos = <ChatMessageModel>[].obs;
  RxList<ChatMessageModel> videos = <ChatMessageModel>[].obs;
  RxList<ChatMessageModel> starredMessages = <ChatMessageModel>[].obs;
  final ChatDetailController _chatDetailController = Get.find();
  Rx<ChatRoomModel?> room = Rx<ChatRoomModel?>(null);

  RxInt selectedSegment = 0.obs;

  getUpdatedChatRoomDetail(ChatRoomModel chatRoom) {
    ApiController().getChatRoomDetail(chatRoom.id).then((response) {
      room.value = response.room;
      room.refresh();

      // update room in local storage
      getIt<DBManager>().updateRoom(chatRoom);

      update();
    });
  }

  makeUserAsAdmin(UserModel user, ChatRoomModel chatRoom) {
    getIt<SocketManager>().emit(SocketConstants.makeUserAdmin,
        {'room': chatRoom.id, 'userId': user.id});
    getUpdatedChatRoomDetail(chatRoom);
  }

  removeUserAsAdmin(UserModel user, ChatRoomModel chatRoom) {
    getIt<SocketManager>().emit(SocketConstants.removeUserAdmin,
        {'room': chatRoom.id, 'userId': user.id});
    getUpdatedChatRoomDetail(chatRoom);
  }

  removeUserFormGroup(UserModel user, ChatRoomModel chatRoom) {
    getIt<SocketManager>().emit(SocketConstants.removeUserFromGroupChat,
        {'room': chatRoom.id, 'userId': user.id});

    getUpdatedChatRoomDetail(chatRoom);
  }

  leaveGroup(ChatRoomModel chatRoom) {
    getIt<SocketManager>()
        .emit(SocketConstants.leaveGroupChat, {'room': chatRoom.id});
  }

  updateGroupAccess(int access) {
    getIt<SocketManager>().emit(SocketConstants.updateChatAccessGroup,
        {'room': room.value!.id, 'chatAccessGroup': access});

    getUpdatedChatRoomDetail(room.value!);
  }

  deleteGroup(ChatRoomModel chatRoom) {
    getIt<DBManager>().deleteRoom(chatRoom);
  }

  getStarredMessages(ChatRoomModel room) async {
    starredMessages.value =
        await getIt<DBManager>().getStarredMessages(roomId: room.id);
    update();
  }

  unStarMessages() {
    for (ChatMessageModel message in _chatDetailController.selectedMessages) {
      _chatDetailController.unStarMessage(message);

      starredMessages.remove(message);
      if (starredMessages.isEmpty) {
        Get.back();
      } else {
        starredMessages.refresh();
      }
    }
  }

  segmentChanged(int index, int roomId) {
    selectedSegment.value = index;

    if (selectedSegment.value == 0) {
      loadImageMessages(roomId);
    } else {
      loadVideoMessages(roomId);
    }

    update();
  }

  exportChat({required int roomId, required bool includeMedia}) async {
    String? mediaFolderPath;
    Directory chatMediaDirectory;
    final appDir = await getApplicationDocumentsDirectory();
    mediaFolderPath = '${appDir.path}/${roomId.toString()}';

    chatMediaDirectory = Directory(mediaFolderPath);

    if (chatMediaDirectory.existsSync() == false) {
      await Directory(mediaFolderPath).create();
    }
    List messages =
        await getIt<DBManager>().getAllMessages(roomId: roomId, offset: 0);

    File chatTextFile = File('${chatMediaDirectory.path}/chat.text');
    if (chatTextFile.existsSync()) {
      chatTextFile.delete();
      chatTextFile = File('${chatMediaDirectory.path}/chat.text');
    }

    String messagesString = '';
    for (ChatMessageModel message in messages) {
      if (message.messageContentType == MessageContentType.text &&
          message.isDateSeparator == false) {
        messagesString += '\n';
        messagesString +=
            '[${message.messageTime}] ${message.isMineMessage ? 'Me' : message.userName}: ${message.isDeleted == true ? LocalizationString.thisMessageIsDeleted : message.messageContent}';
      }
    }

    chatTextFile.writeAsString(messagesString);

    if (includeMedia) {
      try {
        final tempDir = await getTemporaryDirectory();
        File zipFile = File('${tempDir.path}/chat.zip');
        if (zipFile.existsSync()) {
          zipFile.delete();
          zipFile = File('${tempDir.path}/chat.zip');
        }

        ZipFile.createFromDirectory(
            sourceDir: chatMediaDirectory,
            zipFile: zipFile,
            recurseSubDirs: true);
        Share.shareXFiles([XFile(zipFile.path)]);
      } catch (e) {
        // print(e);
      }
    } else {
      Share.shareXFiles([XFile(chatTextFile.path)]);
    }
  }

  loadImageMessages(int roomId) async {
    photos.value = await getIt<DBManager>()
        .getMessages(roomId: roomId, contentType: MessageContentType.photo);
    update();
  }

  loadVideoMessages(int roomId) async {
    videos.value = await getIt<DBManager>()
        .getMessages(roomId: roomId, contentType: MessageContentType.video);
    update();
  }

  deleteRoomChat(ChatRoomModel chatRoom) {
    getIt<DBManager>().deleteMessagesInRoom(chatRoom);
  }
}
