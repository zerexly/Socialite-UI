import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class PackagesScreen extends StatefulWidget {
  final Function(int) handler;

  const PackagesScreen({Key? key, required this.handler}) : super(key: key);

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
        backNavigationBar(context, LocalizationString.packages),
        divider(context: context).vP8,
        Text(
          '${LocalizationString.availableCoins} : ${getIt<UserProfileManager>().user!.coins ?? 0}',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w900),
        ).p16,
        Expanded(
            child: GetBuilder<SubscriptionPackageController>(
                init: packageController,
                builder: (ctx) {
                  return ListView.separated(
                      padding: const EdgeInsets.only(top: 20),
                      itemBuilder: (ctx, index) {
                        return PackageTile(
                          package: packageController.packages[index],
                          index: index,
                        );
                      },
                      separatorBuilder: (ctx, index) {
                        return divider(context: context).vP16;
                      },
                      itemCount: packageController.packages.length);
                }).hP16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Theme.of(context).primaryColor))),
            const SizedBox(height: 40),
            Center(
              child: SizedBox(
                height: 45,
                child: FilledButtonType1(
                    isEnabled: true,
                    enabledTextStyle: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(
                            fontWeight: FontWeight.w600, color: Colors.white),
                    text: LocalizationString.watchAds,
                    onPress: () {
                      packageController.showRewardedAds();
                    }),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ).hP16
      ]),
    );
  }
}
