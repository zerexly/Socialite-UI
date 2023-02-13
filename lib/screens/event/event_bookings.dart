import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class EventBookingScreen extends StatefulWidget {
  const EventBookingScreen({Key? key}) : super(key: key);

  @override
  State<EventBookingScreen> createState() => _EventBookingScreenState();
}

class _EventBookingScreenState extends State<EventBookingScreen> {
  final EventBookingsController _eventBookingsController =
      EventBookingsController();

  @override
  void initState() {
    _eventBookingsController.changeSegment(0);
    super.initState();
  }

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
            title: LocalizationString.bookings,
          ),
          divider(context: context).vP16,
          segmentView(),
          Expanded(
              child: GetBuilder<EventBookingsController>(
                  init: _eventBookingsController,
                  builder: (ctx) {
                    List<EventBookingModel> bookings = [];

                    switch (_eventBookingsController.selectedSegment.value) {
                      case 0:
                        bookings = _eventBookingsController.upcomingBookings;
                        break;
                      case 1:
                        bookings = _eventBookingsController.completedBookings;
                        break;
                      case 2:
                        bookings = _eventBookingsController.cancelledBookings;
                        break;
                    }

                    return _eventBookingsController.isLoading.value
                        ? const EventBookingShimmerWidget()
                        : bookings.isEmpty
                            ? emptyData(
                                title: LocalizationString.noBookingFound,
                                subTitle: LocalizationString.goToEventAndBook,
                               )
                            : ListView.separated(
                                padding: const EdgeInsets.only(
                                    top: 16, left: 16, right: 16, bottom: 16),
                                itemCount: bookings.length,
                                itemBuilder: (BuildContext ctx, int index) {
                                  return EventBookingCard(
                                          bookingModel: bookings[index])
                                      .ripple(() {
                                    Get.to(() => EventBookingDetail(
                                            booking: bookings[index]))!
                                        .then((value) {
                                      _eventBookingsController.reload();
                                    });
                                  });
                                },
                                separatorBuilder:
                                    (BuildContext ctx, int index) {
                                  return const SizedBox(
                                    height: 20,
                                  );
                                });
                  }))
        ]));
  }

  Widget segmentView() {
    return HorizontalSegmentBar(
        width: MediaQuery.of(context).size.width,
        hideHighlightIndicator: false,
        onSegmentChange: (segment) {
          _eventBookingsController.changeSegment(segment);
        },
        segments: [
          LocalizationString.upcoming,
          LocalizationString.completed,
          LocalizationString.cancelled,
          // LocalizationString.locations,
        ]);
  }
}
