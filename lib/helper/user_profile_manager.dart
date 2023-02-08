import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class UserProfileManager {
  final DashboardController _dashboardController = Get.find();

  UserModel? user;

  bool get isLogin {
    return user != null;
  }

  logout() {
    user = null;
    SharedPrefs().clearPreferences();
    Get.offAll(() => const LoginScreen());
    getIt<SocketManager>().disconnect();
    getIt<DBManager>().clearAllUnreadCount();
    _dashboardController.indexChanged(0);
  }

  Future refreshProfile() async {
    String? authKey = await SharedPrefs().getAuthorizationKey();

    if (authKey != null) {
      await ApiController().getMyProfile().then((value) {
        user = value.user;

        if (user != null) {
          setupSocketServiceLocator1();
        }
        return;
      });
    } else {
      return;
      // print('no auth token found');
    }
  }
}
