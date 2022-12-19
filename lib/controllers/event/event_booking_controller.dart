import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class EventBookingsController extends GetxController {
  RxList<EventBookingModel> upcomingBookings = <EventBookingModel>[].obs;
  RxList<EventBookingModel> completedBookings = <EventBookingModel>[].obs;
  RxList<EventBookingModel> cancelledBookings = <EventBookingModel>[].obs;

  RxInt selectedSegment = (-1).obs;
  RxBool isLoading = false.obs;

  int upcomingBookingsPage = 1;
  bool canLoadMoreUpcomingBookings = true;

  int completedBookingsPage = 1;
  bool canLoadMoreCompletedBookings = true;

  int cancelledBookingsPage = 1;
  bool canLoadMoreCancelledBookings = true;

  clear() {
    // selectedSegment.value = -1;

    upcomingBookings.clear();
    completedBookings.clear();
    cancelledBookings.clear();
    upcomingBookingsPage = 1;
    canLoadMoreUpcomingBookings = true;
    completedBookingsPage = 1;
    canLoadMoreCompletedBookings = true;
    cancelledBookingsPage = 1;
    canLoadMoreCancelledBookings = true;
  }

  reload() {
    clear();
    loadData(selectedSegment.value);
  }

  loadData(int segment) {
    switch (segment) {
      case 0:
        getUpcomingBookings();
        break;
      case 1:
        getCompletedBookings();
        break;
      case 2:
        getCancelledBookings();
        break;
    }
    selectedSegment.value = segment;
    update();
  }

  changeSegment(int segment) {
    if (selectedSegment.value == segment) {
      return;
    }
    loadData(segment);
  }

  getCompletedBookings() {
    if (isLoading.value == true) {
      return;
    }

    //upcoming = 1, COMPLETED = 3, CANCELLED = 4
    if (canLoadMoreCompletedBookings) {
      isLoading.value = true;

      ApiController().getEventBookings(currentStatus: 3).then((response) {
        completedBookings.addAll(response.eventBookings);
        isLoading.value = false;

        completedBookingsPage += 1;
        if (response.eventBookings.length == response.metaData?.perPage) {
          canLoadMoreCompletedBookings = true;
        } else {
          canLoadMoreCompletedBookings = false;
        }
        update();
      });
    }
  }

  getUpcomingBookings() {
    if (isLoading.value == true) {
      return;
    }
    //upcoming = 1, COMPLETED = 3, CANCELLED = 4
    if (canLoadMoreUpcomingBookings) {
      isLoading.value = true;

      ApiController().getEventBookings(currentStatus: 1).then((response) {
        upcomingBookings.addAll(response.eventBookings);
        isLoading.value = false;

        upcomingBookingsPage += 1;
        if (response.eventBookings.length == response.metaData?.perPage) {
          canLoadMoreUpcomingBookings = true;
        } else {
          canLoadMoreUpcomingBookings = false;
        }
        update();
      });
    }
  }

  getCancelledBookings() {
    if (isLoading.value == true) {
      return;
    }

    //upcoming = 1, COMPLETED = 3, CANCELLED = 4
    if (canLoadMoreCancelledBookings) {
      isLoading.value = true;

      ApiController().getEventBookings(currentStatus: 4).then((response) {
        cancelledBookings.addAll(response.eventBookings);
        isLoading.value = false;

        cancelledBookingsPage += 1;
        if (response.eventBookings.length == response.metaData?.perPage) {
          canLoadMoreCancelledBookings = true;
        } else {
          canLoadMoreCancelledBookings = false;
        }
        update();
      });
    }
  }
}
