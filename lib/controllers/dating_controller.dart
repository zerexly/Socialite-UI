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

  setPreferencesApi() {
    EasyLoading.show(status: LocalizationString.loading);
    ApiController().addUserPreference().then((response) {
      EasyLoading.dismiss();
      update();
    });
  }

  updateDatingProfile() {
    EasyLoading.show(status: LocalizationString.loading);
    ApiController().updateDatingProfile().then((response) {
      EasyLoading.dismiss();
      update();
    });
  }
}
