import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class PaymentWithdrawalScreen extends StatefulWidget {
  const PaymentWithdrawalScreen({Key? key}) : super(key: key);

  @override
  PaymentWithdrawalState createState() => PaymentWithdrawalState();
}

class PaymentWithdrawalState extends State<PaymentWithdrawalScreen> {
  final ProfileController profileController = Get.find();

  @override
  void initState() {
    super.initState();

    // getUserProfileApi();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      profileController.getUserProfile();
      profileController.getWithdrawHistory();
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
          backNavigationBar(context, LocalizationString.earnings),
          divider(context: context).vP8,
          const SizedBox(
            height: 20,
          ),
          totalBalanceView(),
          const SizedBox(
            height: 20,
          ),
          withdrawBtn(),
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
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.w600),
              )),
          Expanded(
            child: GetBuilder<ProfileController>(
                init: profileController,
                builder: (ctx) {
                  return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: profileController.payments.length,
                      itemBuilder: (context, index) {
                        PaymentModel paymentModel =
                            profileController.payments[index];
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    15.0, 10.0, 15.0, 15.0),
                                child: Row(children: [
                                  Container(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.1),
                                    height: 31,
                                    width: 31,
                                    child: ThemeIconWidget(ThemeIcon.wallet,
                                        color: Theme.of(context).primaryColor,
                                        size: 25),
                                  ).circular,
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        LocalizationString.withdrawal,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .primaryColor),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        paymentModel.createDate,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      )
                                    ],
                                  ).lP8,
                                  const Spacer(),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '\$${paymentModel.amount}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontWeight: FontWeight.w600),
                                      ).bP4,
                                      Text(
                                        paymentModel.status == 1
                                            ? LocalizationString.pending
                                            : paymentModel.status == 2
                                                ? LocalizationString.rejected
                                                : LocalizationString.completed,
                                        style: paymentModel.status == 1
                                            ? Theme.of(context)
                                                .textTheme
                                                .titleSmall!
                                                .copyWith(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontWeight: FontWeight.w600)
                                            : Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(
                                                    color: Theme.of(context)
                                                        .errorColor,
                                                    fontWeight:
                                                        FontWeight.w600),
                                      ),
                                    ],
                                  )
                                ])),
                          ],
                        );
                      });
                }),
          ),
        ]));
  }

  totalBalanceView() {
    return GetBuilder<ProfileController>(
            init: profileController,
            builder: (ctx) {
              return SizedBox(
                height: 100,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Text(
                          LocalizationString.availableBalance,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Text(
                          '\$${getIt<UserProfileManager>().user!.balance}',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(fontWeight: FontWeight.w900),
                        ),
                      )
                    ]),
              );
            })
        .shadowWithBorder(
            context: context,
            radius: 20,
            shadowOpacity: 2.5,
            borderWidth: 2,
            borderColor: Theme.of(context).primaryColor,
            fillColor: Theme.of(context).backgroundColor)
        .shadow(context: context, shadowOpacity: 0.2)
        .hP16;
  }

  withdrawBtn() {
    return InkWell(
      onTap: () {
        if (int.parse(getIt<UserProfileManager>().user!.balance) < 50) {
          AppUtil.showToast(
              context: context,
              message: LocalizationString.minWithdrawlLimit,
              isSuccess: false);
        } else if ((getIt<UserProfileManager>().user!.paypalId ?? '').isEmpty) {
          AppUtil.showToast(
              context: context,
              message: LocalizationString.pleaseEnterPaypalId,
              isSuccess: false);
        } else {
          profileController.withdrawalRequest(context);
        }
      },
      child: Center(
        child: Container(
            height: 45.0,
            width: 120,
            color: Theme.of(context).primaryColor,
            child: Center(
              child: Text(LocalizationString.withdraw,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.w600, color: Colors.white)),
            )).round(5).shadow(context: context),
      ),
    );
  }
}
