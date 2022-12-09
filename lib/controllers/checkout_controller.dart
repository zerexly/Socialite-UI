import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class CheckoutController extends GetxController {
  final Razorpay _razorpay = Razorpay();

  applePay() {
    // StripePayment.paymentRequestWithNativePay(
    //   androidPayOptions: AndroidPayPaymentRequest(
    //     totalPrice: "1.20",
    //     currencyCode: "EUR",
    //   ),
    //   applePayOptions: ApplePayPaymentOptions(
    //     countryCode: 'DE',
    //     currencyCode: 'EUR',
    //     items: [
    //       ApplePayItem(
    //         label: 'Test',
    //         amount: '13',
    //       )
    //     ],
    //   ),
    // ).then((token) {
    //   print(token);
    // });
  }

  launchBrainTree() async {
    final request = BraintreeDropInRequest(
      clientToken: AppConfigConstants.braintreeTokenizationKey,
      collectDeviceData: true,
      googlePaymentRequest: BraintreeGooglePaymentRequest(
        totalPrice: '4.20',
        currencyCode: 'USD',
        billingAddressRequired: false,
      ),
      paypalRequest: BraintreePayPalRequest(
        amount: '4.20',
        displayName: 'Example company',
      ),
    );
    BraintreeDropInResult? result = await BraintreeDropIn.start(request);

    if (result != null) {
      print('Nonce: ${result.paymentMethodNonce.nonce}');
    } else {
      print('Selection was canceled.');
    }
  }

  launchRazorpayPayment() async {
    var options = {
      'key': AppConfigConstants.razorpayKey,
      //<-- your razorpay api key/test or live mode goes here.
      'amount': 500 * 100,
      'name': 'flutterdemorazorpay',
      'description': 'Test payment from Flutter app',
      'prefill': {'contact': '7740075447', 'email': 'k@k.com'},
      'external': {'wallets': []},
      // 'order_id': getRandString(15),
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    print(response.orderId);
    print(response.paymentId);
    print(response.signature);

    PaymentModel payment = PaymentModel();
    // payment.id = randomId();
    // payment.mode = 'razorpay';
    // payment.transactionId = response.paymentId;
    // payment.amount = booking.bookingTotalDoubleValue();
    // placeOrder(payment);
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
}
