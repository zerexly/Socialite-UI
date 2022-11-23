import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  late bool haveBiometricLogin = false;
  var localAuth = LocalAuthentication();
  RxInt bioMetricType = 0.obs;

  @override
  void initState() {
    super.initState();
  }

  openNextScreen() {
    if (getIt<UserProfileManager>().isLogin == true) {
      Get.offAll(() => const DashboardScreen());
      getIt<SocketManager>().connect();
    } else {
      Get.offAll(() => const TutorialScreen());
    }
  }

  Future checkBiometric() async {
    bool bioMetricAuthStatus = await SharedPrefs().getBioMetricAuthStatus();
    if (bioMetricAuthStatus == true) {
      // haveBiometricLogin = await localAuth.canCheckBiometrics;

      List<BiometricType> availableBiometrics =
          await localAuth.getAvailableBiometrics();

      if (availableBiometrics.contains(BiometricType.face)) {
        // Face ID.
        bioMetricType.value = 1;
      } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
        // Touch ID.
        bioMetricType.value = 2;
      }
    } else {
      openNextScreen();
    }
    return;
  }

  void biometricLogin() async {
    try {
      bool didAuthenticate = await localAuth.authenticate(
          localizedReason: 'Please authenticate to login into app');

      if (didAuthenticate == true) {
        openNextScreen();
      }
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {
        // Handle this exception here.
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: FutureBuilder<void>(
            future: checkBiometric(),
            // a previously-obtained Future<String> or null
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              return bioMetricType.value == 0
                  ? Container()
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            bioMetricType.value == 1
                                ? 'assets/face-id.png'
                                : 'assets/fingerprint.png',
                            height: 80,
                            width: 80,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Text(
                            LocalizationString.appLocked,
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            bioMetricType.value == 1
                                ? LocalizationString.unlockAppWithFaceId
                                : LocalizationString.unlockAppWithTouchId,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Text(
                            bioMetricType.value == 1
                                ? LocalizationString.useFaceId
                                : LocalizationString.useTouchId,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    color: Theme.of(context).primaryColor),
                          ).ripple(() {
                            biometricLogin();
                          }),
                        ],
                      ),
                    );
            }));
  }
}
