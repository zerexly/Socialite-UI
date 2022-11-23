import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

class SettingsController extends GetxController {
  Rx<SettingModel?> setting = Rx<SettingModel?>(null);
  RxString currentLanguage = 'en'.obs;

  RxBool bioMetricAuthStatus = false.obs;
  RxBool isDarkMode = false.obs;
  RxBool shareLocation = false.obs;

  RxInt redeemCoins = 0.obs;

  var localAuth = LocalAuthentication();
  RxInt bioMetricType = 0.obs;

  List<Map<String, String>> languagesList = [
    {'language_code': 'hi', 'language_name': 'Hindi'},
    {'language_code': 'en', 'language_name': 'English'},
    {'language_code': 'ar', 'language_name': 'Arabic'},
    {'language_code': 'tr', 'language_name': 'Turkish'},
    {'language_code': 'ru', 'language_name': 'Russian'},
    {'language_code': 'es', 'language_name': 'Spanish'},
    {'language_code': 'fr', 'language_name': 'French'},
  ];

  setCurrentSelectedLanguage() async {
    String currentLanguage = await SharedPrefs().getLanguage();
    changeLanguage({'language_code': currentLanguage});
  }

  changeLanguage(Map<String, String> language) async {
    var locale = Locale(language['language_code']!);
    Get.updateLocale(locale);
    currentLanguage.value = language['language_code']!;
    update();
    SharedPrefs().setLanguage(language['language_code']!);
  }

  redeemCoinValueChange(int coins) {
    redeemCoins.value = coins;
  }

  loadSettings() async {
    bool isDarkTheme = await SharedPrefs().isDarkMode();
    bioMetricAuthStatus.value = await SharedPrefs().getBioMetricAuthStatus();
    shareLocation.value = getIt<UserProfileManager>().user!.latitude != null;

    setDarkMode(isDarkTheme);
    checkBiometric();
  }

  setDarkMode(bool status) {
    isDarkMode.value = status;
    isDarkMode.refresh();
    SharedPrefs().setDarkMode(status);
    Get.changeThemeMode(status ? ThemeMode.dark : ThemeMode.light);
  }

  shareLocationToggle(bool status) {
    shareLocation.value = status;
    if (status == true) {
      getIt<LocationManager>().postLocation();
    } else {
      getIt<LocationManager>().stopPostingLocation();
    }
  }

  getSettings() {
    ApiController().getSettings().then((response) {
      setting.value = response.settings;
      update();
    });
  }

  Future checkBiometric() async {
    bool bioMetricAuthStatus =
        true; //await SharedPrefs().getBioMetricAuthStatus();
    if (bioMetricAuthStatus == true) {
      List<BiometricType> availableBiometrics =
          await localAuth.getAvailableBiometrics();

      if (availableBiometrics.contains(BiometricType.face)) {
        // Face ID.
        bioMetricType.value = 1;
      } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
        // Touch ID.
        bioMetricType.value = 2;
      }
    }
    return;
  }

  void biometricLogin(bool status) async {
    try {
      bool didAuthenticate = await localAuth.authenticate(
          localizedReason: status == true
              ? LocalizationString.pleaseAuthenticateToUseBiometric
              : LocalizationString.pleaseAuthenticateToRemoveBiometric);

      if (didAuthenticate == true) {
        SharedPrefs().setBioMetricAuthStatus(status);
        bioMetricAuthStatus.value = status;
      }
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {
        // Handle this exception here.
      }
    }
  }
}
