import 'package:foap/helper/common_import.dart';

class FileManager {
  deleteMessageMedia(ChatMessageModel message) async {
    final tempDir = await getApplicationDocumentsDirectory();

    String messageMediaDirectoryPath =
        '${tempDir.path}/${message.roomId.toString()}/${message.localMessageId}';

    try {
      if (await Directory(messageMediaDirectoryPath).exists()) {
        await Directory(messageMediaDirectoryPath).delete(recursive: true);
      } else {}
    } catch (e) {
      // print(e);
      // Error in getting access to the file.
    }
  }

  multipleDeleteMessageMedia(List<ChatMessageModel> messages) async {
    for (ChatMessageModel message in messages) {
      final tempDir = await getApplicationDocumentsDirectory();

      String messageMediaDirectoryPath =
          '${tempDir.path}/${message.roomId.toString()}/${message.localMessageId}';

      try {
        if (await Directory(messageMediaDirectoryPath).exists()) {
          await Directory(messageMediaDirectoryPath).delete(recursive: true);
        } else {}
      } catch (e) {
        // print(e);
        // Error in getting access to the file.
      }
    }
  }

  deleteRoomMedia(ChatRoomModel chatRoom) async {
    final tempDir = await getApplicationDocumentsDirectory();
    String localPath = '${tempDir.path}/${chatRoom.id.toString()}';

    try {
      if (await Directory(localPath).exists()) {
        await Directory(localPath).delete(recursive: true);
      }
    } catch (e) {
      // Error in getting access to the file.
    }
  }

  Future<String?> localImagePathForMessage(ChatMessageModel message) async {
    String? filePath;

    final tempDir = await getApplicationDocumentsDirectory();

    String localPath =
        '${tempDir.path}/${message.roomId.toString()}/${message.localMessageId}/${message.localMessageId}.png';

    if (File(localPath).existsSync()) {
      filePath = localPath;
    } else {}

    return filePath;
  }
}
