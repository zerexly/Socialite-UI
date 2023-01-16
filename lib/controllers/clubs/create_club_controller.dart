import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class CreateClubController extends GetxController {
  RxInt privacyType = 1.obs;

  RxBool enableChat = false.obs;
  Rx<CategoryModel?> category = Rx<CategoryModel?>(null);
  Rx<File?> imageFile = Rx<File?>(null);

  privacyTypeChange(int type) {
    privacyType.value = type;
  }

  toggleChatGroup() {
    enableChat.value = !enableChat.value;
  }

  createClub(
      ClubModel club, BuildContext context, VoidCallback callback) async {
    EasyLoading.show(status: LocalizationString.loading);

    await ApiController()
        .uploadFile(file: imageFile.value!.path, type: UploadMediaType.club)
        .then((response) async {
      if (response.postedMediaFileName != null) {
        ApiController()
            .createClub(
                categoryId: club.categoryId!,
                isOnRequestType: privacyType.value == 3 ? 1 : 0,
                privacyMode: privacyType.value == 2 ? 2 : 1,
                enableChatRoom: club.enableChat!,
                name: club.name!,
                image: response.postedMediaFileName!,
                description: club.desc!)
            .then((response) {
          EasyLoading.dismiss();
          Get.close(2);
          // callback();

          // if(privacyType.value == 2){
          Get.to(() => InviteUsersToClub(clubId: response.clubId!));
          // }
        });
      } else {
        EasyLoading.dismiss();
        AppUtil.showToast(
            context: context,
            message: LocalizationString.errorMessage,
            isSuccess: false);
      }
    });
  }

  void editClubImageAction(XFile pickedFile, BuildContext context) async {
    imageFile.value = File(pickedFile.path);
    imageFile.refresh();
  }

  updateClubImage(ClubModel club, BuildContext context,
      Function(ClubModel) callback) async {
    EasyLoading.show(status: LocalizationString.loading);

    await ApiController()
        .uploadFile(file: imageFile.value!.path, type: UploadMediaType.club)
        .then((response) async {
      if (response.postedMediaFileName != null) {
        club.imageName = response.postedMediaFileName!;
        club.image = response.postedMediaCompletePath!;

        updateClubInfo(
            club: club,
            callback: () {
              callback(club);
            });
      } else {
        EasyLoading.dismiss();
        AppUtil.showToast(
            context: context,
            message: LocalizationString.errorMessage,
            isSuccess: false);
      }
    });
  }

  updateClubInfo({required ClubModel club, required VoidCallback callback}) {
    EasyLoading.show(status: LocalizationString.loading);

    ApiController()
        .updateClub(
            clubId: club.id!,
            categoryId: club.categoryId!,
            privacyMode: 1,
            name: club.name!,
            image: club.imageName!,
            description: club.desc!)
        .then((response) {
      EasyLoading.dismiss();
      Get.back();
      callback();
    });
  }
}
