import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class ChatRoomDetailController extends GetxController {
  RxList<ChatMessageModel> photos = <ChatMessageModel>[].obs;
  RxList<ChatMessageModel> videos = <ChatMessageModel>[].obs;
  RxInt selectedSegment = 0.obs;

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
    List messages = await getIt<DBManager>().getAllMessages(roomId);

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
            '[${message.messageTime}] ${message.isMineMessage ? 'Me' : message.userName}: ${message.messageContent}';
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
        Share.shareFiles([zipFile.path]);
      } catch (e) {
          // print(e);
      }
    } else {
      Share.shareFiles([chatTextFile.path]);
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
    getIt<DBManager>().deleteRoom(chatRoom);
  }
}
