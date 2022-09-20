import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class NotificationSettingController extends GetxController {
  RxInt likesNotificationStatus = 0.obs;
  RxInt commentNotificationStatus = 0.obs;
  RxInt turnOfAll = 0.obs;

  RxBool isLoading = true.obs;

  initialize() {
    likesNotificationStatus.value =
        getIt<UserProfileManager>().user!.likePushNotificationStatus;
    commentNotificationStatus.value =
        getIt<UserProfileManager>().user!.commentPushNotificationStatus;
    update();
  }

  updateNotificationSetting({required String section, required String title, required BuildContext context}) {
    if (section == LocalizationString.likes) {
      if (title == LocalizationString.off) {
        likesNotificationStatus.value = 0;
      } else if (title == LocalizationString.fromPeopleOrFollow) {
        likesNotificationStatus.value = 2;
        turnOfAll.value = 0;
      } else {
        likesNotificationStatus.value = 1;
        turnOfAll.value = 0;
      }
    } else {
      if (title == LocalizationString.off) {
        commentNotificationStatus.value = 0;
      } else if (title == LocalizationString.fromPeopleOrFollow) {
        commentNotificationStatus.value = 2;
        turnOfAll.value = 0;
      } else {
        commentNotificationStatus.value = 1;
        turnOfAll.value = 0;
      }
    }

    update();

    AppUtil.checkInternet().then((value) {
      if (value) {
        EasyLoading.show(status: LocalizationString.loading);
        ApiController()
            .updateNotificationSettings(
                likesNotificationStatus: likesNotificationStatus.toString(),
                commentNotificationStatus: commentNotificationStatus.toString())
            .then((response) {
          EasyLoading.dismiss();
          if (response.success == true) {
            getIt<UserProfileManager>().refreshProfile();
            AppUtil.showToast(context:context, message: response.message, isSuccess: true);
          } else {
            AppUtil.showToast(context:context,message: response.message, isSuccess: false);
          }
        });
      } else {
        AppUtil.showToast(context:context,
            message: LocalizationString.noInternet, isSuccess: false);
      }
    });
  }
}
