import 'package:foap/helper/common_import.dart';
import 'package:foap/screens/profile/blocked_users.dart';
import 'package:get/get.dart';

class AppAccount extends StatefulWidget {
  const AppAccount({Key? key}) : super(key: key);

  @override
  State<AppAccount> createState() => _AppAccountState();
}

class _AppAccountState extends State<AppAccount> {
  final RequestVerificationController _requestVerificationController =
      Get.find();
  final SettingsController _settingsController = Get.find();

  @override
  void initState() {
    _requestVerificationController.getVerificationRequests();
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
              context: context, title: LocalizationString.account),
          divider(context: context).tP8,
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Column(
                  children: [
                    addTileEvent(
                        'assets/live_bw.png',
                        LocalizationString.liveHistory,
                        LocalizationString.liveHistorySubHeadline, () {
                      Get.to(() => const LiveHistory());
                    }),
                    addTileEvent(
                        'assets/blocked_user.png',
                        LocalizationString.blockedUser,
                        LocalizationString.manageBlockedUser, () {
                      Get.to(() => const BlockedUsersList());
                    }),
                    if (_settingsController
                        .setting.value!.enableProfileVerification)
                      addTileEvent('assets/verification.png',
                          LocalizationString.requestVerification, '', () {
                        if (_requestVerificationController
                            .isVerificationInProcess) {
                          Get.to(() => RequestVerificationList(
                              requests: _requestVerificationController
                                  .verificationRequests));
                        } else {
                          Get.to(() => const RequestVerification());
                        }
                      }),
                  ],
                ),
                const SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
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
                      Text(title.tr,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.w600))
                      //     .bP4,
                      // Text(subTitle,
                      //     style: Theme.of(context).textTheme.bodySmall),
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
}
