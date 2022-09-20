import 'package:connectivity/connectivity.dart';
import 'package:foap/helper/common_import.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';

class AppUtil {
  static showToast(
      {required BuildContext context,
      required String message,
      required bool isSuccess}) {
    Get.snackbar(
        isSuccess == true
            ? LocalizationString.success
            : LocalizationString.error,
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: isSuccess == true
            ? Theme.of(context).primaryColor
            : Theme.of(context).errorColor.withOpacity(0.2),
        icon: Icon(Icons.error, color: Theme.of(context).iconTheme.color));
  }

  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static Widget addProgressIndicator(BuildContext context) {
    return Center(
        child: SizedBox(
      width: 50,
      height: 50,
      child: CircularProgressIndicator(
          strokeWidth: 2.0,
          backgroundColor: Colors.black12,
          valueColor:
              AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
    ));
  }

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  static Future<bool> checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  static Future<File> findPath(String imageUrl) async {
    final cache = DefaultCacheManager();
    final file = await cache.getSingleFile(imageUrl);
    return file;
  }

  static void logoutAction(BuildContext cxt, VoidCallback handler) {
    showDialog(
      barrierDismissible: false,
      barrierColor: null,
      context: cxt,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          title: Text(AppConfigConstants.appName,
              style: TextStyle(color: Theme.of(context).primaryColor)),
          content: Text(LocalizationString.logoutConfirmation),
          actions: [
            SizedBox(
              width: 100,
              height: 30,
              child: BorderButtonType1(
                  text: LocalizationString.yes,
                  onPress: () {
                    Get.back(closeOverlays: true);
                    handler();
                  }),
            ),
            SizedBox(
              width: 100,
              height: 30,
              child: FilledButtonType1(
                  isEnabled: true,
                  text: LocalizationString.no,
                  onPress: () {
                    Get.back(closeOverlays: true);
                  }),
            )
          ],
        );
      },
    );
  }
}
