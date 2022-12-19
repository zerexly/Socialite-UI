import 'package:get/get.dart';
import 'package:foap/helper/common_import.dart';

class EventDetailController extends GetxController {
  Rx<EventModel?> event = Rx<EventModel?>(null);
  RxList<EventCoupon> coupons = <EventCoupon>[].obs;
  double? minTicketPrice;
  double? maxTicketPrice;

  RxBool isLoading = false.obs;

  setEvent(EventModel eventObj) {
    event.value = eventObj;
    event.refresh();
    eventDetail();
    update();
  }

  eventDetail() {
    isLoading.value = true;
    ApiController().getEventDetail(eventId: event.value!.id).then((response) {
      if (response.success) {
        event.value = response.event;
        isLoading.value = false;

        List<EventTicketType> ticketTypes = event.value!.tickets;
        ticketTypes.sort((a, b) => a.price.compareTo(b.price));

        if (!event.value!.isFree) {
          minTicketPrice = ticketTypes.first.price;
          maxTicketPrice = ticketTypes.last.price;
        }

        update();
      }
    });
  }

  loadEventCoupons(int eventId) {
    ApiController().getEventCoupons(eventId: eventId).then((response) {
      if (response.success) {
        coupons.value = response.eventCoupons;
        update();
      }
    });
  }

  joinEvent() {
    event.value!.isJoined = true;
    event.refresh();
    ApiController().joinEvent(eventId: event.value!.id).then((response) {
      if (response.success) {}
    });
  }

  leaveEvent() {
    event.value!.isJoined = false;
    event.refresh();
    ApiController().leaveEvent(eventId: event.value!.id).then((response) {});
  }
}
