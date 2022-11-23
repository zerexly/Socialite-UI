import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class BlockedUsersController extends GetxController {
  RxList<UserModel> usersList = <UserModel>[].obs;
  bool isLoading = false;

  int blockedUserPage = 1;
  bool canLoadMoreBlockedUser = true;

  clear() {
    usersList.value = [];
    isLoading = false;
    blockedUserPage = 1;
    canLoadMoreBlockedUser = true;
  }

  getBlockedUsers() {
    if (canLoadMoreBlockedUser) {
      isLoading = true;
      EasyLoading.show(status: LocalizationString.loading);
      ApiController()
          .getBlockedUsersList(page: blockedUserPage)
          .then((response) {
        isLoading = false;
        EasyLoading.dismiss();
        usersList.value = response.blockedUsers;

        blockedUserPage += 1;
        if (response.blockedUsers.length == response.metaData?.perPage) {
          canLoadMoreBlockedUser = true;
        } else {
          canLoadMoreBlockedUser = false;
        }

        update();
      });
    }
  }

  unBlockUser(int userId) {
    isLoading = true;
    EasyLoading.show(status: LocalizationString.loading);
    ApiController().unBlockUser(userId).then((value) {
      isLoading = false;
      EasyLoading.dismiss();
      usersList.removeWhere((element) => element.id == userId);
      update();
    });
  }
}
