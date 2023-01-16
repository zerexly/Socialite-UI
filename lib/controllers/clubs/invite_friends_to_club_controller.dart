import 'package:foap/manager/service_locator.dart';
import 'package:get/get.dart';
import '../../apiHandler/api_controller.dart';
import '../../helper/user_profile_manager.dart';
import '../../model/user_model.dart';

class InviteFriendsToClubController extends GetxController {
  RxList<UserModel> following = <UserModel>[].obs;
  RxList<UserModel> selectedFriends = <UserModel>[].obs;
  String searchText = '';

  RxBool isLoading = true.obs;
  int page = 1;
  bool canLoadMore = true;

  clear() {
    page = 1;
    canLoadMore = true;
    isLoading.value = false;

    following.value = [];
  }

  getFollowingUsers() {
    if (canLoadMore) {
      isLoading.value = true;
      ApiController()
          .getFollowingUsers(
              page: page, userId: getIt<UserProfileManager>().user!.id)
          .then((response) {
        isLoading.value = false;
        following.addAll(response.users);

        page += 1;
        if (response.users.length == response.metaData?.perPage) {
          canLoadMore = true;
        } else {
          canLoadMore = false;
        }
        update();
      });
    }
  }

  sendClubJoinInvite(int clubId) {
    if (selectedFriends.isNotEmpty) {
      ApiController()
          .sendClubInvite(
              clubId: clubId,
              userIds: selectedFriends
                  .map((element) => element.id)
                  .toList()
                  .join(','),
              message: '')
          .then((value) {
        Get.back();
      });
    }
  }

  searchTextChanged(String text) {
    searchText = text;
  }

  selectFriend(UserModel user) {
    if (selectedFriends.contains(user)) {
      selectedFriends.remove(user);
    } else {
      selectedFriends.add(user);
    }
    update();
  }
}
