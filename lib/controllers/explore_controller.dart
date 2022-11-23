import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class ExploreController extends GetxController {
  final PostController postController = Get.find<PostController>();

  RxList<LocationModel> locations = <LocationModel>[].obs;
  RxList<Hashtag> hashTags = <Hashtag>[].obs;
  RxList<UserModel> suggestedUsers = <UserModel>[].obs;
  RxList<UserModel> searchedUsers = <UserModel>[].obs;

  bool isSearching = false;
  RxString searchText = ''.obs;
  int selectedSegment = 0;

  int suggestUserPage = 1;
  bool canLoadMoreSuggestUser = true;
  bool suggestUserIsLoading = false;

  int accountsPage = 1;
  bool canLoadMoreAccounts = true;
  bool accountsIsLoading = false;

  int hashtagsPage = 1;
  bool canLoadMoreHashtags = true;
  bool hashtagsIsLoading = false;

  clear() {
    suggestUserPage = 1;
    canLoadMoreSuggestUser = true;
    suggestUserIsLoading = false;

    accountsPage = 1;
    canLoadMoreAccounts = true;
    accountsIsLoading = false;

    hashtagsPage = 1;
    canLoadMoreHashtags = true;
    hashtagsIsLoading = false;
  }

  startSearch() {
    // isSearching = true;
    update();
  }

  closeSearch() {
    clear();
    postController.clearPosts();
    searchText.value = '';
    selectedSegment = 0;
    update();
  }

  searchTextChanged(String text) {
    clear();
    searchText.value = text;
    postController.clearPosts();
    searchData();
  }

  searchData() {
    if (searchText.isNotEmpty) {
      if (selectedSegment == 0) {
        PostSearchQuery query = PostSearchQuery();
        // query.isPopular = 1;
        query.title = searchText.value;
        postController.setPostSearchQuery(query);

        // postController.getPosts();
        // getPosts(isPopular: 1, title: searchText);
      } else if (selectedSegment == 1) {
        searchUser(searchText.value);
      } else if (selectedSegment == 2) {
        searchHashTags(searchText.value);
      } else if (selectedSegment == 3) {
        // searchLocations(searchText);
      }
      update();
    } else {
      closeSearch();
    }
  }

  segmentChanged(int index) {
    selectedSegment = index;
    searchData();
    update();
  }

  searchHashTags(String text) {
    if (canLoadMoreHashtags) {
      hashtagsIsLoading = true;
      ApiController()
          .searchHashtag(hashtag: text, page: hashtagsPage)
          .then((response) {
        hashTags.value = response.hashtags;
        hashtagsIsLoading = false;
        hashtagsPage += 1;
        if (response.hashtags.length == response.metaData?.perPage) {
          canLoadMoreHashtags = true;
        } else {
          canLoadMoreHashtags = false;
        }

        update();
      });
    }
  }

  getSuggestedUsers() {
    if (canLoadMoreSuggestUser) {
      suggestUserIsLoading = true;

      ApiController().getSuggestedUsers(page: suggestUserPage).then((response) {
        suggestUserIsLoading = false;
        suggestedUsers.value = response.topUsers;
        suggestUserPage += 1;
        if (response.topUsers.length == response.metaData?.perPage) {
          canLoadMoreSuggestUser = true;
        } else {
          canLoadMoreSuggestUser = false;
        }

        update();
      });
    }
  }

  searchUser(String text) {
    if (canLoadMoreAccounts) {
      accountsIsLoading = true;

      ApiController()
          .findFriends(isExactMatch: 0, searchText: text)
          .then((response) {
        accountsIsLoading = false;
        searchedUsers.value = response.users;

        accountsPage += 1;
        if (response.topUsers.length == response.metaData?.perPage) {
          canLoadMoreAccounts = true;
        } else {
          canLoadMoreAccounts = false;
        }

        update();
      });
    }
  }

  followUser(UserModel user) {
    user.isFollowing = true;
    if (searchedUsers.where((e) => e.id == user.id).isNotEmpty) {
      searchedUsers[
          searchedUsers.indexWhere((element) => element.id == user.id)] = user;
    }
    if (suggestedUsers.where((e) => e.id == user.id).isNotEmpty) {
      suggestedUsers[
          suggestedUsers.indexWhere((element) => element.id == user.id)] = user;
    }
    update();
    ApiController().followUnFollowUser(true, user.id).then((value) {});
  }

  unFollowUser(UserModel user) {
    user.isFollowing = false;
    if (searchedUsers.where((e) => e.id == user.id).isNotEmpty) {
      searchedUsers[
          searchedUsers.indexWhere((element) => element.id == user.id)] = user;
    }
    if (suggestedUsers.where((e) => e.id == user.id).isNotEmpty) {
      suggestedUsers[
          suggestedUsers.indexWhere((element) => element.id == user.id)] = user;
    }
    update();
    ApiController().followUnFollowUser(false, user.id).then((value) {});
  }
}
