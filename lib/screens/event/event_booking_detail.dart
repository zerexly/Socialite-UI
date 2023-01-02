import 'package:get/get.dart';
import 'package:foap/helper/common_import.dart';
import 'dart:math';

class EventBookingDetail extends StatefulWidget {
  final EventBookingModel booking;

  const EventBookingDetail({
    Key? key,
    required this.booking,
  }) : super(key: key);

  @override
  EventBookingDetailState createState() => EventBookingDetailState();
}

class EventBookingDetailState extends State<EventBookingDetail> {
  final EventBookingDetailController _eventBookingDetailController =
      EventBookingDetailController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _eventBookingDetailController.setEventBooking(widget.booking);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: GetBuilder<EventBookingDetailController>(
          init: _eventBookingDetailController,
          builder: (ctx) {
            return _eventBookingDetailController.bookingCancelled.value == true
                ? cancelledView()
                : Stack(
                    children: [
                      CustomScrollView(
                        slivers: [
                          SliverList(
                              delegate: SliverChildListDelegate([
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SizedBox(
                                    height: 300,
                                    child: CachedNetworkImage(
                                      imageUrl: widget.booking.event.image,
                                      fit: BoxFit.cover,
                                    )),
                                const SizedBox(
                                  height: 30,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(widget.booking.event.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                                fontWeight: FontWeight.w600)),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    attendingUsersList(),
                                    divider(context: context).vp(20),
                                    eventInfo(),
                                    divider(context: context).vP25,
                                    organizerWidget(),
                                    divider(context: context).vP25,
                                    bookingInfoWidget(),
                                    divider(context: context).vP25,
                                    eventInfoWidget(),
                                    divider(context: context).vP25,
                                    eventGallery(),
                                    const SizedBox(
                                      height: 150,
                                    ),
                                  ],
                                ).hP16,
                              ],
                            ),
                          ]))
                        ],
                      ),
                      appBar(),
                      if (widget.booking.statusType ==
                              BookingStatus.confirmed &&
                          widget.booking.event.statusType ==
                              EventStatus.upcoming)
                        Positioned(
                            bottom: 20,
                            left: 16,
                            right: 16,
                            child: FilledButtonType1(
                              text: LocalizationString.cancelBooking,
                              onPress: () {
                                _eventBookingDetailController
                                    .cancelBooking(context);
                              },
                            ))
                    ],
                  );
          }),
    );
  }

  Widget cancelledView() {
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
            LocalizationString.bookingCancelled,
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
              width: 120,
              height: 40,
              child: BorderButtonType1(
                  text: LocalizationString.bookMoreTickets,
                  onPress: () {
                    Get.back();
                  }))
        ],
      ).hP16,
    );
  }

  Widget attendingUsersList() {
    return Row(
      children: [
        SizedBox(
          height: 20,
          width: min(widget.booking.event.gallery.length, 5) * 17,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (ctx, index) {
              return Align(
                widthFactor: 0.6,
                child: CachedNetworkImage(
                  imageUrl: widget.booking.event.gallery[index],
                  width: 20,
                  height: 20,
                  fit: BoxFit.cover,
                ).borderWithRadius(context: context, value: 1, radius: 10),
              );
            },
            itemCount: min(widget.booking.event.gallery.length, 5),
          ),
        ),
        Text(
          '20000 + going',
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(fontWeight: FontWeight.w200),
        ),
        const Spacer()
      ],
    );
  }

  Widget eventInfo() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                    color: Theme.of(context).primaryColor.withOpacity(0.2),
                    child: ThemeIconWidget(ThemeIcon.calendar,
                            color: Theme.of(context).primaryColor)
                        .p8)
                .circular,
            const SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.booking.event.startAtFullDate,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  widget.booking.event.startAtTime,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontWeight: FontWeight.w200),
                )
              ],
            )
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                    color: Theme.of(context).primaryColor.withOpacity(0.2),
                    child: ThemeIconWidget(ThemeIcon.location,
                            color: Theme.of(context).primaryColor)
                        .p8)
                .circular,
            const SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.booking.event.placeName,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  widget.booking.event.completeAddress,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontWeight: FontWeight.w200),
                )
              ],
            )
          ],
        )
      ],
    );
  }

  Widget organizerWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            for (EventOrganizer sponsor
                in widget.booking.event.organizers )
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  UserAvatarView(
                    user: getIt<UserProfileManager>().user!,
                    size: 30,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sponsor.name,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.w400),
                      ),
                      Text(
                        LocalizationString.organizer,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(fontWeight: FontWeight.w200),
                      ),
                    ],
                  )
                ],
              ).bP16,
          ],
        ),
        Text(
          LocalizationString.about,
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          widget.booking.event.description,
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontWeight: FontWeight.w200),
        ),
        const SizedBox(
          height: 40,
        ),
      ],
    );
  }

  Widget bookingInfoWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Theme.of(context).primaryColor.withOpacity(0.4),
          child: Text(
            LocalizationString.bookingInfo,
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(fontWeight: FontWeight.w600),
          ).setPadding(top: 5, bottom: 5, left: 10, right: 10),
        ).round(5),
        const SizedBox(
          height: 20,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                width: 120,
                child: Text(
                  LocalizationString.bookingId,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.w600),
                )),
            Container(
              height: 5,
              width: 5,
              color: Theme.of(context).primaryColor,
            ).circular.rP16,
            Text(
              widget.booking.id.toString(),
              style: Theme.of(context).textTheme.bodySmall!,
            )
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                width: 120,
                child: Text(
                  LocalizationString.bookingStatus,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.w600),
                )),
            Container(
              height: 5,
              width: 5,
              color: Theme.of(context).primaryColor,
            ).circular.rP16,
            Container(
              color: widget.booking.statusType == BookingStatus.cancelled
                  ? Theme.of(context).errorColor.withOpacity(0.7)
                  : Theme.of(context).primaryColor.withOpacity(0.7),
              child: Text(
                widget.booking.statusType == BookingStatus.cancelled
                    ? LocalizationString.cancelled
                    : LocalizationString.confirmed,
                style: Theme.of(context).textTheme.bodySmall!,
              ).p4,
            ).round(5)
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                width: 120,
                child: Text(
                  LocalizationString.bookingDate,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.w600),
                )),
            Container(
              height: 5,
              width: 5,
              color: Theme.of(context).primaryColor,
            ).circular.rP16,
            Text(
              widget.booking.bookingDatetime,
              style: Theme.of(context).textTheme.bodySmall!,
            )
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 120,
              child: Text(
                LocalizationString.ticketType,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              height: 5,
              width: 5,
              color: Theme.of(context).primaryColor,
            ).circular.rP16,
            Text(
              widget.booking.ticketType.name,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(fontWeight: FontWeight.w600),
            )
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                width: 120,
                child: Text(
                  LocalizationString.price,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.w600),
                )),
            Container(
              height: 5,
              width: 5,
              color: Theme.of(context).primaryColor,
            ).circular.rP16,
            Text(
              '\$${widget.booking.paidAmount}',
              style: Theme.of(context).textTheme.bodySmall!,
            )
          ],
        ),
      ],
    );
  }

  Widget eventInfoWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Theme.of(context).primaryColor.withOpacity(0.4),
          child: Text(
            LocalizationString.about,
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(fontWeight: FontWeight.w600),
          ).setPadding(top: 5, bottom: 5, left: 10, right: 10),
        ).round(5),
        const SizedBox(
          height: 10,
        ),
        Text(
          widget.booking.event.description,
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontWeight: FontWeight.w200),
        ),
        const SizedBox(
          height: 40,
        ),
        Container(
          color: Theme.of(context).primaryColor.withOpacity(0.4),
          child: Text(
            LocalizationString.location,
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(fontWeight: FontWeight.w600),
          ).setPadding(top: 5, bottom: 5, left: 10, right: 10),
        ).round(5),
        const SizedBox(
          height: 20,
        ),
        StaticMapWidget(
          latitude: double.parse(widget.booking.event.latitude),
          longitude: double.parse(widget.booking.event.longitude),
          height: 250,
          width: Get.width.toInt(),
        ).ripple(() {
          openDirections();
        }),
      ],
    );
  }

  Widget eventGallery() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            color: Theme.of(context).primaryColor.withOpacity(0.4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LocalizationString.eventGallery,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ).setPadding(top: 5, bottom: 5, left: 10, right: 10),
          ).round(5),
          Text(
            LocalizationString.seeAll,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryColor),
          ).ripple(() {
            Get.to(() => EventGallery(event: widget.booking.event));
          })
        ],
      ),
      const SizedBox(
        height: 20,
      ),
      SizedBox(
        height: 80,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (ctx, index) {
            return CachedNetworkImage(
              imageUrl: widget.booking.event.gallery[index],
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ).round(10);
          },
          separatorBuilder: (ctx, index) {
            return const SizedBox(
              width: 10,
            );
          },
          itemCount: min(widget.booking.event.gallery.length, 4),
        ),
      )
    ]);
  }

  Widget appBar() {
    return Positioned(
      child: Container(
        height: 150.0,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.white,
            gradient: LinearGradient(
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                colors: [
                  Colors.black,
                  Colors.black.withOpacity(0.5),
                  Colors.grey.withOpacity(0.0),
                ],
                stops: const [
                  0.0,
                  0.5,
                  1.0
                ])),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const ThemeIconWidget(
              ThemeIcon.backArrow,
              size: 20,
              color: Colors.white,
            ).ripple(() {
              Get.back();
            }),
            if (widget.booking.statusType != BookingStatus.cancelled)
              Container(
                color: Theme.of(context).primaryColor.withOpacity(0.7),
                child: Text(
                  LocalizationString.viewETicket,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontWeight: FontWeight.w600),
                ).setPadding(top: 5, bottom: 5, left: 10, right: 10),
              ).round(5).ripple(() {
                Get.to(() => ETicket(
                      booking: widget.booking,
                    ));
              }),
          ],
        ).hP16,
      ),
    );
  }

  openDirections() async {
    final availableMaps = await MapLauncher.installedMaps;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Wrap(
              children: <Widget>[
                for (var map in availableMaps)
                  ListTile(
                    onTap: () {
                      map.showMarker(
                        coords: Coords(
                            double.parse(widget.booking.event.latitude),
                            double.parse(widget.booking.event.longitude)),
                        title: widget.booking.event.completeAddress,
                      );
                    },
                    title: Text(
                      '${LocalizationString.openIn} ${map.mapName}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    leading: SvgPicture.asset(
                      map.icon,
                      height: 30.0,
                      width: 30.0,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
