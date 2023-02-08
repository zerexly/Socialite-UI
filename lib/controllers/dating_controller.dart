import 'package:foap/helper/common_import.dart';
import 'package:foap/model/preference_model.dart';
import 'package:get/get.dart';

class DatingController extends GetxController {
  RxList<InterestModel> interests = <InterestModel>[].obs;
  RxList<UserModel> datingUsers = <UserModel>[].obs;
  RxList<UserModel> matchedUsers = <UserModel>[].obs;
  RxList<LanguageModel> languages = <LanguageModel>[].obs;
  RxBool isLoading = false.obs;

  clearInterests() {
    interests.clear();
    datingUsers.clear();
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

  getUserPreference() {
    EasyLoading.show(status: LocalizationString.loading);
    ApiController().getUserPreferenceApi().then((response) {
      EasyLoading.dismiss();
      update();
    });
  }

  getDatingProfiles() {
    isLoading.value = true;
    ApiController().getPopularUsers().then((response) {
      isLoading.value = false;
      datingUsers.value = response.users;
      update();
    });
  }

  getLanguages() {
    ApiController().getLanguages().then((response) {
      languages.value = response.languages;
      update();
    });
  }

  likeUnlikeProfile(bool like, String profileId) {
    ApiController().likeUnlikeDatingProfile(like, profileId).then((response) {
      update();
    });
  }

  getMatchedProfilesApi() {
    isLoading.value = true;
    ApiController().getMatchedProfilesApi().then((response) {
      isLoading.value = false;
      matchedUsers.value = response.matchedUsers;
      update();
    });
  }
}
