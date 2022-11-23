import 'package:get/get.dart';
import 'package:foap/helper/common_import.dart';

class PageListing extends StatefulWidget {
  const PageListing({Key? key}) : super(key: key);

  @override
  PageListingState createState() => PageListingState();
}

class PageListingState extends State<PageListing> {
  final ClubsController clubsController = Get.find();

  @override
  void initState() {
    // TODO: implement initState

    clubsController.getCategories();
    clubsController.getClubs();
    super.initState();
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
              title: LocalizationString.clubs,
              iconBtnClicked: () {
                Get.to(() => const CategoriesList());
              },
              icon: ThemeIcon.add),
          divider(context: context).tP8,
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverList(
                    delegate: SliverChildListDelegate([
                  SizedBox(
                    height: 100,
                    child: GetBuilder<ClubsController>(
                        init: clubsController,
                        builder: (ctx) {
                          List<CategoryModel> categories =
                              clubsController.categories;

                          return ListView.separated(
                              padding: const EdgeInsets.only(left: 16),
                              scrollDirection: Axis.horizontal,
                              itemCount: categories.length,
                              itemBuilder: (BuildContext ctx, int index) {
                                return CategoryAvatarType1(
                                    category: categories[index]);
                              },
                              separatorBuilder: (BuildContext ctx, int index) {
                                return const SizedBox(
                                  width: 10,
                                );
                              });
                        }),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(LocalizationString.suggestedClubs,
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                              Text(
                                LocalizationString.clubsYouMightInterested,
                                style: Theme.of(context).textTheme.bodySmall,
                                textAlign: TextAlign.center,
                              ).setPadding(top: 5)
                            ],
                          ),
                          Text(LocalizationString.seeAll,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                          color:
                                              Theme.of(context).primaryColor))
                              .ripple(() {
                            // seeAllPress();
                          })
                        ],
                      ).p16,
                      GetBuilder<ClubsController>(
                          init: clubsController,
                          builder: (ctx) {
                            ScrollController scrollController =
                                ScrollController();
                            scrollController.addListener(() {
                              if (scrollController.position.maxScrollExtent ==
                                  scrollController.position.pixels) {
                                if (!clubsController.isLoadingClubs.value) {
                                  clubsController.getClubs();
                                }
                              }
                            });

                            List<ClubModel> clubs = clubsController.clubs;

                            return ListView.separated(
                                padding: const EdgeInsets.only(left: 16),
                                itemCount: clubs.length,
                                itemBuilder: (BuildContext ctx, int index) {
                                  return ClubCard(
                                    club: clubs[index],
                                    joinBtnClicked: () {},
                                    leaveBtnClicked: () {},
                                    previewBtnClicked: () {
                                      Get.to(() => ClubDetail(
                                            club: clubs[index],
                                            needRefreshCallback: () {},
                                            deleteCallback: (club) {},
                                          ));
                                    },
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext ctx, int index) {
                                  return const SizedBox(
                                    width: 10,
                                  );
                                });
                          }),
                    ],
                  ).bP16,
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
