import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class MediaListViewerController extends GetxController {
  int currentIndex = 0;
  RxList<ChatMessageModel> messages = <ChatMessageModel>[].obs;

  clear() {
    messages.clear();
  }

  setMessages(List<ChatMessageModel> messagesList) {
    messages.value = messagesList;
    update();
  }

  setCurrentMediaIndex(int index) {
    currentIndex = index;
  }

  deleteMessage({required ChatRoomModel inChatRoom}) async {
    ChatMessageModel messageToDelete = messages[currentIndex];

    // remove saved media
    getIt<FileManager>().deleteMessageMedia(messageToDelete);

    // remove message in local database
    await getIt<DBManager>()
        .softDeleteMessages(messagesToDelete: [messageToDelete]);
    messages.removeAt(currentIndex);
    if (messages.isEmpty) {
      Get.back();
    } else {
      update();
    }
  }
}
