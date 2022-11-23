import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class ChangeLanguage extends StatefulWidget {
  const ChangeLanguage({Key? key}) : super(key: key);

  @override
  State<ChangeLanguage> createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  final SettingsController _settingsController = Get.find();

  @override
  void initState() {
    _settingsController.setCurrentSelectedLanguage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          backNavigationBar(
              context: context, title: LocalizationString.changeLanguage),
          divider(context: context).tP8,
          Expanded(
              child: GetBuilder<SettingsController>(
                  init: _settingsController,
                  builder: (ctx) {
                    return ListView.separated(
                        padding: const EdgeInsets.only(top: 20),
                        itemBuilder: (ctx, index) {
                          Map<String, String> language =
                              _settingsController.languagesList[index];
                          return Row(
                            children: [
                              Text(
                                language['language_name']!,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const Spacer(),
                              _settingsController.currentLanguage.value ==
                                      language['language_code']!
                                  ? ThemeIconWidget(
                                      ThemeIcon.checkMarkWithCircle,
                                      size: 20,
                                      color: Theme.of(context).primaryColor,
                                    )
                                  : Container()
                            ],
                          ).hP16.ripple(() {
                            // var locale = Locale(language['language_code']!,
                            //     language['country_code']!);
                            // context.setLocale(locale);
                            _settingsController.changeLanguage(language);
                          });
                        },
                        separatorBuilder: (ctx, index) {
                          return divider(context: context).vP16;
                        },
                        itemCount: _settingsController.languagesList.length);
                  }))
        ],
      ),
    );
  }
}
