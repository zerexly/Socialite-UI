import 'package:get/get.dart';
import 'package:foap/helper/common_import.dart';

class SearchClubsController extends GetxController {
  RxList<ClubModel> clubs = <ClubModel>[].obs;

  int clubsPage = 1;
  bool canLoadMoreClubs = true;
  RxBool isLoadingClubs = false.obs;

  RxString searchText = ''.obs;

  clear() {
    isLoadingClubs.value = false;
    clubs.value = [];
    clubsPage = 1;
    canLoadMoreClubs = true;
    searchText = ''.obs;
  }

  searchTextChanged(String text) {
    canLoadMoreClubs = true;
    searchText.value = text;
    searchClubs(name: text, refresh: true);
  }

  searchClubs(
      {String? name,
      int? categoryId,
      int? userId,
      int? isJoined,
      bool? refresh}) {
    if (canLoadMoreClubs) {
      isLoadingClubs.value = true;
      ApiController()
          .getClubs(
              name: name,
              categoryId: categoryId,
              userId: userId,
              isJoined: isJoined,
              page: clubsPage)
          .then((response) {
        if (refresh == true) {
          clubs.value = response.clubs;
        } else {
          clubs.addAll(response.clubs);
        }
        isLoadingClubs.value = false;

        clubsPage += 1;
        if (response.clubs.length == response.metaData?.perPage) {
          canLoadMoreClubs = true;
        } else {
          canLoadMoreClubs = false;
        }
        update();
      });
    }
  }

  clubDeleted(ClubModel club) {
    clubs.removeWhere((element) => element.id == club.id);
    clubs.refresh();
  }

  joinClub(ClubModel club) {
    clubs.value = clubs.map((element) {
      if (element.id == club.id) {
        element.isJoined = true;
      }
      return element;
    }).toList();

    clubs.refresh();
    ApiController().joinClub(clubId: club.id!).then((response) {});
  }

  leaveClub(ClubModel club) {
    clubs.value = clubs.map((element) {
      if (element.id == club.id) {
        element.isJoined = false;
      }
      return element;
    }).toList();

    clubs.refresh();
    ApiController().leaveClub(clubId: club.id!).then((response) {});
  }
}
