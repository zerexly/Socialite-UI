import 'package:get/get.dart';
import 'package:foap/helper/common_import.dart';

class EventDetailController extends GetxController {
  Rx<EventModel?> event = Rx<EventModel?>(null);

  setEvent(EventModel eventObj) {
    event.value = eventObj;
    event.refresh();

    update();
  }

  joinEvent() {
    event.value!.isJoined = true;
    event.refresh();
    ApiController().joinEvent(eventId: event.value!.id!).then((response) {
      if (response.success) {}
    });
  }

  leaveEvent() {
    event.value!.isJoined = false;
    event.refresh();
    ApiController().leaveEvent(eventId: event.value!.id!).then((response) {});
  }
}
