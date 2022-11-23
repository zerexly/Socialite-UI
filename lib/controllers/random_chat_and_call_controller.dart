import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class RandomChatAndCallController extends GetxController {
  Rx<UserModel?> randomOnlineUser = Rx<UserModel?>(null);
  bool stopSearching = false;

  clear() {
    randomOnlineUser.value = null;
    stopSearching = true;
  }

  getRandomOnlineUsers(bool? startFresh) {
    if (startFresh == true) {
      stopSearching = false;
    }
    if (stopSearching == false) {
      ApiController().getRandomOnlineUsers().then((response) {
        if (response.randomOnlineUsers.isEmpty) {
          getRandomOnlineUsers(false);
        } else {
          Timer(const Duration(seconds: 2), () {
            // randomOnlineUsers.refresh();
            response.randomOnlineUsers.shuffle();
            randomOnlineUser.value = response.randomOnlineUsers.first;
            randomOnlineUser.refresh();
          });
        }
      });
    }
  }
}
