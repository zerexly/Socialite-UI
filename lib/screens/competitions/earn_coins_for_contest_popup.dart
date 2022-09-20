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
      body: Stack(
        children: [
          Container().ripple(() {
            Navigator.of(context).pop();
          }),
          Positioned(
            child: Center(
              child: Container(
                  height: 450,
                  color: Theme.of(context).backgroundColor,
                  child: Column(
                    children: [
                      Text(
                        'You need',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Theme.of(context).primaryColor),
                      ).bp(20),
                      Text(
                        '${widget.needCoins} Ziocoin',
                        style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).primaryColor),
                      ).bp(15),
                      Text(
                        'to join this quest',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Theme.of(context).primaryColor),
                      ).bp(120),
                      Text(
                        'Watch Ad to earn Ziocoins',
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).primaryColor),
                      ).ripple(() {}).bp(20),
                      FilledButtonType1(
                        isEnabled: true,
                        enabledTextStyle: Theme.of(context).textTheme.titleSmall!
                            .copyWith(fontWeight: FontWeight.w900).copyWith(color: Colors.white),
                        text: 'Buy coins',
                        onPress: () {
                          Get.back();
                          Get.to(() => PackagesScreen(handler: (newCoins) {
                            setState(() {
                              //coin += newCoins;
                            });
                          }));
                        },
                      ).hP16
                    ],
                  ).setPadding(top: 70, bottom: 45))
                  .round(20)
                  .hP25,
            ),
          ),
        ],
      ),
    );
  }
}
