import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;

// PAYMENT_MODE_IN_APP_PURCHASE =1;
// PAYMENT_MODE_PAYPAL =2;
// PAYMENT_MODE_WALLET =3;
// PAYMENT_MODE_STRIPE =4;
// PAYMENT_MODE_RAZORPAY = 5;
// PAYMENT_MODE_APPLE_PAY = 6;
// PAYMENT_MODE_GOOGLE_PAY = 7

enum ProcessingPaymentStatus { inProcess, completed, failed }

class CheckoutController extends GetxController {
  final Razorpay _razorpay = Razorpay();
  RxBool useWallet = false.obs;
  RxDouble balanceToPay = 0.toDouble().obs;
  Rx<PaymentGateway> selectedPaymentGateway =
      Rx<PaymentGateway>(PaymentGateway.paypal);
  EventTicketOrderRequest? ticketOrder;
  BuildContext? context;

  RxBool googlePaySupported = false.obs;
  Rx<ProcessingPaymentStatus?> processingPayment =
      Rx<ProcessingPaymentStatus?>(null);

  checkIfGooglePaySupported() async {
    googlePaySupported.value = await stripe.Stripe.instance
        .isGooglePaySupported(const stripe.IsGooglePaySupportedParams());
  }

  selectPaymentGateway(PaymentGateway gateway) {
    selectedPaymentGateway.value = gateway;
  }

  useWalletSwitchChange(
      bool status, EventTicketOrderRequest ticketOrder, BuildContext context) {
    this.context = context;

    useWallet.value = status;
    balanceToPay.value = ticketOrder.amountToBePaid! -
        (status == true
            ? double.parse(getIt<UserProfileManager>().user!.balance)
            : 0);
  }

  payAndBuy(
      {required EventTicketOrderRequest ticketOrder,
      required PaymentGateway paymentGateway}) {
    this.ticketOrder = ticketOrder;

    if (useWallet.value) {
      Map<String, String> payment = {
        'payment_mode': '3',
        'amount': (ticketOrder.amountToBePaid! >
                    double.parse(getIt<UserProfileManager>().user!.balance)
                ? getIt<UserProfileManager>().user!.balance
                : ticketOrder.amountToBePaid!)
            .toString(),
        'transaction_id': ''
      };
      this.ticketOrder?.payments = [payment];
    }

    this.ticketOrder?.paidAmount = ticketOrder.amountToBePaid;

    switch (paymentGateway) {
      case PaymentGateway.creditCard:
        Get.to(() => const StripeCardPayment());
        break;
      case PaymentGateway.applePay:
        applePay(ticketOrder);
        break;
      case PaymentGateway.paypal:
        payWithPaypal(ticketOrder);
        break;
      case PaymentGateway.razorpay:
        launchRazorpayPayment(ticketOrder);
        break;
      case PaymentGateway.stripe:
        payWithStripe(ticketOrder);
        break;
      case PaymentGateway.googlePay:
        payWithGooglePay(ticketOrder);
        break;
      case PaymentGateway.inAppPurchse:
        placeOrder();
        break;
      case PaymentGateway.wallet:
        placeOrder();
        break;
    }
  }

  applePay(EventTicketOrderRequest ticketOrder) async {
    try {
      // 1. Present Apple Pay sheet
      await stripe.Stripe.instance.presentApplePay(
        params: stripe.ApplePayPresentParams(
          cartItems: [
            stripe.ApplePayCartSummaryItem.immediate(
              label: 'Product Test',
              amount: '${ticketOrder.paidAmount!}',
            ),
          ],
          country: 'US',
          currency: 'USD',
        ),
      );

      // 2. fetch Intent Client Secret from backend
      final response = await ApiController()
          .fetchPaymentIntentClientSecret(amount: ticketOrder.paidAmount!);
      final clientSecret = response.stripePaymentIntentClientSecret!;

      // 2. Confirm apple pay payment
      await stripe.Stripe.instance.confirmApplePayPayment(clientSecret);

      Map<String, String> payment = {
        'payment_mode': '6',
        'amount': balanceToPay.value.toString(),
        'transaction_id': randomId()
      };

      ticketOrder.payments
          .removeWhere((element) => element['payment_mode'] == '6');
      ticketOrder.payments.add(payment);

      placeOrder();
    } catch (e) {
      AppUtil.showToast(
          context: context!, message: 'Error1: $e', isSuccess: false);
      PlatformException error = (e as PlatformException);
      if (error.code != 'Canceled') {
        processingPayment.value = ProcessingPaymentStatus.failed;
      }
    }
  }

