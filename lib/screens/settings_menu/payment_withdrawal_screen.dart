import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class PaymentWithdrawalScreen extends StatefulWidget {
  const PaymentWithdrawalScreen({Key? key}) : super(key: key);

  @override
  PaymentWithdrawalState createState() => PaymentWithdrawalState();
}

class PaymentWithdrawalState extends State<PaymentWithdrawalScreen> {
  final ProfileController _profileController = Get.find();
  final SettingsController _settingsController = Get.find();

  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _profileController.getMyProfile();
      _profileController.getWithdrawHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(
            height: 50,
          ),
          backNavigationBar(
              context: context, title: LocalizationString.earnings),
          divider(context: context).vP8,
          const SizedBox(
            height: 20,
          ),
          totalBalanceView(),
          const SizedBox(
            height: 20,
          ),
          totalCoinBalanceView(),
          const SizedBox(
            height: 20,
          ),
          Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, top: 15.0, bottom: 15.0),
              child: Text(
                LocalizationString.transactionHistory,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.w900),
              )),
          Expanded(
            child: GetBuilder<ProfileController>(
                init: _profileController,
                builder: (ctx) {
                  return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: _profileController.payments.length,
                      itemBuilder: (context, index) {
                        PaymentModel paymentModel =
                            _profileController.payments[index];
                        return TransactionTile(model: paymentModel);
                      });
                }),
          ),
        ]));
  }

  totalBalanceView() {
    return GetBuilder<ProfileController>(
        init: _profileController,
        builder: (ctx) {
          return Container(
            color: Theme.of(context).cardColor,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocalizationString.availableBalanceToWithdraw,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '\$${getIt<UserProfileManager>().user!.balance}',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(fontWeight: FontWeight.w900),
                        )
                      ]),
                ),
                withdrawBtn()
              ],
            ).p16,
          ).round(10);
        }).hP16;
  }

  totalCoinBalanceView() {
    return GetBuilder<ProfileController>(
        init: _profileController,
        builder: (ctx) {
          return Container(
            color: Theme.of(context).cardColor,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocalizationString.availableCoins,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${getIt<UserProfileManager>().user!.coins}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(fontWeight: FontWeight.w900),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '= \$${(_settingsController.setting.value!.coinsValue * getIt<UserProfileManager>().user!.coins).toStringAsFixed(2)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context).primaryColor),
                            ),
                          ],
                        )
                      ]),
                ),
                redeemBtn()
              ],
            ).p16,
          ).round(10);
        }).hP16;
  }

  Future<void> askNumberOfCoinToRedeem() async {
    BuildContext dialogContext;

    return showDialog(
        context: context,
        builder: (context) {
          dialogContext = context;

          return AlertDialog(
            title: Text(
              LocalizationString.enterNumberOfCoins,
            ),
            content: Container(
              color: Theme.of(context).backgroundColor,
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        style: Theme.of(context).textTheme.bodyLarge,
                        onChanged: (value) {
                          if (textController.text.isNotEmpty) {
                            _settingsController
                                .redeemCoinValueChange(int.parse(value));
                          } else {
                            _settingsController.redeemCoinValueChange(0);
                          }
                        },
                        controller: textController,
                      ).lP8,
                    ),
                  ),
                  Obx(() => Container(
                        height: 50,
                        color: Theme.of(context).primaryColor,
                        child: Center(
                          child: Text(
                            '= \$${(_settingsController.redeemCoins * _settingsController.setting.value!.coinsValue).toStringAsFixed(2)}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontWeight: FontWeight.w500),
                          ).hP8,
                        ),
                      ).rightRounded(10)),
                ],
              ),
            ).round(10),
            actions: <Widget>[
              FilledButtonType1(
                text: LocalizationString.redeem,
                onPress: () {
                  if (textController.text.isNotEmpty) {
                    int coins = int.parse(textController.text);
                    if (coins >=
                        _settingsController
                            .setting.value!.minCoinsWithdrawLimit) {
                      if (coins >= getIt<UserProfileManager>().user!.coins) {
                        AppUtil.showToast(
                            context: context,
                            message: LocalizationString.enterValidAmountOfCoins
                                .replaceAll(
                                    '{{coins}}',
                                    _settingsController
                                        .setting.value!.minCoinsWithdrawLimit
                                        .toString()),
                            isSuccess: false);
                        return;
                      }
                      _profileController.redeemRequest(coins, context,(){});
                      textController.text = '';
                      Navigator.pop(dialogContext);
                    } else {
                      AppUtil.showToast(
                          context: context,
                          message: LocalizationString.minCoinsRedeemLimit
                              .replaceAll(
                                  '{{coins}}',
                                  _settingsController
                                      .setting.value!.minCoinsWithdrawLimit
                                      .toString()),
                          isSuccess: false);
                    }
                  }
                },
              ),
            ],
          );
        });
  }

  withdrawBtn() {
    return InkWell(
      onTap: () {
        if (int.parse(getIt<UserProfileManager>().user!.balance) < 50) {
          AppUtil.showToast(
              context: context,
              message: LocalizationString.minWithdrawLimit.replaceAll(
                  '{{cash}}',
                  _settingsController.setting.value!.minWithdrawLimit
                      .toString()),
              isSuccess: false);
        } else if ((getIt<UserProfileManager>().user!.paypalId ?? '').isEmpty) {
          AppUtil.showToast(
              context: context,
              message: LocalizationString.pleaseEnterPaypalId,
              isSuccess: false);
        } else {
          _profileController.withdrawalRequest(context);
        }
      },
      child: Center(
        child: Container(
            height: 35.0,
            width: 100,
            color: Theme.of(context).primaryColor,
            child: Center(
              child: Text(LocalizationString.withdraw,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontWeight: FontWeight.w600)),
            )).round(5).shadow(context: context),
      ),
    );
  }
  redeemBtn() {
    return InkWell(
      onTap: () {
        if (getIt<UserProfileManager>().user!.coins <
            _settingsController.setting.value!.minCoinsWithdrawLimit) {
          AppUtil.showToast(
              context: context,
              message: LocalizationString.minCoinsRedeemLimit.replaceAll(
                  '{{coins}}',
                  _settingsController.setting.value!.minCoinsWithdrawLimit
                      .toString()),
              isSuccess: false);
        } else {
          askNumberOfCoinToRedeem();
        }
      },
      child: Center(
        child: Container(
            height: 35.0,
            width: 100,
            color: Theme.of(context).primaryColor,
            child: Center(
              child: Text(LocalizationString.redeem,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontWeight: FontWeight.w600)),
            )).round(5).shadow(context: context),
      ),
    );
  }

}
