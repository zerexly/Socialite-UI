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
  final EventDetailController _eventDetailController = EventDetailController();
  final SettingsController _settingsController = Get.find();

  TextEditingController couponCode = TextEditingController();

  @override
  void initState() {
    _buyTicketController.setEvent(widget.event);
    _eventDetailController.loadEventCoupons(widget.event.id);
    super.initState();
  }

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
              child: Obx(() => Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 25,
                              ),
                              ticketType(),
                              const SizedBox(
                                height: 25,
                              ),
                              _buyTicketController.selectedTicketType.value !=
                                      null
                                  ? Column(
                                      children: [
                                        eventDetail().hP16,
                                        const SizedBox(
                                          height: 25,
                                        ),
                                        couponsList(),
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
                                      ],
                                    )
                                  : Container(),
                            ]),
                      ),
                      Obx(() =>
                          _buyTicketController.ticketOrder.eventTicketTypeId !=
                                  null
                              ? Positioned(
                                  bottom: 20,
                                  left: 25,
                                  right: 25,
                                  child: checkoutButton())
                              : Container())
                    ],
                  )),
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
                      widget.event.startAtFullDate.toUpperCase(),
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
        ).hP16,
        const SizedBox(
          height: 40,
        ),
        SizedBox(
          height: 165,
          child: ListView.separated(
            padding: const EdgeInsets.only(left: 16, right: 16),
            scrollDirection: Axis.horizontal,
            itemCount: widget.event.tickets.length,
            itemBuilder: (context, index) {
              return Obx(() => ticketTypeWidget(
                          ticket: widget.event.tickets[index],
                          isSelected: _buyTicketController
                                  .selectedTicketType.value?.id ==
                              widget.event.tickets[index].id)
                      .ripple(() {
                    if (widget.event.tickets[index].availableTicket > 0) {
                      _buyTicketController
                          .selectTicketType(widget.event.tickets[index]);
                    }
                  }));
            },
            separatorBuilder: (context, index) {
              return const SizedBox(
                width: 20,
              );
            },
          ),
        )
      ],
    );
  }

  Widget ticketTypeWidget(
      {required EventTicketType ticket, required bool isSelected}) {
    return Container(
      color: Theme.of(context).cardColor,
      width: Get.width * 0.6,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                      color: Theme.of(context).primaryColor.withOpacity(0.5),
                      child: Text(
                        ticket.name,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontWeight: FontWeight.w500),
                      ).p4)
                  .round(5),
              const SizedBox(
                height: 15,
              ),
              Text(
                '\$${ticket.price}',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text(
                    LocalizationString.totalSeats,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColor),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    '${ticket.limit}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text(
                    LocalizationString.availableSeats,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColor),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    '${ticket.availableTicket}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                ],
              )
            ],
          ),
          const Spacer(),
          // const ThemeIconWidget(ThemeIcon.checkMarkWithCircle, size: 28),
        ],
      ).p16,
    ).borderWithRadius(
        context: context,
        value: isSelected == true ? 4 : 1,
        radius: 20,
        color: isSelected == true ? Theme.of(context).primaryColor : null);
  }

  Widget couponsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocalizationString.applyCoupon,
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(fontWeight: FontWeight.w500),
        ).hP16,
        const SizedBox(
          height: 40,
        ),
        SizedBox(
          height: 150,
          child: Obx(() => ListView.separated(
                padding: const EdgeInsets.only(left: 16, right: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _eventDetailController.coupons.length,
                itemBuilder: (context, index) {
                  return Obx(() => couponWidget(
                              coupon: _eventDetailController.coupons[index],
                              isSelected: _buyTicketController
                                      .selectedCoupon.value?.id ==
                                  _eventDetailController.coupons[index].id)
                          .ripple(() {
                        if (_buyTicketController.selectedTicketType.value!.availableTicket > 0) {
                          _buyTicketController.selectEventCoupon(
                              _eventDetailController.coupons[index]);
                        }
                      }));
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    width: 20,
                  );
                },
              )),
        )
      ],
    );
  }

  Widget couponWidget({required EventCoupon coupon, required bool isSelected}) {
    return Container(
      color: Theme.of(context).cardColor,
      width: Get.width * 0.7,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '${LocalizationString.code} :',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    coupon.code,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColor),
                  ),
                ],
              ),
              divider(context: context, color: Theme.of(context).primaryColor)
                  .vP8,
              Row(
                children: [
                  Text(
                    '${LocalizationString.discount} :',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    '\$${coupon.discount}',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColor),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text(
                    '${LocalizationString.minimumOrderPrice} :',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    '\$${coupon.minimumOrderPrice}',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColor),
                  ),
                ],
              ),
              // const SizedBox(
              //   height: 5,
              // ),
              // Text(
              //   coupon.title,
              //   style: Theme.of(context)
              //       .textTheme
              //       .bodyLarge!
              //       .copyWith(fontWeight: FontWeight.w500),
              // ),
            ],
          ),
          const Spacer(),
          // const ThemeIconWidget(ThemeIcon.checkMarkWithCircle, size: 28),
        ],
      ).p25,
    ).borderWithRadius(
        context: context,
        value: isSelected == true ? 4 : 1,
        radius: 20,
        color: isSelected == true ? Theme.of(context).primaryColor : null);
  }

  // Widget applyCouponWidget() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         LocalizationString.applyCoupon,
  //         style: Theme.of(context)
  //             .textTheme
  //             .titleSmall!
  //             .copyWith(fontWeight: FontWeight.w500),
  //       ),
  //       const SizedBox(
  //         height: 40,
  //       ),
  //       Container(
  //         color: Theme.of(context).cardColor,
  //         child: Row(
  //           children: [
  //             Expanded(
  //               child: InputField(
  //                 controller: couponCode,
  //                 cornerRadius: 20,
  //                 hintText: LocalizationString.applyCoupon,
  //                 textStyle: Theme.of(context).textTheme.bodyLarge,
  //               ),
  //             ),
  //             const SizedBox(
  //               width: 20,
  //             ),
  //             SizedBox(
  //                 height: 50,
  //                 width: 100,
  //                 child: FilledButtonType1(
  //                     text: LocalizationString.apply, onPress: () {}))
  //           ],
  //         ).setPadding(left: 16, right: 16, top: 8, bottom: 8),
  //       ).round(15)
  //     ],
  //   );
  // }

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
                '\$${_buyTicketController.selectedTicketType.value!.price * _buyTicketController.numberOfTickets.value}',
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
                LocalizationString.serviceFee,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontWeight: FontWeight.w300),
              ),
              const Spacer(),
              Text(
                '\$${_settingsController.setting.value!.serviceFee}',
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
          // Row(
          //   children: [
          //     Text(
          //       LocalizationString.tax,
          //       style: Theme.of(context)
          //           .textTheme
          //           .bodySmall!
          //           .copyWith(fontWeight: FontWeight.w300),
          //     ),
          //     const Spacer(),
          //     Text(
          //       '\$20.0',
          //       style: Theme.of(context)
          //           .textTheme
          //           .bodySmall!
          //           .copyWith(fontWeight: FontWeight.w600),
          //     ),
          //   ],
          // ),
          // const SizedBox(
          //   height: 10,
          // ),
          if (_buyTicketController.selectedCoupon.value != null)
            Row(
              children: [
                Text(
                  '${LocalizationString.couponCode} (${_buyTicketController.selectedCoupon.value!.code})',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).primaryColor),
                ),
                const Spacer(),
                Text(
                  '-\$${_buyTicketController.selectedCoupon.value!.discount}',
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
                '\$${_buyTicketController.amountToBePaid}',
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
      child: Center(
        child: Text(
          LocalizationString.checkout,
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(fontWeight: FontWeight.w600),
        ).hP16,
      ),
    ).round(20).ripple(() {
      Get.to(() => EventCheckout(
            ticketOrder: _buyTicketController.ticketOrder,
          ));
    });
  }
}
