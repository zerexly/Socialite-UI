import 'package:connectivity/connectivity.dart';
import 'package:foap/helper/common_import.dart';
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
            ? Theme.of(context).primaryColor.darken()
            : Theme.of(context).errorColor.lighten(),
        icon: Icon(Icons.error, color: Theme.of(context).iconTheme.color));
  }

  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static Widget addProgressIndicator(BuildContext context, double? size) {
    return Center(
        child: SizedBox(
      width: size ?? 50,
      height: size ?? 50,
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

  static void showConfirmationAlert(
      {required String title,
      required String subTitle,
      required BuildContext cxt,
      required VoidCallback okHandler}) {
    showDialog(
      context: cxt,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            height: 220,
            width: Get.width,
            color: Theme.of(context).backgroundColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w900)),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  subTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 40,
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        const Spacer(),
                        SizedBox(
                          width: 100,
                          height: 40,
                          child: BorderButtonType1(
                              text: LocalizationString.yes,
                              onPress: () {
                                Get.back(closeOverlays: true);
                                okHandler();
                              }),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 100,
                          height: 40,
                          child: FilledButtonType1(
                              isEnabled: true,
                              text: LocalizationString.no,
                              onPress: () {
                                Get.back(closeOverlays: true);
                              }),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ).hP16,
          ).round(20),
        );
      },
    );
  }

  static void showDemoAppConfirmationAlert(
      {required String title,
      required String subTitle,
      required BuildContext cxt,
      required VoidCallback okHandler}) {
    showDialog(
      context: cxt,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            height: 200,
            width: Get.width,
            color: Theme.of(context).backgroundColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w900)),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  subTitle,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(
                  height: 25,
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        const Spacer(),
                        SizedBox(
                          width: 100,
                          height: 30,
                          child: BorderButtonType1(
                              text: LocalizationString.ok,
                              onPress: () {
                                Get.back(closeOverlays: true);
                                okHandler();
                              }),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ).p16,
          ).round(20),
        );
      },
    );
  }
}
