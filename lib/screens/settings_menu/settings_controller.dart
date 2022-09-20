import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  Rx<SettingModel?> setting = Rx<SettingModel?>(null);
  RxBool isDarkMode = false.obs;

  loadSettings() async{
    bool isDarkTheme = await SharedPrefs().isDarkMode();
    setDarkMode(isDarkTheme);
  }

  setDarkMode(bool status){
    isDarkMode.value = status;
    isDarkMode.refresh();
    SharedPrefs().setDarkMode(status);
    Get.changeThemeMode(status ? ThemeMode.dark : ThemeMode.light);
  }

  getSettings() {
    ApiController().getSettings().then((response) {
      setting.value = response.settings;
      update();
    });
  }
}