  payWithGooglePay(EventTicketOrderRequest ticketOrder) async {
    final googlePaySupported = await stripe.Stripe.instance
        .isGooglePaySupported(const stripe.IsGooglePaySupportedParams());
    if (googlePaySupported) {
      try {
        // 1. fetch Intent Client Secret from backend
        final response = await ApiController()
            .fetchPaymentIntentClientSecret(amount: ticketOrder.paidAmount!);
        final clientSecret = response.stripePaymentIntentClientSecret!;

        // 2.present google pay sheet
        await stripe.Stripe.instance.initGooglePay(stripe.GooglePayInitParams(
            testEnv: true,
            merchantName: AppConfigConstants.appName,
            countryCode: 'us'));

        await stripe.Stripe.instance.presentGooglePay(
          stripe.PresentGooglePayParams(clientSecret: clientSecret),
        );

        Map<String, String> payment = {
          'payment_mode': '7',
          'amount': balanceToPay.value.toString(),
          'transaction_id': randomId()
        };

        ticketOrder.payments
            .removeWhere((element) => element['payment_mode'] == '7');
        ticketOrder.payments.add(payment);

        placeOrder();
      } catch (e) {
        PlatformException error = (e as PlatformException);
        if (error.code != 'Canceled') {
          processingPayment.value = ProcessingPaymentStatus.failed;
          AppUtil.showToast(
              context: context!, message: 'Error: $e', isSuccess: false);
        }
      }
    } else {
      processingPayment.value = ProcessingPaymentStatus.failed;

      AppUtil.showToast(
          context: context!,
          message: 'Google pay is not supported on this device',
          isSuccess: false);
    }
  }

  payWithPaypal(EventTicketOrderRequest ticketOrder) async {
    EasyLoading.show(status: LocalizationString.loading);

    ApiResponseModel response = await ApiController().fetchPaypalClientToken();

    if (response.paypalClientToken != null) {
      final request = BraintreePayPalRequest(
          amount: ticketOrder.amountToBePaid!.toString());
      BraintreePaymentMethodNonce? result = await Braintree.requestPaypalNonce(
        response.paypalClientToken!,
        request,
      );
      if (result != null) {
        // EasyLoading.dismiss();
        // print(result!.nonce);
        // return;
        processingPayment.value = ProcessingPaymentStatus.inProcess;

        String deviceData = '';
        if (Platform.isAndroid) {
          DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
          AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
          deviceData = 'android, ${androidInfo.model}';
        } else {
          DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
          IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
          deviceData = 'iOS, ${iosInfo.utsname.machine}';
        }
        EasyLoading.dismiss();

        ApiController()
            .sendPaypalPayment(
                amount: ticketOrder.amountToBePaid!,
                nonce: result.nonce,
                deviceData: deviceData)
            .then((response) {
          if (response.success) {
            Map<String, String> payment = {
              'payment_mode': '2',
              'amount': balanceToPay.value.toString(),
              'transaction_id': response.transactionId!
            };

            ticketOrder.payments
                .removeWhere((element) => element['payment_mode'] == '2');
            ticketOrder.payments.add(payment);
            placeOrder();
          } else {
            processingPayment.value = ProcessingPaymentStatus.failed;
          }
        });
      } else {
        EasyLoading.dismiss();
      }
    } else {
      EasyLoading.dismiss();
      processingPayment.value = ProcessingPaymentStatus.failed;
    }
  }

