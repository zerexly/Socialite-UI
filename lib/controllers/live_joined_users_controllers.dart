import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class LiveJoinedUserController extends GetxController {
  RxList<UserModel> users = <UserModel>[].obs;

  loadUsers(int liveId) {
    ApiController().getFollowerUsers().then((value) {
      users.value = value.users;
      update();
    });
  }
}
