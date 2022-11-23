import 'package:get/get.dart';
import 'package:foap/helper/common_import.dart';

class CategoryClubsListing extends StatefulWidget {
  final CategoryModel category;

  const CategoryClubsListing({Key? key, required this.category})
      : super(key: key);

  @override
  CategoryClubsListingState createState() => CategoryClubsListingState();
}

class CategoryClubsListingState extends State<CategoryClubsListing> {
  final ClubsController _clubsController = Get.find();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _clubsController.getClubs(categoryId: widget.category.id);
      _clubsController.selectedSegmentIndex(0);
    });

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _clubsController.clear();
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
            child: CustomScrollView(
              slivers: [
                SliverList(
                    delegate: SliverChildListDelegate([
                  const SizedBox(
                    height: 20,
                  ),
                  Obx(() => Column(
                        children: [
                          HorizontalMenuBar(
                              padding:
                                  const EdgeInsets.only(left: 16, right: 16),
                              onSegmentChange: (segment) {
                                _clubsController.selectedSegmentIndex(segment);
                              },
                              selectedIndex:
                                  _clubsController.segmentIndex.value,
                              menus: [
                                LocalizationString.all,
                                LocalizationString.joined,
                                LocalizationString.myClub,
                              ]),
                        ],
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  Obx(() {
                    ScrollController scrollController = ScrollController();
                    scrollController.addListener(() {
                      if (scrollController.position.maxScrollExtent ==
                          scrollController.position.pixels) {
                        if (!_clubsController.isLoadingClubs.value) {
                          _clubsController.getClubs(
                              categoryId: widget.category.id);
                        }
                      }
                    });

                    List<ClubModel> clubs = _clubsController.clubs;

                    return _clubsController.clubs.isEmpty
                        ? Container()
                        : Column(
                            children: [
                              SizedBox(
                                height: clubs.length * 295,
                                child: ListView.separated(
                                    padding: const EdgeInsets.only(
                                        left: 16, right: 16),
                                    itemCount: clubs.length,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (BuildContext ctx, int index) {
                                      return ClubCard(
                                        club: clubs[index],
                                        joinBtnClicked: () {
                                          _clubsController
                                              .joinClub(clubs[index]);
                                        },
                                        leaveBtnClicked: () {
                                          _clubsController
                                              .leaveClub(clubs[index]);
                                        },
                                        previewBtnClicked: () {
                                          Get.to(() => ClubDetail(
                                                club: clubs[index],
                                                needRefreshCallback: () {
                                                  _clubsController.getClubs(
                                                      categoryId:
                                                          widget.category.id);
                                                },
                                                deleteCallback: (club) {
                                                  AppUtil.showToast(
                                                      context: context,
                                                      message:
                                                          LocalizationString
                                                              .clubIsDeleted,
                                                      isSuccess: true);
                                                  _clubsController
                                                      .clubDeleted(club);
                                                },
                                              ));
                                        },
                                      );
                                    },
                                    separatorBuilder:
                                        (BuildContext ctx, int index) {
                                      return const SizedBox(
                                        height: 25,
                                      );
                                    }),
                              ),
                            ],
                          ).bP16;
                  }),
                ]))
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
