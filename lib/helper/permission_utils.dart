import 'package:foap/helper/common_import.dart';
import 'dialog_utils.dart';

class PermissionUtils {
  static void requestPermission(
    List<Permission> permission,
    BuildContext context, {
    required Function permissionGrant,
    required Function permissionDenied,
    required Function permissionNotAskAgain,
    bool isOpenSettings = false,
    bool isShowMessage = false,
  }) async {
    Map<Permission, PermissionStatus> statuses = await permission.request();

    var allPermissionGranted = true;

    statuses.forEach((key, value) {
      allPermissionGranted =
          allPermissionGranted && (value == PermissionStatus.granted);
    });

    if (allPermissionGranted) {
      permissionGrant();
    } else {
      permissionDenied();
      if (isOpenSettings) {
        DialogUtils.showOkCancelAlertDialog(
          context: context,
          message: LocalizationString.pleaseGrantRequiredPermission,
          cancelButtonTitle: Platform.isAndroid
              ? LocalizationString.no
              : LocalizationString.cancel,
          okButtonTitle: Platform.isAndroid
              ? LocalizationString.yes
              : LocalizationString.ok,
          cancelButtonAction: () {},
          okButtonAction: () {
            openAppSettings();
          },
        );
      } else if (isShowMessage) {
        DialogUtils.showAlertDialog(
            context, LocalizationString.pleaseGrantRequiredPermission);
      }
    }
  }
}
