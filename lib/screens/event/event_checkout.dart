import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class EventCheckout extends StatefulWidget {
  const EventCheckout({Key? key}) : super(key: key);

  @override
  State<EventCheckout> createState() => _EventCheckoutState();
}

class _EventCheckoutState extends State<EventCheckout> {
  final CheckoutController _checkoutController = CheckoutController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SizedBox(
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
                          const SizedBox(
                            height: 25,
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          paymentGateways().hP16,
                          const SizedBox(
                            height: 25,
                          ),
                        ]),
                  ),
                  Positioned(
                      bottom: 20, left: 25, right: 25, child: checkoutButton())
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget paymentGateways() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocalizationString.selectPaymentGateway,
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(
          height: 40,
        ),
        PaymentMethodTile(
          text: LocalizationString.creditCard,
          icon: "assets/credit-card.png",
          press: () {
            // Get.to(() => NewCreditCardPayment(booking: booking));
          },
        ),
        PaymentMethodTile(
          text: LocalizationString.applePay,
          icon: "assets/applePay.png",
          press: () {
            _checkoutController.applePay();
          },
        ),
        PaymentMethodTile(
          text: LocalizationString.paypal,
          icon: "assets/paypal.png",
          press: () {
            _checkoutController.launchBrainTree();
          },
        ),
        PaymentMethodTile(
          text: LocalizationString.razorPay,
          icon: "assets/razorpay.png",
          press: () {
            _checkoutController.launchRazorpayPayment();
          },
        ),
        PaymentMethodTile(
          text: LocalizationString.cash,
          icon: "assets/cash.png",
          press: () {
            // PaymentModel payment = PaymentModel();
            // payment.id = getRandString(20);
            // payment.mode = 'cash';
            // payment.amount = booking.bookingTotalDoubleValue();
            // placeOrder(payment);
          },
        ),
      ],
    );
  }

  Widget checkoutButton() {
    return Container(
      height: 50,
      color: Theme.of(context).primaryColor,
      child: Row(
        children: [
          Text(
            LocalizationString.makePayment,
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          Text(
            '\$500',
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ).hP16,
    ).round(20);
  }
}
