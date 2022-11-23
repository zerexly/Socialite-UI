import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class UserNetworkController extends GetxController {
  RxList<UserModel> followers = <UserModel>[].obs;
  RxList<UserModel> following = <UserModel>[].obs;

  RxBool isLoading = true.obs;

  int page = 1;
  bool canLoadMore = true;

  clear() {
    page = 1;
    canLoadMore = true;
    isLoading.value = false;

    following.value = [];
    followers.value = [];
  }

  getFollowers(int userId) {
    if (canLoadMore) {
      isLoading.value = true;
      ApiController()
          .getFollowerUsers(page: page, userId: userId)
          .then((response) {
        isLoading.value = false;
        followers.addAll(response.users);

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

  getFollowingUsers(int userId) {
    if (canLoadMore) {
      isLoading.value = true;
      ApiController()
          .getFollowingUsers(page: page, userId: userId)
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

  followUser(UserModel user) {
    user.isFollowing = true;
    if (following.where((e) => e.id == user.id).isNotEmpty) {
      following[following.indexWhere((element) => element.id == user.id)] =
          user;
    }
    if (followers.where((e) => e.id == user.id).isNotEmpty) {
      followers[followers.indexWhere((element) => element.id == user.id)] =
          user;
    }
    update();
    ApiController().followUnFollowUser(true, user.id).then((value) {});
  }

  unFollowUser(UserModel user) {
    user.isFollowing = false;
    if (following.where((e) => e.id == user.id).isNotEmpty) {
      following[following.indexWhere((element) => element.id == user.id)] =
          user;
    }
    if (followers.where((e) => e.id == user.id).isNotEmpty) {
      followers[followers.indexWhere((element) => element.id == user.id)] =
          user;
    }
    update();
    ApiController().followUnFollowUser(false, user.id).then((value) {});
  }
}
