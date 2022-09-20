import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class FollowerFollowingList extends StatefulWidget {
  final bool isFollowersList;

  const FollowerFollowingList({Key? key, required this.isFollowersList})
      : super(key: key);

  @override
  FollowerFollowingState createState() => FollowerFollowingState();
}

class FollowerFollowingState extends State<FollowerFollowingList> {
  final ProfileController profileController = Get.find();

  @override
  void initState() {
    super.initState();

    if (widget.isFollowersList == true) {
      profileController.getFollowers();
    } else {
      profileController.getFollowingUsers();
    }
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
                context,
                widget.isFollowersList
                    ? LocalizationString.followers
                    : LocalizationString.following),
            divider(context: context).vP8,
            Expanded(
              child: GetBuilder<ProfileController>(
                  init: profileController,
                  builder: (ctx) {
                    ScrollController scrollController = ScrollController();
                    scrollController.addListener(() {
                      if (scrollController.position.maxScrollExtent ==
                          scrollController.position.pixels) {
                        if (widget.isFollowersList == true) {
                          if (!profileController.followersIsLoading) {
                            profileController.getFollowers();
                          }
                        } else {
                          if (!profileController.followingIsLoading) {
                            profileController.getFollowingUsers();
                          }
                        }
                      }
                    });

                    List<UserModel> usersList = widget.isFollowersList == true
                        ? profileController.followers
                        : profileController.following;
                    return profileController.followingIsLoading &&
                            profileController.followersIsLoading
                        ? const ShimmerUsers().hP16
                        : Column(
                            children: [
                              usersList.isEmpty
                                  ? profileController.isLoading.value == false
                                      ? Center(
                                          child: Text(LocalizationString.noData,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      color: Theme.of(context)
                                                          .primaryColor)))
                                      : Container()
                                  : Expanded(
                                      child: ListView.separated(
                                        padding: const EdgeInsets.only(top: 20,bottom: 50 ),
                                        controller: scrollController,
                                        itemCount: usersList.length,
                                        itemBuilder: (context, index) {
                                          return UserTile(
                                            profile: usersList[index],
                                            followCallback: () {
                                              profileController
                                                  .followUser(usersList[index]);
                                            },
                                            unFollowCallback: () {
                                              profileController.unFollowUser(
                                                  usersList[index]);
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
