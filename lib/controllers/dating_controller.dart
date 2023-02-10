import 'package:foap/helper/common_import.dart';
import 'package:foap/model/preference_model.dart';
import 'package:get/get.dart';

class DatingController extends GetxController {
  RxList<InterestModel> interests = <InterestModel>[].obs;
  RxList<UserModel> datingUsers = <UserModel>[].obs;
  RxList<UserModel> matchedUsers = <UserModel>[].obs;
  RxList<UserModel> likeUsers = <UserModel>[].obs;
  RxList<LanguageModel> languages = <LanguageModel>[].obs;
  Rx isLoading = false.obs;
  AddPreferenceModel? preferenceModel;

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

  setPreferencesApi(AddPreferenceModel selectedPreferences) {
    EasyLoading.show(status: LocalizationString.loading);
    ApiController().addUserPreference(selectedPreferences).then((response) {
      EasyLoading.dismiss();
      update();
    });
  }

  updateDatingProfile(AddDatingDataModel dataModel, Function(String) handler) {
    EasyLoading.show(status: LocalizationString.loading);
    ApiController().updateDatingProfile(dataModel).then((response) {
      EasyLoading.dismiss();
      update();
      handler(response.message);
    });
  }

  getUserPreference(VoidCallback handler) {
    ApiController().getUserPreferenceApi().then((response) {
      preferenceModel = response.preference;
      update();
      handler();
    });
  }

  getDatingProfiles() {
    isLoading.value = true;
    ApiController().getDatingProfilesApi().then((response) {
      isLoading.value = false;
      datingUsers.value = response.datingUsers;
      update();
    });
  }

  getLanguages() {
    ApiController().getLanguages().then((response) {
      languages.value = response.languages;
      update();
    });
  }

  likeUnlikeProfile(DatingActions like, String profileId) {
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

  getLikeProfilesApi() {
    isLoading.value = true;
    ApiController().getLikeProfilesApi().then((response) {
      isLoading.value = false;
      likeUsers.value = response.likeUsers;
      update();
    });
  }
}

enum DatingActions {
  liked,
  rejected,
  undoLiked,
}
