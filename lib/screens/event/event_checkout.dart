import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class EventCheckout extends StatefulWidget {
  final EventTicketOrderRequest ticketOrder;

  const EventCheckout({Key? key, required this.ticketOrder}) : super(key: key);

  @override
  State<EventCheckout> createState() => _EventCheckoutState();
}

class _EventCheckoutState extends State<EventCheckout> {
  final CheckoutController _checkoutController = CheckoutController();
  final ProfileController _profileController = Get.find();
  final SettingsController _settingsController = Get.find();
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    _profileController.getMyProfile();
    _settingsController.loadSettings();

    _checkoutController.checkIfGooglePaySupported();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkoutController.useWalletSwitchChange(
          false, widget.ticketOrder, context);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Obx(() => _checkoutController.processingPayment.value != null
          ? statusView()
          : SizedBox(
              height: Get.height,
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  backNavigationBar(
                      context: context, title: LocalizationString.buyTicket),
                  divider(context: context).tP8,
                  Expanded(
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      LocalizationString.payableAmount,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                              fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      ' (\$${widget.ticketOrder.amountToBePaid!})',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                              fontWeight: FontWeight.w800,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                    ),
                                  ],
                                ).setPadding(top: 16, left: 16, right: 16),
                                divider(context: context).vP16,
                                walletView(),
                                paymentGateways().hP16,
                                const SizedBox(
                                  height: 25,
                                ),
                              ]),
                        ),
                        Positioned(
                            bottom: 20,
                            left: 25,
                            right: 25,
                            child: checkoutButton())
                      ],
                    ),
                  ),
                ],
              ),
            )),
    );
  }

  Widget statusView() {
    return _checkoutController.processingPayment.value ==
            ProcessingPaymentStatus.inProcess
        ? processingView()
        : _checkoutController.processingPayment.value ==
                ProcessingPaymentStatus.completed
            ? orderPlacedView()
            : errorView();
  }

  Widget walletView() {
    return Obx(() => _profileController.user.value == null
        ? Container()
        : Column(
            children: [
              if (double.parse(_profileController.user.value!.balance) > 0)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // divider(context: context).vP25,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${LocalizationString.wallet} (\$${getIt<UserProfileManager>().user!.balance})',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).primaryColor),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  LocalizationString.useBalance,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  ' (\$${widget.ticketOrder.amountToBePaid! > double.parse(getIt<UserProfileManager>().user!.balance) ? getIt<UserProfileManager>().user!.balance : widget.ticketOrder.amountToBePaid!})',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.w800,
                                          color:
                                              Theme.of(context).primaryColor),
                                ),
                              ],
                            ),
                            Obx(() => Switch(
                                activeColor: Theme.of(context).primaryColor,
                                value: _checkoutController.useWallet.value,
                                onChanged: (value) {
                                  _checkoutController.useWalletSwitchChange(
                                      value, widget.ticketOrder, context);
                                }))
                          ],
                        )
                      ],
                    ).hP16,
                  ],
                ),
              const SizedBox(
                height: 10,
              ),
              if (double.parse(_profileController.user.value!.balance) > 0)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocalizationString.coins,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).primaryColor),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  LocalizationString.availableCoins,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  ' (${getIt<UserProfileManager>().user!.coins})',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.w800,
                                          color:
                                              Theme.of(context).primaryColor),
                                ),
                              ],
                            ),
                            redeemBtn()
                          ],
                        )
                      ],
                    ).hP16,
                    divider(context: context).vP25,
                  ],
                ),
            ],
          ));
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
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.w600)),
            )).round(5).shadow(context: context),
      ),
    );
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
                      _profileController.redeemRequest(coins, context, () {
                        _checkoutController.update();
                      });
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

  Widget paymentGateways() {
    return Obx(() => _checkoutController.balanceToPay.value > 0 ||
            _checkoutController.useWallet.value == false
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                LocalizationString.payUsing,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(
                height: 20,
              ),
              // PaymentMethodTile(
              //   text: LocalizationString.creditCard,
              //   icon: "assets/credit-card.png",
              //   price: '\$${_checkoutController.balanceToPay.value}',
              //   isSelected: _checkoutController.selectedPaymentGateway.value ==
              //       PaymentGateway.creditCard,
              //   press: () {
              //     _checkoutController
              //         .selectPaymentGateway(PaymentGateway.creditCard);
              //     // Get.to(() => NewCreditCardPayment(booking: booking));
              //   },
              // ),
              if (Stripe.instance.isApplePaySupported.value)
                PaymentMethodTile(
                  text: LocalizationString.applePay,
                  icon: "assets/applePay.png",
                  price: '\$${_checkoutController.balanceToPay.value}',
                  isSelected:
                      _checkoutController.selectedPaymentGateway.value ==
                          PaymentGateway.applePay,
                  press: () {
                    // _checkoutController.applePay();
                    _checkoutController
                        .selectPaymentGateway(PaymentGateway.applePay);
                  },
                ),

              Obx(() => _checkoutController.googlePaySupported.value == true
                  ? PaymentMethodTile(
                      text: LocalizationString.googlePay,
                      icon: "assets/google-pay.png",
                      price: '\$${_checkoutController.balanceToPay.value}',
                      isSelected:
                          _checkoutController.selectedPaymentGateway.value ==
                              PaymentGateway.googlePay,
                      press: () {
                        // _checkoutController.applePay();
                        _checkoutController
                            .selectPaymentGateway(PaymentGateway.googlePay);
                      },
                    )
                  : Container()),
              PaymentMethodTile(
                text: LocalizationString.paypal,
                icon: "assets/paypal.png",
                price: '\$${_checkoutController.balanceToPay.value}',
                isSelected: _checkoutController.selectedPaymentGateway.value ==
                    PaymentGateway.paypal,
                press: () {
                  // _checkoutController.launchBrainTree();
                  _checkoutController
                      .selectPaymentGateway(PaymentGateway.paypal);
                },
              ),
              PaymentMethodTile(
                text: LocalizationString.stripe,
                icon: "assets/stripe.png",
                price: '\$${_checkoutController.balanceToPay.value}',
                isSelected: _checkoutController.selectedPaymentGateway.value ==
                    PaymentGateway.stripe,
                press: () {
                  // _checkoutController.launchRazorpayPayment();
                  _checkoutController
                      .selectPaymentGateway(PaymentGateway.stripe);
                },
              ),
              PaymentMethodTile(
                text: LocalizationString.razorPay,
                icon: "assets/razorpay.png",
                price: '\$${_checkoutController.balanceToPay.value}',
                isSelected: _checkoutController.selectedPaymentGateway.value ==
                    PaymentGateway.razorpay,
                press: () {
                  // _checkoutController.launchRazorpayPayment();
                  _checkoutController
                      .selectPaymentGateway(PaymentGateway.razorpay);
                },
              ),
              // PaymentMethodTile(
              //   text: LocalizationString.cash,
              //   icon: "assets/cash.png",
              //   price: _checkoutController.useWallet.value
              //       ? '${widget.ticketOrder.ticketAmount! - double.parse(getIt<UserProfileManager>().user!.balance)}'
              //       : '\$${widget.ticketOrder.ticketAmount!}',
              //   press: () {
              //     // PaymentModel payment = PaymentModel();
              //     // payment.id = getRandString(20);
              //     // payment.mode = 'cash';
              //     // payment.amount = booking.bookingTotalDoubleValue();
              //     // placeOrder(payment);
              //   },
              // ),
            ],
          )
        : Container());
  }

  // widget.ticketOrder.amountToBePaid! -
  // double.parse(getIt<UserProfileManager>().user!.balance) >
  // 0

  Widget checkoutButton() {
    return FilledButtonType1(
        text: LocalizationString.payAndBuy,
        onPress: () {
          if (_checkoutController.useWallet.value) {
            if (widget.ticketOrder.amountToBePaid! <
                double.parse(getIt<UserProfileManager>().user!.balance)) {
              _checkoutController.payAndBuy(
                  widget.ticketOrder, PaymentGateway.wallet);
            } else {
              _checkoutController.payAndBuy(widget.ticketOrder,
                  _checkoutController.selectedPaymentGateway.value);
            }
          } else {
            _checkoutController.payAndBuy(widget.ticketOrder,
                _checkoutController.selectedPaymentGateway.value);
          }
        });
  }

  Widget processingView() {
    return SizedBox(
      height: Get.height,
      width: Get.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/lottie/loading.json'),
          const SizedBox(
            height: 40,
          ),
          Text(
            LocalizationString.placingOrder,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            LocalizationString.doNotCloseApp,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          ),
        ],
      ).hP16,
    );
  }

  Widget orderPlacedView() {
    return SizedBox(
      height: Get.height,
      width: Get.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/lottie/success.json'),
          const SizedBox(
            height: 40,
          ),
          Text(
            LocalizationString.bookingConfirmed,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 40,
          ),
          SizedBox(
              width: 200,
              height: 50,
              child: BorderButtonType1(
                  text: LocalizationString.bookMoreTickets,
                  onPress: () {
                    Get.close(3);
                  }))
        ],
      ).hP16,
    );
  }

  Widget errorView() {
    return SizedBox(
      height: Get.height,
      width: Get.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/lottie/error.json'),
          const SizedBox(
            height: 40,
          ),
          Text(
            LocalizationString.errorInBooking,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            LocalizationString.pleaseTryAgain,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 40,
          ),
          SizedBox(
              width: 100,
              height: 40,
              child: BorderButtonType1(
                  text: LocalizationString.tryAgain,
                  onPress: () {
                    Get.back();
                  }))
        ],
      ).hP16,
    );
  }
}
