import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class EventMembers extends StatefulWidget {
  final EventModel event;

  const EventMembers({Key? key, required this.event}) : super(key: key);

  @override
  EventMembersState createState() => EventMembersState();
}

class EventMembersState extends State<EventMembers> {
  final EventsController _eventsController = Get.find();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() {
    _eventsController.getMembers(eventId: widget.event.id);
  }

  @override
  void didUpdateWidget(covariant EventMembers oldWidget) {
    loadData();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _eventsController.clearMembers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Column(
          children: [
            const SizedBox(
              height: 55,
            ),
            backNavigationBar(
                context: context, title: LocalizationString.clubMembers),
            divider(context: context).tP8,
            Expanded(
              child: GetBuilder<EventsController>(
                  init: _eventsController,
                  builder: (ctx) {
                    ScrollController scrollController = ScrollController();
                    scrollController.addListener(() {
                      if (scrollController.position.maxScrollExtent ==
                          scrollController.position.pixels) {
                        if (!_eventsController.isLoadingMembers) {
                          _eventsController.getMembers(
                              eventId: widget.event.id);
                        }
                      }
                    });

                    List<EventMemberModel> membersList =
                        _eventsController.members;
                    return _eventsController.isLoadingMembers
                        ? const ShimmerUsers().hP16
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              membersList.isEmpty
                                  ? noUserFound(context)
                                  : Expanded(
                                      child: ListView.separated(
                                        padding: const EdgeInsets.only(
                                            top: 20, bottom: 50),
                                        controller: scrollController,
                                        itemCount: membersList.length,
                                        itemBuilder: (context, index) {
                                          return EventMemberTile(
                                            member: membersList[index],
                                            viewCallback: () {
                                              Get.to(() => OtherUserProfile(
                                                      userId: membersList[index]
                                                          .id))!
                                                  .then(
                                                      (value) => {loadData()});
                                            },
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return const SizedBox(
                                            height: 20,
                                          );
                                        },
                                      ).hP16,
                                    ),
                            ],
                          );
                  }),
            ),
          ],
        ));
  }
}
