import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class ETicket extends StatefulWidget {
  final EventBookingModel booking;

  const ETicket({Key? key, required this.booking}) : super(key: key);

  @override
  State<ETicket> createState() => _ETicketState();
}

class _ETicketState extends State<ETicket> {
  final EventBookingDetailController _eventBookingDetailController =
      EventBookingDetailController();

  WidgetsToImageController controller = WidgetsToImageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Column(children: [
          const SizedBox(
            height: 50,
          ),
          backNavigationBar(
            context: context,
            title: LocalizationString.eTicket,
          ),
          divider(context: context).tP8,
          Expanded(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: WidgetsToImage(
                      controller: controller,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: Container(
                              color: Colors.white,
                              child: QrImage(
                                data: "${widget.booking.id}",
                                version: QrVersions.auto,
                                size: Get.width * 0.7,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          eventInfoWidget(),
                          const SizedBox(
                            height: 20,
                          ),
                          bookingInfoWidget(),
                          const SizedBox(
                            height: 100,
                          ),
                        ],
                      )),
                ),
                Positioned(
                    bottom: 20,
                    left: 16,
                    right: 16,
                    child: FilledButtonType1(
                      text: LocalizationString.saveETicket,
                      onPress: () {
                        saveTicket();
                      },
                    ))
              ],
            ),
          )
        ]));
  }

  Widget eventInfoWidget() {
    return Container(
      width: double.infinity,
      color: Theme.of(context).cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocalizationString.event,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                widget.booking.event.name,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.w800),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocalizationString.dateAndTime,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                widget.booking.event.startAtDateTime,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.w800),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocalizationString.eventLocation,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                '${widget.booking.event.completeAddress}, ${widget.booking.event.placeName}',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.w800),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocalizationString.eventOrganizer,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 10,
              ),
              for (EventOrganizer sponsor
                  in widget.booking.event.organizers )
                Wrap(
                  children: [
                    Text(
                      sponsor.name,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.w800),
                    )
                  ],
                ),
            ],
          )
        ],
      ).setPadding(top: 25, bottom: 25, left: 16, right: 16),
    ).round(20).hP16;
  }

  Widget bookingInfoWidget() {
    return Container(
      width: double.infinity,
      color: Theme.of(context).cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
      ).setPadding(top: 25, bottom: 25, left: 16, right: 16),
    ).round(20).hP16;
  }

  saveTicket() {
    EasyLoading.show(status: LocalizationString.loading);
    controller.capture().then((bytes) {
      _eventBookingDetailController.saveETicket(bytes!, context);
      EasyLoading.dismiss();
    });
  }
}
