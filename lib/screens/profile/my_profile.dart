import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  MyProfileState createState() => MyProfileState();
}

class MyProfileState extends State<MyProfile> {
  final ProfileController profileController = Get.find();
  final HighlightsController highlightsController = Get.find();

  @override
  void initState() {
    super.initState();
    initialLoad();
  }

  initialLoad() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      profileController.clear();
      loadData();
    });
  }

  @override
  void didUpdateWidget(covariant MyProfile oldWidget) {
    super.didUpdateWidget(oldWidget);
    loadData();
  }

  @override
  void dispose() {
    profileController.clear();
    super.dispose();
  }

  loadData() {
    profileController.getMyProfile();
    profileController.getMyMentions(getIt<UserProfileManager>().user!.id);
    profileController.getPosts(getIt<UserProfileManager>().user!.id);

    highlightsController.getHighlights(
        userId: getIt<UserProfileManager>().user!.id);
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
            titleNavigationBarWithIcon(
                context: context,
                title: profileController.user.value?.userName ??
                    LocalizationString.loading,
                icon: ThemeIcon.notification,
                completion: () {
                  Get.to(() => const NotificationsScreen());
                }),
            divider(context: context).tP8,
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(top: 10),
                children: [
                  addProfileView(),
                  const SizedBox(height: 20),
                  addHighlightsView(),
                  const SizedBox(height: 40),
                  segmentView(),
                  addPhotoGrid(),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ));
  }

  addProfileView() {
    return GetBuilder<ProfileController>(
        init: profileController,
        builder: (ctx) {
          return profileController.user.value != null
              ? Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                      UserAvatarView(
                          user: profileController.user.value!,
                          size: 65,
                          onTapHandler: () {}),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            profileController.user.value!.userName,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          if (profileController.user.value!.isVerified)
                            Row(
                              children: [
                                const SizedBox(
                                  width: 5,
                                ),
                                Image.asset(
                                  'assets/verified.png',
                                  height: 15,
                                  width: 15,
                                )
                              ],
                            ),
                        ],
                      ).bP4,
                      profileController.user.value!.country != null
                          ? Text(
                              '${profileController.user.value!.country}, ${profileController.user.value!.city}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: Theme.of(context).primaryColor),
                            )
                          : Container(),
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                profileController.user.value!.totalPost
                                    .toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(fontWeight: FontWeight.w600),
                              ).bP8,
                              Text(
                                LocalizationString.posts,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          // const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '${profileController.user.value!.totalFollower}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(fontWeight: FontWeight.w600),
                              ).bP8,
                              Text(
                                LocalizationString.followers,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ).ripple(() {
                            if (profileController.user.value!.totalFollower >
                                0) {
                              Get.to(() => FollowerFollowingList(
                                        isFollowersList: true,
                                        userId: getIt<UserProfileManager>()
                                            .user!
                                            .id,
                                      ))!
                                  .then((value) {
                                loadData();
                              });
                            }
                          }),

                          // const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '${profileController.user.value!.totalFollowing}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(fontWeight: FontWeight.w600),
                              ).bP8,
                              Text(
                                LocalizationString.following,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ).ripple(() {
                            if (profileController.user.value!.totalFollowing >
                                0) {
                              Get.to(() => FollowerFollowingList(
                                      isFollowersList: false,
                                      userId: getIt<UserProfileManager>()
                                          .user!
                                          .id))!
                                  .then((value) {
                                loadData();
                              });
                            }
                          }),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                profileController.user.value!.giftSummary!
                                    .totalCoin.formatNumber
                                    .toString(),
                                style: Theme.of(context).textTheme.titleLarge,
                              ).bP8,
                              Text(
                                LocalizationString.coins,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ).p16.shadow(context: context).hP16,
                      const SizedBox(
                        height: 40,
                      ),
                      BorderButtonType1(
                          height: 40,
                          textStyle: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.w600),
                          text: LocalizationString.editProfile,
                          onPress: () {
                            Get.to(() => const UpdateProfile())!.then((value) {
                              loadData();
                            });
                          })
                    ]).p16
              : Container();
        });
  }

  Widget segmentView() {
    return HorizontalSegmentBar(
        textStyle: Theme.of(context).textTheme.bodyLarge,
        hideHighlightIndicator: false,
        selectedTextStyle: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(color: Theme.of(context).primaryColor)
            .copyWith(fontWeight: FontWeight.w900),
        width: MediaQuery.of(context).size.width,
        onSegmentChange: (segment) {
          profileController.segmentChanged(segment);
        },
        segments: [
          LocalizationString.posts,
          LocalizationString.mentions,
        ]);
  }

  addHighlightsView() {
    return GetBuilder<HighlightsController>(
        init: highlightsController,
        builder: (ctx) {
          return highlightsController.isLoading == true
              ? const StoryAndHighlightsShimmer()
              : HighlightsBar(
                  highlights: highlightsController.highlights,
                  addHighlightCallback: () {
                    Get.to(() => const ChooseStoryForHighlights());
                  },
                  viewHighlightCallback: (highlight) {
                    Get.to(() => HighlightViewer(highlight: highlight))!
                        .then((value) {
                      loadData();
                    });
                  },
                );
        });
  }

  addPhotoGrid() {
    return GetBuilder<ProfileController>(
        init: profileController,
        builder: (ctx) {
          ScrollController scrollController = ScrollController();
          scrollController.addListener(() {
            if (scrollController.position.maxScrollExtent ==
                scrollController.position.pixels) {
              if (profileController.selectedSegment.value == 0) {
                if (!profileController.isLoadingPosts) {
                  profileController
                      .getPosts(getIt<UserProfileManager>().user!.id);
                }
              } else {
                if (!profileController.mentionsPostsIsLoading) {
                  profileController
                      .getMyMentions(getIt<UserProfileManager>().user!.id);
                }
              }
            }
          });

          List<PostModel> posts = profileController.selectedSegment.value == 0
              ? profileController.posts
              : profileController.mentions;

          return profileController.isLoadingPosts
              ? const PostBoxShimmer()
              : MasonryGridView.count(
                  controller: scrollController,
                  padding: const EdgeInsets.only(top: 10),
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  itemCount: posts.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) =>
                      Stack(children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: CachedNetworkImage(
                        imageUrl: posts[index].gallery.first.thumbnail(),
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            AppUtil.addProgressIndicator(context, 100),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.error,
                        ),
                      ).round(10),
                    ).ripple(() {
                      Get.to(() => Posts(
                          posts: List.from(posts),
                          index: index,
                          userId: getIt<UserProfileManager>().user!.id,
                          source: profileController.selectedSegment.value == 0
                              ? PostSource.posts
                              : PostSource.mentions,
                          page: profileController.selectedSegment.value == 0
                              ? profileController.postsCurrentPage
                              : profileController.mentionsPostPage,
                          totalPages: profileController.totalPages));
                    }),
                    posts[index].gallery.length == 1
                        ? posts[index].gallery.first.isVideoPost() == true
                            ? const Positioned(
                                right: 5,
                                top: 5,
                                child: ThemeIconWidget(
                                  ThemeIcon.videoPost,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              )
                            : Container()
                        : const Positioned(
                            right: 5,
                            top: 5,
                            child: ThemeIconWidget(
                              ThemeIcon.multiplePosts,
                              color: Colors.white,
                              size: 30,
                            ))
                  ]),
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                ).hP16;
        });
  }
}
