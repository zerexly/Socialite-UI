import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class AppNotificationSettings extends StatefulWidget {
  const AppNotificationSettings({Key? key}) : super(key: key);

  @override
  State<AppNotificationSettings> createState() =>
      _AppNotificationSettingsState();
}

class _AppNotificationSettingsState extends State<AppNotificationSettings> {
  final NotificationSettingController settingController = Get.find();

  @override
  void initState() {
    super.initState();
    settingController.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            backNavigationBar(context:context, title:LocalizationString.notificationSettings),
            divider(context: context).vP8,
            const SizedBox(
              height: 20,
            ),
            GetBuilder<NotificationSettingController>(
                init: settingController,
                builder: (ctx) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            LocalizationString.turnOffAll,
                            style: Theme.of(context).textTheme.bodyLarge!
                                .copyWith(fontWeight: FontWeight.w900),
                          ),
                          settingController.turnOfAll.value == 1
                              ? ThemeIconWidget(
                                  ThemeIcon.selectedRadio,
                                  color: Theme.of(context).primaryColor,
                                ).ripple(() {
                                  settingController.turnOfAll.value = 0;
                                })
                              : ThemeIconWidget(ThemeIcon.circleOutline,
                                      color: Theme.of(context).iconTheme.color)
                                  .ripple(() {
                                  settingController.turnOfAll.value = 1;
                                  settingController
                                      .likesNotificationStatus.value = 0;
                                  settingController
                                      .commentNotificationStatus.value = 0;
                                })
                        ],
                      ).setPadding(left: 16, right: 16, bottom: 16),
                      settingSegment(LocalizationString.likes).vP8,
                      settingSegment(LocalizationString.comments).vP8,
                    ],
                  );
                })
          ],
        ),
      ),
    );
  }

  Widget settingSegment(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge!
              .copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(
          height: 10,
        ),
        settingOption(
            title,
            LocalizationString.off,
            title == LocalizationString.likes
                ? settingController.likesNotificationStatus.value == 0
                : settingController.commentNotificationStatus.value == 0),
        settingOption(
            title,
            LocalizationString.fromPeopleOrFollow,
            title == LocalizationString.likes
                ? settingController.likesNotificationStatus.value == 2
                : settingController.commentNotificationStatus.value == 2),
        settingOption(
            title,
            LocalizationString.fromEveryone,
            title == LocalizationString.likes
                ? settingController.likesNotificationStatus.value == 1
                : settingController.commentNotificationStatus.value == 1),
      ],
    ).hP16;
  }

  Widget settingOption(String sectionName, String title, bool isSelected) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        isSelected == true
            ? ThemeIconWidget(
                ThemeIcon.selectedRadio,
                color: Theme.of(context).primaryColor,
              )
            : ThemeIconWidget(ThemeIcon.circleOutline,
                color: Theme.of(context).iconTheme.color)
      ],
    ).vP8.ripple(() {
      settingController.updateNotificationSetting(context: context,
          section: sectionName, title: title);
    });
  }
}
