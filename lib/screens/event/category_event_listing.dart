import 'package:get/get.dart';
import 'package:foap/helper/common_import.dart';

class CategoryEventsListing extends StatefulWidget {
  final EventCategoryModel category;

  const CategoryEventsListing({Key? key, required this.category})
      : super(key: key);

  @override
  CategoryEventsListingState createState() => CategoryEventsListingState();
}

class CategoryEventsListingState extends State<CategoryEventsListing> {
  final EventsController _eventsController = Get.find();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _eventsController.getEvents(categoryId: widget.category.id);
      _eventsController.selectedSegmentIndex(0);
    });

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _eventsController.clear();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          backNavigationBar(
            context: context,
            title: widget.category.name,
          ),
          divider(context: context).tP8,
          Expanded(
            child: Obx(() {
              ScrollController scrollController = ScrollController();
              scrollController.addListener(() {
                if (scrollController.position.maxScrollExtent ==
                    scrollController.position.pixels) {
                  if (!_eventsController.isLoadingEvents.value) {
                    _eventsController.getEvents(categoryId: widget.category.id);
                  }
                }
              });

              List<EventModel> events = _eventsController.events;

              return events.isNotEmpty
                  ? Container()
                  : SizedBox(
                      height: 10 * 200,
                      child: ListView.separated(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, top: 20, bottom: 50),
                          itemCount: 10,
                          itemBuilder: (BuildContext ctx, int index) {
                            EventModel event = EventModel(
                                id: 1,
                                categoryId: 1,
                                address: 'test address',
                                createdBy: 1,
                                desc: 'test desc',
                                image:
                                    'https://plus.unsplash.com/premium_photo-1667857742833-a97de5712d81?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8cGFydHl8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60',
                                imageName: 'name',
                                isJoined: false,
                                name: 'Event name',
                                sponsorImage:
                                    'https://images.unsplash.com/photo-1512850692650-c382e34f7fb2?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8bWFsZSUyMG1vZGVsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=800&q=60',
                                sponsorName: 'Sponsor name',
                                isFavourite: true,
                                totalMembers: 200);

                            return EventCard2(
                              event: event,
                              joinBtnClicked: () {
                                _eventsController.joinEvent(events[index]);
                              },
                              leaveBtnClicked: () {
                                _eventsController.leaveEvent(events[index]);
                              },
                              previewBtnClicked: () {
                                Get.to(() => EventDetail(
                                      event: events[index],
                                      needRefreshCallback: () {
                                        _eventsController.getEvents(
                                            categoryId: widget.category.id);
                                      },
                                    ));
                              },
                            );
                          },
                          separatorBuilder: (BuildContext ctx, int index) {
                            return const SizedBox(
                              height: 25,
                            );
                          }),
                    );
            }),
          ),
        ],
      ),
    );
  }

  showActionSheet(PostModel post) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => ActionSheet1(
              items: [
                GenericItem(
                    id: '1',
                    title: LocalizationString.share,
                    icon: ThemeIcon.share),
                GenericItem(
                    id: '2',
                    title: LocalizationString.report,
                    icon: ThemeIcon.report),
                GenericItem(
                    id: '3',
                    title: LocalizationString.hide,
                    icon: ThemeIcon.hide),
              ],
              itemCallBack: (item) {},
            ));
  }
}
