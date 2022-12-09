import 'package:get/get.dart';
import 'package:foap/helper/common_import.dart';

class EventsController extends GetxController {
  RxList<EventModel> events = <EventModel>[].obs;
  RxList<EventCategoryModel> categories = <EventCategoryModel>[].obs;
  RxList<EventMemberModel> members = <EventMemberModel>[].obs;

  RxBool isLoadingCategories = false.obs;

  int eventsPage = 1;
  bool canLoadMoreEvents = true;
  RxBool isLoadingEvents = false.obs;

  int membersPage = 1;
  bool canLoadMoreMembers = true;
  bool isLoadingMembers = false;

  RxInt segmentIndex = (-1).obs;

  clear() {
    isLoadingEvents.value = false;
    events.value = [];
    eventsPage = 1;
    canLoadMoreEvents = true;
  }

  clearMembers() {
    isLoadingMembers = false;
    members.value = [];
    membersPage = 1;
    canLoadMoreMembers = true;
  }

  selectedSegmentIndex(int index) {
    if (isLoadingEvents.value == true) {
      return;
    }
    update();

    if (index == 0 && segmentIndex.value != index) {
      clear();
      getEvents();
    } else if (index == 1 && segmentIndex.value != index) {
      clear();
      getEvents(isJoined: 1);
    } else if (index == 2 && segmentIndex.value != index) {
      clear();
      getEvents(userId: getIt<UserProfileManager>().user!.id);
    }

    segmentIndex.value = index;
  }

  getEvents({String? name, int? categoryId, int? userId, int? isJoined}) {
    if (canLoadMoreEvents) {
      isLoadingEvents.value = true;
      ApiController()
          .getEvents(
              name: name,
              categoryId: categoryId,
              userId: userId,
              isJoined: isJoined,
              page: eventsPage)
          .then((response) {
        events.addAll(response.events);
        isLoadingEvents.value = false;

        eventsPage += 1;
        if (response.events.length == response.metaData?.perPage) {
          canLoadMoreEvents = true;
        } else {
          canLoadMoreEvents = false;
        }
        update();
      });
    }
  }

  eventDeleted(EventModel event) {
    events.removeWhere((element) => element.id == event.id);
    events.refresh();
  }

  getMembers({int? eventId}) {
    if (canLoadMoreMembers) {
      isLoadingMembers = true;
      ApiController()
          .getEventMembers(eventId: eventId, page: membersPage)
          .then((response) {
        members.addAll(response.eventMembers);
        isLoadingMembers = false;

        membersPage += 1;
        if (response.eventMembers.length == response.metaData?.perPage) {
          canLoadMoreMembers = true;
        } else {
          canLoadMoreMembers = false;
        }
        update();
      });
    }
  }

  getCategories() {
    isLoadingCategories.value = true;
    ApiController().getEventCategories().then((response) {
      categories.value = response.eventCategories;
      isLoadingCategories.value = false;

      update();
    });
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
