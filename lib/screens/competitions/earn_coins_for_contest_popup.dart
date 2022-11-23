import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class EarnCoinForContestPopup extends StatefulWidget {
  final int needCoins;

  const EarnCoinForContestPopup({Key? key, required this.needCoins})
      : super(key: key);

  @override
  State<EarnCoinForContestPopup> createState() =>
      _EarnCoinForContestPopupState();
}

class _EarnCoinForContestPopupState extends State<EarnCoinForContestPopup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          backNavigationBar(context: context, title: LocalizationString.coins),
          divider(context: context).tP8,
          const Spacer(),
          Container(
                  height: 450,
                  color: Theme.of(context).backgroundColor,
                  child: Column(
                    children: [
                      Text(
                        LocalizationString.youNeed,
                        style: Theme.of(context).textTheme.titleSmall,
                      ).bp(20),
                      Text(
                        '${widget.needCoins} ${LocalizationString.coins}',
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).primaryColor),
                      ).bp(15),
                      Text(
                        LocalizationString.toJoinThisCompetition,
                        style: Theme.of(context).textTheme.titleSmall,
                      ).bp(120),
                      Text(
                        LocalizationString.watchAdsToEarnCoins,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Theme.of(context).primaryColor),
                      ).ripple(() {}).bp(20),
                      FilledButtonType1(
                        isEnabled: true,
                        enabledTextStyle: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(fontWeight: FontWeight.w900)
                            .copyWith(color: Colors.white),
                        text: LocalizationString.buyCoins,
                        onPress: () {
                          Get.back();
                          Get.to(() => const PackagesScreen());
                        },
                      ).hP16
                    ],
                  ).setPadding(top: 70, bottom: 45))
              .round(20)
              .hP25,
          const Spacer(),
        ],
      ),
    );
  }
}
