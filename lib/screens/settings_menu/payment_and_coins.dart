import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class PaymentAndCoins extends StatefulWidget {
  const PaymentAndCoins({Key? key}) : super(key: key);

  @override
  State<PaymentAndCoins> createState() => _PaymentAndCoinsState();
}

class _PaymentAndCoinsState extends State<PaymentAndCoins> {
  final SettingsController settingsController = Get.find();

  int coin = 0;

  @override
  void initState() {
    super.initState();
    coin = getIt<UserProfileManager>().user!.coins ;
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
              padding:  EdgeInsets.zero,
              children: [
                Column(
                  children: [
                    addTileEvent(
                        'assets/coins.png',
                        '${LocalizationString.coins} ($coin)',
                        LocalizationString.checkYourCoinsAndEarnMoreCoins, () {
                      Get.to(() => const PackagesScreen());
                    }),
                    addTileEvent(
                        'assets/earning.png',
                        LocalizationString.earnings,
                        LocalizationString.trackEarning, () {
                      Get.to(() => const PaymentWithdrawalScreen());
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
                      Text(title,
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
