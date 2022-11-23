import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class RandomLivesController extends GetxController {
  RxList<UserModel> randomUsers = <UserModel>[].obs;

  int page = 1;
  bool canLoadMore = true;

  clear() {
    randomUsers.clear();
    canLoadMore = true;
    page = 1;
  }

  getAllRandomLives() {
    if (canLoadMore) {
      ApiController().getRandomLiveUsers().then((response) {
        randomUsers.addAll(response.randomLives);
        randomUsers.refresh();

        page += 1;
        if (response.randomLives.length == response.metaData?.perPage) {
          canLoadMore = true;
        } else {
          canLoadMore = false;
        }
      });
    }
  }
}
