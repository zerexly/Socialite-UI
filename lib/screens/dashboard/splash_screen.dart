import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class PushNotification {
  PushNotification({
    this.title,
    this.body,
  });

  String? title;
  String? body;
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      openNextScreen();
    });
  }

  openNextScreen() {
    if (getIt<UserProfileManager>().isLogin == true) {
      Get.offAll(() => const DashboardScreen());
      getIt<SocketManager>().connect();
    } else {
      Get.offAll(() => const TutorialScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(),
    );
  }
}