  payWithStripe(EventTicketOrderRequest ticketOrder) async {
    final response = await ApiController()
        .fetchPaymentIntentClientSecret(amount: ticketOrder.paidAmount!);
    final clientSecret = response.stripePaymentIntentClientSecret!;

    await stripe.Stripe.instance.initPaymentSheet(
      paymentSheetParameters: stripe.SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: AppConfigConstants.appName,
        customerId: getIt<UserProfileManager>().user!.id.toString(),

        applePay: const stripe.PaymentSheetApplePay(
          merchantCountryCode: 'US',
        ),
        googlePay: const stripe.PaymentSheetGooglePay(
          merchantCountryCode: 'US',
          testEnv: true,
        ),
        style: ThemeMode.dark,
        appearance: stripe.PaymentSheetAppearance(
          colors: stripe.PaymentSheetAppearanceColors(
            background: Theme.of(context!).cardColor,
            primary: Colors.blue,
            componentBorder: Theme.of(context!).dividerColor,
          ),
          shapes: const stripe.PaymentSheetShape(
            borderWidth: 1,
            shadow: stripe.PaymentSheetShadowParams(color: Colors.red),
          ),
          primaryButton: stripe.PaymentSheetPrimaryButtonAppearance(
            shapes: const stripe.PaymentSheetPrimaryButtonShape(blurRadius: 8),
            colors: stripe.PaymentSheetPrimaryButtonTheme(
              light: stripe.PaymentSheetPrimaryButtonThemeColors(
                background: Theme.of(context!).primaryColor,
                text: const Color.fromARGB(255, 235, 92, 30),
                border: const Color.fromARGB(255, 235, 92, 30),
              ),
            ),
          ),
        ),
        // billingDetails: billingDetails,
      ),
    );
    // await stripe.Stripe.instance.presentPaymentSheet();
    confirmStripePayment();
  }

  confirmStripePayment() async {
    try {
      // 3. display the payment sheet.
      await stripe.Stripe.instance.presentPaymentSheet();

      Map<String, String> payment = {
        'payment_mode': '4',
        'amount': balanceToPay.value.toString(),
        'transaction_id': randomId()
      };

      ticketOrder?.payments
          .removeWhere((element) => element['payment_mode'] == '4');
      ticketOrder?.payments.add(payment);

      placeOrder();
    } on Exception catch (e) {
      if (e is stripe.StripeException) {
        stripe.StripeException error = e;

        if (error.error.code != stripe.FailureCode.Canceled) {
          processingPayment.value = ProcessingPaymentStatus.failed;
          AppUtil.showToast(
              context: context!, message: 'Error: $e', isSuccess: false);
        }
        // processingPayment.value = ProcessingPaymentStatus.failed;

        // AppUtil.showToast(
        //     context: context!,
        //     message: 'Error from Stripe: ${e.error.localizedMessage}',
        //     isSuccess: true);
      } else {
        processingPayment.value = ProcessingPaymentStatus.failed;

        AppUtil.showToast(
            context: context!,
            message: 'Unforeseen error: $e',
            isSuccess: true);
      }
    }
  }

  launchRazorpayPayment(EventTicketOrderRequest ticketOrder) async {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    this.ticketOrder = ticketOrder;
    var options = {
      'key': AppConfigConstants.razorpayKey,
      //<-- your razorpay api key/test or live mode goes here.
      'amount': balanceToPay.value * 100,
      'name': AppConfigConstants.appName,
      'description': ticketOrder.itemName!,
      'prefill': {
        'contact': getIt<UserProfileManager>().user!.phone ?? '',
        'email': getIt<UserProfileManager>().user!.email ?? ''
      },
      'external': {'wallets': []},
      // 'order_id': getRandString(15),
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      processingPayment.value = ProcessingPaymentStatus.failed;

      debugPrint(e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Map<String, String> payment = {
      'payment_mode': '5',
      'amount': balanceToPay.value.toString(),
      'transaction_id': response.paymentId!
    };

    ticketOrder?.payments
        .removeWhere((element) => element['payment_mode'] == '5');
    ticketOrder?.payments.add(payment);

    placeOrder();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    print(response.message);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
    // Do something when payment fails
    print(response.walletName);
  }

  placeOrder() {
    processingPayment.value = ProcessingPaymentStatus.inProcess;

    ApiController().buyTicket(orderRequest: ticketOrder!).then((response) {
      if (response.success) {
        if (ticketOrder!.gifToUser != null) {
          ApiController()
              .giftEventTicket(
                  ticketId: response.bookingId!, toUserId: ticketOrder!.gifToUser!.id)
              .then((result) {
            if (result.success) {
              orderPlaced();
            } else {
              processingPayment.value = ProcessingPaymentStatus.failed;

              AppUtil.showToast(
                  context: context!,
                  message: LocalizationString.errorMessage,
                  isSuccess: true);
            }
          });
        } else {
          orderPlaced();
        }
      } else {
        processingPayment.value = ProcessingPaymentStatus.failed;

        AppUtil.showToast(
            context: context!,
            message: LocalizationString.errorMessage,
            isSuccess: true);
      }
    });
  }

  orderPlaced() {
    Timer(const Duration(seconds: 1), () {
      processingPayment.value = ProcessingPaymentStatus.completed;
    });
  }
}
