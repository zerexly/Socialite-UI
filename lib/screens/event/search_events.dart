import 'package:get/get.dart';
import 'package:foap/helper/common_import.dart';

class SearchEventListing extends StatefulWidget {
  const SearchEventListing({Key? key}) : super(key: key);

  @override
  SearchEventListingState createState() => SearchEventListingState();
}

class SearchEventListingState extends State<SearchEventListing> {
  final EventsController _eventsController = Get.find();

  @override
  void initState() {
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
            height: 40,
          ),
          Row(
            children: [
              const ThemeIconWidget(
                ThemeIcon.backArrow,
                size: 25,
              ).ripple(() {
                Get.back();
              }),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: SearchBar(
                    hintText: LocalizationString.search,
                    showSearchIcon: true,
                    iconColor: Theme.of(context).primaryColor,
                    onSearchChanged: (value) {
                      _eventsController.searchTextChanged(value);
                    },
                    onSearchStarted: () {
                      //controller.startSearch();
                    },
                    onSearchCompleted: (searchTerm) {}),
              ),
            ],
          ).setPadding(left: 16, right: 16, top: 25, bottom: 20),
          divider(context: context).tP8,
          Expanded(
            child: Obx(() {
              ScrollController scrollController = ScrollController();
              scrollController.addListener(() {
                if (scrollController.position.maxScrollExtent ==
                    scrollController.position.pixels) {
                  if (!_eventsController.isLoadingEvents.value) {
                    _eventsController.getEvents();
                  }
                }
              });

              List<EventModel> events = _eventsController.events;
              return events.isEmpty
                  ? Container()
                  : SizedBox(
                      height: events.length * 200,
                      child: ListView.separated(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, top: 20, bottom: 50),
                          itemCount: events.length,
                          itemBuilder: (BuildContext ctx, int index) {
                            return EventCard2(
                              event: events[index],
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
                                        _eventsController.getEvents();
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
