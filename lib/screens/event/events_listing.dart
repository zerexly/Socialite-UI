import 'package:get/get.dart';
import 'package:foap/helper/common_import.dart';

class EventsListing extends StatefulWidget {
  const EventsListing({Key? key}) : super(key: key);

  @override
  EventsListingState createState() => EventsListingState();
}

class EventsListingState extends State<EventsListing> {
  final EventsController _eventsController = Get.find();
  final _controller = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _eventsController.getCategories();
      _eventsController.getEvents();
      _eventsController.selectedSegmentIndex(0);
    });

    _controller.addListener(() {
      if (_controller.position.atEdge) {
        bool isTop = _controller.position.pixels == 0;
        if (isTop) {
        } else {
          _eventsController.getEvents();
        }
      }
    });

    super.initState();
  }

  loadClubs() {
    _eventsController.clear();
    _eventsController.clearMembers();

    _eventsController.getEvents();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _eventsController.clear();
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
            height: 50,
          ),
          backNavigationBarWithIcon(
              context: context,
              title: LocalizationString.events,
              iconBtnClicked: () {
                _eventsController.clear();
                Get.to(() => const SearchEventListing())!.then((value) {
                  _eventsController.getEvents();
                });
              },
              icon: ThemeIcon.search),
          divider(context: context).tP8,
          Expanded(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 40,
                  child: Obx(() {
                    List<CategoryModel> categories =
                        _eventsController.categories;
                    return _eventsController.isLoadingCategories.value
                        ? const EventCategoriesScreenShimmer()
                        : ListView.separated(
                            padding: const EdgeInsets.only(left: 16),
                            scrollDirection: Axis.horizontal,
                            itemCount: 10,
                            itemBuilder: (BuildContext ctx, int index) {
                              EventCategoryModel category = EventCategoryModel(
                                  id: 1, name: "Category name", coverImage: "");
                              return CategoryAvatarType2(category: category)
                                  .ripple(() {
                                Get.to(() => CategoryEventsListing(
                                        category: category))!
                                    .then((value) {
                                  loadClubs();
                                });
                              });
                            },
                            separatorBuilder: (BuildContext ctx, int index) {
                              return const SizedBox(
                                width: 10,
                              );
                            });
                  }),
                ),
                const SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: GetBuilder<EventsController>(
                      init: _eventsController,
                      builder: (ctx) {
                        return ListView.separated(
                            padding: const EdgeInsets.only(top: 25, bottom: 50),
                            itemBuilder: (ctx, categoryGroupIndex) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Test',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(
                                              fontWeight: FontWeight.w900,
                                            ),
                                      ).lP16,
                                      const Spacer(),
                                      Row(children: [
                                        Text(
                                          LocalizationString.seeAll,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                  fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        const ThemeIconWidget(
                                          ThemeIcon.nextArrow,
                                          size: 15,
                                        ).rP16.ripple(() {
                                          // Get.to(() => CategoryEventsListing(
                                          //     category: _eventsController
                                          //         .categories[categoryGroupIndex]));
                                        }),
                                      ]).ripple(() {
                                        Get.to(() => CategoryEventsListing(
                                            category: EventCategoryModel(
                                                id: 1,
                                                coverImage: '',
                                                name: 'name')));
                                      })
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  SizedBox(
                                    height: 270,
                                    child: ListView.separated(
                                      padding: const EdgeInsets.only(
                                          left: 16, right: 16),
                                      scrollDirection: Axis.horizontal,
                                      // itemCount: _eventsController
                                      //     .categories[categoryGroupIndex]
                                      //     .events
                                      //     .length,
                                      itemCount: 10,
                                      itemBuilder: (ctx, tvIndex) {
                                        // EventModel event = _eventsController
                                        //     .categories[categoryGroupIndex]
                                        //     .events[tvIndex];
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
                                        return EventCard(
                                          event: event,
                                          joinBtnClicked: () {},
                                          leaveBtnClicked: () {},
                                          previewBtnClicked: () {
                                            Get.to(() => EventDetail(
                                                event: event,
                                                needRefreshCallback: () {}));
                                          },
                                        ).ripple(() {});
                                      },
                                      separatorBuilder: (ctx, index) {
                                        return const SizedBox(width: 10);
                                      },
                                    ),
                                  )
                                ],
                              );
                            },
                            separatorBuilder: (ctx, index) {
                              return const SizedBox(
                                height: 40,
                              );
                            },
                            itemCount: 5);
                      }),
                ),
              ],
            ),
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
