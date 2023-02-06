import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class DatingController extends GetxController {
  RxList<InterestModel> interests = <InterestModel>[].obs;

  clearInterests() {
    interests.clear();
    update();
  }

  getInterests() {
    ApiController().getInterests().then((response) {
      interests.value = response.interests;
      interests.refresh();
      update();
    });
  }
}
