import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class RelationshipSearchController extends GetxController {
  RxList<UserModel> searchedUsers = <UserModel>[].obs;
  RxString searchText = ''.obs;

  int accountsPage = 1;
  bool canLoadMoreAccounts = true;
  bool accountsIsLoading = false;

  clear() {
    accountsPage = 1;
    canLoadMoreAccounts = true;
    accountsIsLoading = false;
  }

  closeSearch() {
    clear();
    searchText.value = '';
    update();
  }

  searchTextChanged(String text) {
    clear();
    searchText.value = text;
    searchData();
  }

  searchData() {
    if (searchText.isNotEmpty) {
      searchUser(searchText.value);
      update();
    } else {
      closeSearch();
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

  inviteUser(int relationShipId, int userId, VoidCallback handler) {
    update();
    ApiController().postRelationInviteUnInvite(relationShipId, userId).then((value) {
      if(value.success) {
        handler();
      }
    });
  }

  unInviteUser(int userId) {
    update();
    // ApiController().followUnFollowUser(false, userId).then((value) {});
  }
}
