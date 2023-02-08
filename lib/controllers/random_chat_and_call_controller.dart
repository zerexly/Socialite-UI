import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class RandomChatAndCallController extends GetxController {
  final ChatDetailController _chatDetailController = Get.find();

  Rx<UserModel?> randomOnlineUser = Rx<UserModel?>(null);
  bool stopSearching = false;

  clear() {
    randomOnlineUser.value = null;
    stopSearching = true;
    print('clear');
  }

  getRandomOnlineUsers({bool? startFresh, int? profileCategoryType}) {
    print('stopSearching $stopSearching');

    if (startFresh == true) {
      stopSearching = false;
    }
    if (stopSearching == false) {
      ApiController()
          .getRandomOnlineUsers(profileCategoryType)
          .then((response) {
        if (response.randomOnlineUsers.isEmpty) {
          getRandomOnlineUsers(
              startFresh: false, profileCategoryType: profileCategoryType);
        } else {
          Timer(const Duration(seconds: 2), () {
            // randomOnlineUsers.refresh();
            response.randomOnlineUsers.shuffle();
            // randomOnlineUser.value = response.randomOnlineUsers.first;
            // randomOnlineUser.refresh();

            _chatDetailController.getChatRoomWithUser(
                userId: response.randomOnlineUsers.first.id,
                callback: (room) {
                  EasyLoading.dismiss();

                  Get.close(1);
                  Get.to(() => ChatDetail(
                        // opponent: usersList[index - 1].toChatRoomMember,
                        chatRoom: room,
                      ));
                });
          });
        }
      });
    }
  }
}
