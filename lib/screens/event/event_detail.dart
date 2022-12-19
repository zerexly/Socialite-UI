import 'package:get/get.dart';
import 'package:foap/helper/common_import.dart';

class EventDetail extends StatefulWidget {
  final EventModel event;
  final VoidCallback needRefreshCallback;

  const EventDetail({
    Key? key,
    required this.event,
    required this.needRefreshCallback,
  }) : super(key: key);

  @override
  EventDetailState createState() => EventDetailState();
}

class EventDetailState extends State<EventDetail> {
  final EventDetailController _eventDetailController = EventDetailController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _eventDetailController.setEvent(widget.event);
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
      body: GetBuilder<EventDetailController>(
          init: _eventDetailController,
          builder: (ctx) {
            return Stack(
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
                                imageUrl: widget.event.image,
                                fit: BoxFit.cover,
                              )),
                          const SizedBox(
                            height: 30,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.event.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(fontWeight: FontWeight.w600)),
                              const SizedBox(
                                height: 40,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const ThemeIconWidget(ThemeIcon.calendar),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.event.startAtFullDate,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                                fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        widget.event.startAtTime,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                                fontWeight: FontWeight.w200),
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
                                  const ThemeIconWidget(ThemeIcon.location),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.event.placeName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                                fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        widget.event.completeAddress,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                                fontWeight: FontWeight.w200),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Text(
                                LocalizationString.organizer,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Obx(() {
                                return _eventDetailController.event.value
                                            ?.organizers.isNotEmpty ==
                                        true
                                    ? Column(
                                        children: [
                                          for (EventOrganizer sponsor
                                              in _eventDetailController.event
                                                      .value?.organizers ??
                                                  [])
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                UserAvatarView(
                                                  user: getIt<
                                                          UserProfileManager>()
                                                      .user!,
                                                  size: 30,
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                Text(
                                                  sponsor.name,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge!
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w600),
                                                )
                                              ],
                                            ).bP16,
                                        ],
                                      )
                                    : Container();
                              }),
                              const SizedBox(
                                height: 40,
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
                                widget.event.description,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(fontWeight: FontWeight.w200),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Text(
                                LocalizationString.location,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              StaticMapWidget(
                                latitude: double.parse(widget.event.latitude),
                                longitude: double.parse(widget.event.longitude),
                                height: 250,
                                width: Get.width.toInt(),
                              ).ripple(() {
                                openDirections();
                              }),
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
                if (!widget.event.isFree)
                  Obx(() => _eventDetailController.isLoading.value == true
                      ? Container()
                      : _eventDetailController.event.value?.ticketsAdded == true
                          ? _eventDetailController.event.value?.isSoldOut ==
                                  true
                              ? soldOutWidget()
                              : buyTicketWidget()
                          : ticketNotAddedWidget())
              ],
            );
          }),
    );
  }

  Widget soldOutWidget() {
    return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          color: Theme.of(context).cardColor,
          height: 100,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/out_of_stock.png',
                height: 20,
                width: 20,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                  child: Text(
                LocalizationString.eventIsSoldOut,
                style: Theme.of(context).textTheme.bodyLarge,
              )),
            ],
          ).hP16,
        ));
  }

  Widget ticketNotAddedWidget() {
    return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          color: Theme.of(context).cardColor,
          height: 100,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/tickets.png',
                height: 20,
                width: 20,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  LocalizationString.ticketWillBeAvailableSoon,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ).hP16,
        ));
  }

  Widget buyTicketWidget() {
    return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          color: Theme.of(context).cardColor,
          height: 100,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (_eventDetailController.minTicketPrice != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      LocalizationString.price,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      '\$${_eventDetailController.minTicketPrice} - \$${_eventDetailController.maxTicketPrice} ',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              const Spacer(),
              SizedBox(
                height: 40,
                width: 120,
                child: FilledButtonType1(
                  text: LocalizationString.buyTicket,
                  onPress: () {
                    Get.to(() => BuyTicket(
                          event: _eventDetailController.event.value!,
                        ));
                  },
                ),
              )
            ],
          ).hP16,
        ));
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
                        coords: Coords(double.parse(widget.event.latitude),
                            double.parse(widget.event.longitude)),
                        title: widget.event.completeAddress,
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
          ],
        ).hP16,
      ),
    );
  }
}
