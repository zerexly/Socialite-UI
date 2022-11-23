import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class PackagesScreen extends StatefulWidget {
  const PackagesScreen({Key? key}) : super(key: key);

  @override
  PackagesScreenState createState() => PackagesScreenState();
}

class PackagesScreenState extends State<PackagesScreen> {
  final SubscriptionPackageController packageController = Get.find();
  final SettingsController settingsController = Get.find();

  @override
  void initState() {
    super.initState();

    settingsController.getSettings();
    packageController.initiate(context);
  }

  @override
  void dispose() {
    packageController.subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(
          height: 50,
        ),
        backNavigationBar(context: context, title: LocalizationString.packages),
        divider(context: context).tP8,
        const Expanded(child: CoinPackagesWidget()),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Text(LocalizationString.watchAds,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w900)),
            const SizedBox(height: 10),
            Obx(() => Text(
                settingsController.setting.value == null
                    ? LocalizationString.watchAdsReward
                        .replaceAll('coins_value', LocalizationString.loading)
                    : LocalizationString.watchAdsReward.replaceAll(
                        'coins_value',
                        settingsController.setting.value!.watchVideoRewardCoins
                            .toString()),
                style: Theme.of(context).textTheme.bodyMedium)),
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                height: 45,
                child: FilledButtonType1(
                    isEnabled: true,
                    enabledTextStyle: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(
                            fontWeight: FontWeight.w600, color: Colors.white),
                    text: LocalizationString.watchAds,
                    onPress: () {
                      packageController.showRewardedAds();
                    }),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ).hP16
      ]),
    );
  }
}
