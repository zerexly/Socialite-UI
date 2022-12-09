import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class SearchEventsController extends GetxController {
  RxList<EventModel> events = <EventModel>[].obs;

  int eventsPage = 1;
  bool canLoadMoreEvents = true;
  RxBool isLoadingEvents = false.obs;

  RxString searchText = ''.obs;

  clear() {
    isLoadingEvents.value = false;
    events.value = [];
    eventsPage = 1;
    canLoadMoreEvents = true;
    searchText = ''.obs;
  }

  searchTextChanged(String text) {
    canLoadMoreEvents = true;
    searchText.value = text;
    searchClubs(name: text, refresh: true);
  }

  searchClubs(
      {String? name,
      int? categoryId,
      int? userId,
      int? isJoined,
      bool? refresh}) {
    if (canLoadMoreEvents) {
      isLoadingEvents.value = true;
      ApiController()
          .getClubs(
              name: name,
              categoryId: categoryId,
              userId: userId,
              isJoined: isJoined,
              page: eventsPage)
          .then((response) {
        if (refresh == true) {
          events.value = response.events;
        } else {
          events.addAll(response.events);
        }
        isLoadingEvents.value = false;

        eventsPage += 1;
        if (response.clubs.length == response.metaData?.perPage) {
          canLoadMoreEvents = true;
        } else {
          canLoadMoreEvents = false;
        }
        update();
      });
    }
  }

  joinEvent(EventModel event) {
    events.value = events.map((element) {
      if (element.id == event.id) {
        element.isJoined = true;
      }
      return element;
    }).toList();

    events.refresh();
    ApiController().joinEvent(eventId: event.id).then((response) {});
  }

  leaveEvent(EventModel event) {
    events.value = events.map((element) {
      if (element.id == event.id) {
        element.isJoined = false;
      }
      return element;
    }).toList();

    events.refresh();
    ApiController().leaveEvent(eventId: event.id).then((response) {});
  }
}
