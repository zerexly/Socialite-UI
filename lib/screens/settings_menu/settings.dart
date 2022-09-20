import 'package:foap/helper/common_import.dart';
import 'package:foap/screens/profile/blocked_users.dart';
import 'package:get/get.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final SettingsController settingsController = Get.find();

  int coin = 0;

  @override
  void initState() {
    super.initState();
    settingsController.loadSettings();
    coin = getIt<UserProfileManager>().user!.coins ?? 0;
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
          backNavigationBar(context, LocalizationString.settings),
          divider(context: context).vP8,
          addTileEvent(
              'assets/zioCoin.png',
              '${LocalizationString.coins} ($coin)',
              LocalizationString.checkYourCoinsAndEarnMoreCoins, () {
            Get.to(() => PackagesScreen(handler: (newCoins) {
                  setState(() {
                    coin += newCoins;
                  });
                }));
          }),
          addTileEvent(
              'assets/blocked_user.png',
              LocalizationString.blockedUser,
              LocalizationString.manageBlockedUser, () {
            Get.to(() => const BlockedUsersList());
          }),
          addTileEvent('assets/support.png', LocalizationString.faq,
              LocalizationString.faqMessage, () {
            Get.to(() => const FaqList());
          }),
          addTileEvent('assets/earning.png', LocalizationString.earnings,
              LocalizationString.trackEarning, () {
            Get.to(() => const PaymentWithdrawalScreen());
          }),
          addTileEvent(
              'assets/settings.png',
              LocalizationString.notificationSettings,
              LocalizationString.tuneSettings, () {
            Get.to(() => const AppNotificationSettings());
          }),
          darkModeTile(),
          addTileEvent('assets/logout.png', LocalizationString.logout,
              LocalizationString.exitApp, () {
            AppUtil.logoutAction(context, () {
              getIt<UserProfileManager>().logout();
            });
          })
        ],
      ),
    );
  }

  addTileEvent(
      String icon, String title, String subTitle, VoidCallback action) {
    return InkWell(
        onTap: action,
        child: Column(
          children: [
            SizedBox(
              height: 75,
              child: Row(children: [
                Container(
                        color: Theme.of(context).primaryColor.withOpacity(0.2),
                        child: Image.asset(
                          icon,
                          height: 20,
                          width: 20,
                          color: Theme.of(context).primaryColor,
                        ).p8)
                    .circular,
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontWeight: FontWeight.w600))
                          .bP8,
                      Text(subTitle,
                          style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  ),
                ),
                // const Spacer(),
                ThemeIconWidget(
                  ThemeIcon.nextArrow,
                  color: Theme.of(context).iconTheme.color,
                  size: 15,
                )
              ]).hP16,
            ),
            divider(context: context)
          ],
        ));
  }

  darkModeTile() {
    return Column(
      children: [
        SizedBox(
          height: 75,
          child: Row(children: [
            Container(
                    color: Theme.of(context).primaryColor.withOpacity(0.2),
                    child: Image.asset(
                      'assets/dark-mode.png',
                      height: 20,
                      width: 20,
                      color: Theme.of(context).primaryColor,
                    ).p8)
                .circular,
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(LocalizationString.darkMode,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.w600))
                      .bP8,
                  Text(LocalizationString.changeTheAppearanceSetting,
                      style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            ),
            // const Spacer(),
            Obx(() => FlutterSwitch(
                  inactiveColor: Theme.of(context).disabledColor,
                  activeColor: Theme.of(context).primaryColor,
                  width: 60.0,
                  height: 30.0,
                  valueFontSize: 15.0,
                  toggleSize: 20.0,
                  value: settingsController.isDarkMode.value,
                  borderRadius: 30.0,
                  padding: 8.0,
                  showOnOff: true,
                  onToggle: (val) {
                    settingsController.setDarkMode(val);
                  },
                )),
          ]).hP16,
        ),
        divider(context: context)
      ],
    );
  }
}
