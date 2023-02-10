import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';
import '../../../controllers/relationship_search_controller.dart';

class SearchProfile extends StatefulWidget {
  final int? relationId;
  final VoidCallback? actionPerformed;

  const SearchProfile({Key? key, this.relationId, this.actionPerformed})
      : super(key: key);

  @override
  State<SearchProfile> createState() => _SearchProfileState();
}

class _SearchProfileState extends State<SearchProfile> {
  final RelationshipSearchController relationshipSearchController = Get.find();

  @override
  void dispose() {
    relationshipSearchController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: KeyboardDismissOnTap(
            child: Column(
          children: [
            const SizedBox(height: 40),
            Row(
              children: [
                const ThemeIconWidget(
                  ThemeIcon.backArrow,
                  size: 25,
                ).ripple(() {
                  Get.back();
                }),
                const SizedBox(width: 10),
                Expanded(
                  child: SearchBar(
                      showSearchIcon: true,
                      iconColor: Theme.of(context).primaryColor,
                      onSearchChanged: (value) {
                        relationshipSearchController.searchTextChanged(value);
                      },
                      onSearchStarted: () {
                        //controller.startSearch();
                      },
                      onSearchCompleted: (searchTerm) {}),
                ),
                Obx(() => relationshipSearchController.searchText.isNotEmpty
                    ? Row(
                        children: [
                          const SizedBox(width: 10),
                          Container(
                            height: 50,
                            width: 50,
                            color: Theme.of(context).primaryColor,
                            child: ThemeIconWidget(
                              ThemeIcon.close,
                              color: Theme.of(context).backgroundColor,
                              size: 25,
                            ),
                          ).round(20).ripple(() {
                            relationshipSearchController.closeSearch();
                          }),
                        ],
                      )
                    : Container())
              ],
            ).setPadding(left: 16, right: 16, top: 25, bottom: 20),
            GetBuilder<RelationshipSearchController>(
                init: relationshipSearchController,
                builder: (ctx) {
                  return Expanded(
                    child: searchedResult(),
                  );
                })
          ],
        )),
      ),
    );
  }

  Widget searchedResult() {
    ScrollController scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        if (!relationshipSearchController.accountsIsLoading) {
          relationshipSearchController.searchData();
        }
      }
    });

    return relationshipSearchController.accountsIsLoading
        ? const ShimmerUsers()
        : relationshipSearchController.searchedUsers.isNotEmpty
            ? ListView.separated(
                controller: scrollController,
                padding: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 100),
                itemCount: relationshipSearchController.searchedUsers.length,
                itemBuilder: (BuildContext ctx, int index) {
                  return RelationUserTile(
                    profile: relationshipSearchController.searchedUsers[index],
                    inviteCallback: (userID) {
                      relationshipSearchController
                          .inviteUser(widget.relationId ?? 0, userID, () {
                        if (widget.actionPerformed != null) {
                          widget.actionPerformed!();
                          Navigator.pop(context);
                        }
                      });
                    },
                    unInviteCallback: (userID) {
                      relationshipSearchController.unInviteUser(userID);
                    },
                  );
                },
                separatorBuilder: (BuildContext ctx, int index) {
                  return const SizedBox(height: 20);
                })
            : SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: emptyUser(
                    context: context,
                    title: LocalizationString.noUserFound,
                    subTitle: ''),
              );
  }
}
