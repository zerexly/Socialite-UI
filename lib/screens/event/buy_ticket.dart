import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class BuyTicket extends StatefulWidget {
  final EventModel event;

  const BuyTicket({Key? key, required this.event}) : super(key: key);

  @override
  State<BuyTicket> createState() => _BuyTicketState();
}

class _BuyTicketState extends State<BuyTicket> {
  final BuyTicketController _buyTicketController = BuyTicketController();
  TextEditingController couponCode = TextEditingController();

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
                          eventDetail().hP16,
                          const SizedBox(
                            height: 25,
                          ),
                          divider(context: context).tP8,
                          const SizedBox(
                            height: 25,
                          ),
                          ticketType().hP16,
                          const SizedBox(
                            height: 25,
                          ),
                          applyCouponWidget().hP16,
                          const SizedBox(
                            height: 25,
                          ),
                          divider(context: context).tP8,
                          const SizedBox(
                            height: 25,
                          ),
                          orderSummary().hP16,
                          const SizedBox(
                            height: 150,
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

  Widget eventDetail() {
    return Container(
      height: 120,
      color: Theme.of(context).cardColor.withOpacity(0.4),
      child: Row(
        children: [
          CachedNetworkImage(
            imageUrl: widget.event.image,
            fit: BoxFit.cover,
            width: 80,
            height: 80,
          ).round(15),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '20 June 2022 10:20AM'.toUpperCase(),
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(fontWeight: FontWeight.w200),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.event.name,
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Container(
                          height: 30,
                          width: 30,
                          color: Theme.of(context).cardColor.darken(),
                          child: const ThemeIconWidget(ThemeIcon.minus),
                        ).round(5).ripple(() {
                          _buyTicketController.removeTicket();
                        }),
                        Obx(() => SizedBox(
                              width: 25,
                              child: Center(
                                child: Text(_buyTicketController.numberOfTickets
                                    .toString()),
                              ),
                            )).hP16,
                        Container(
                          height: 30,
                          width: 30,
                          color: Theme.of(context).cardColor.darken(),
                          child: const ThemeIconWidget(ThemeIcon.plus),
                        ).round(5).ripple(() {
                          _buyTicketController.addTicket();
                        }),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ).p8,
    ).round(15);
  }

  Widget ticketType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocalizationString.ticketType,
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 40,
        ),
        ticketTypeWidget(),
        const SizedBox(
          height: 20,
        ),
        ticketTypeWidget()
      ],
    );
  }

  Widget ticketTypeWidget() {
    return Container(
      color: Colors.transparent,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Normal',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                '\$120',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontWeight: FontWeight.w500),
              )
            ],
          ),
          const Spacer(),
          const ThemeIconWidget(ThemeIcon.checkMarkWithCircle, size: 28),
        ],
      ).p25,
    ).borderWithRadius(context: context, value: 1, radius: 20);
  }

  Widget applyCouponWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocalizationString.applyCoupon,
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 40,
        ),
        Container(
          color: Theme.of(context).cardColor,
          child: Row(
            children: [
              Expanded(
                child: InputField(
                  controller: couponCode,
                  cornerRadius: 20,
                  hintText: LocalizationString.applyCoupon,
                  textStyle: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              SizedBox(
                  height: 50,
                  width: 100,
                  child: FilledButtonType1(
                      text: LocalizationString.apply, onPress: () {}))
            ],
          ).setPadding(left: 16, right: 16, top: 8, bottom: 8),
        ).round(15)
      ],
    );
  }

  Widget orderSummary() {
    return Container(
      color: Theme.of(context).cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocalizationString.orderSummary,
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 10,
          ),
          divider(context: context).tP8,
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Text(
                LocalizationString.subTotal,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontWeight: FontWeight.w300),
              ),
              const Spacer(),
              Text(
                '\$20.0',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text(
                LocalizationString.fee,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontWeight: FontWeight.w300),
              ),
              const Spacer(),
              Text(
                '\$20.0',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text(
                LocalizationString.tax,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontWeight: FontWeight.w300),
              ),
              const Spacer(),
              Text(
                '\$20.0',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text(
                '${LocalizationString.couponCode} (TCSTEGD)',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).primaryColor),
              ),
              const Spacer(),
              Text(
                '-\$20.0',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          divider(context: context),
          const SizedBox(
            height: 25,
          ),
          Row(
            children: [
              Text(
                LocalizationString.total,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.w300),
              ),
              const Spacer(),
              Text(
                '\$80.0',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          )
        ],
      ).p16,
    ).round(20);
  }

  Widget checkoutButton() {
    return Container(
      height: 50,
      color: Theme.of(context).primaryColor,
      child: Row(
        children: [
          Text(
            LocalizationString.checkout,
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
    ).round(20).ripple(() {
      Get.to(() => const EventCheckout());
    });
  }
}
