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

      loadProfile();
      loadNetwork();
      loadHighlights();

      PostSearchQuery query = PostSearchQuery();
      query.isMine = 1;
      query.isRecent = 1;

      MentionedPostSearchQuery mentionedPostSearchQuery =
          MentionedPostSearchQuery(
              userId: getIt<UserProfileManager>().user!.id);

      profileController.setMentionedPostSearchQuery(mentionedPostSearchQuery);
      profileController.setPostSearchQuery(query);
    });
  }

  @override
  void didUpdateWidget(covariant MyProfile oldWidget) {
    super.didUpdateWidget(oldWidget);
    PostSearchQuery query = PostSearchQuery();
    query.isMine = 1;
    query.isRecent = 1;

    MentionedPostSearchQuery mentionedPostSearchQuery =
        MentionedPostSearchQuery(userId: getIt<UserProfileManager>().user!.id);
    query.userId = getIt<UserProfileManager>().user!.id;
    profileController.setMentionedPostSearchQuery(mentionedPostSearchQuery);
    profileController.setPostSearchQuery(query);
  }

  @override
  void dispose() {
    super.dispose();
  }

  loadProfile() {
    profileController.getUserProfile();
  }

  loadNetwork() {
    profileController.getFollowers();
    profileController.getFollowingUsers();
  }

  loadHighlights() {
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
                title: LocalizationString.profile,
                icon: ThemeIcon.setting,
                completion: () {
                  Get.to(() => const Settings());
                }),
            divider(context: context).vP8,
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(top: 10),
                children: [
                  addProfileView(),
                  const SizedBox(height: 20),
                  addHighlightsView(),
                  const SizedBox(height: 10),
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
          return Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                UserAvatarView(
                    user: profileController.user.value,
                    size: 65,
                    onTapHandler: () {}),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  profileController.user.value.userName,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.w600),
                ).bP4,
                profileController.user.value.country != null
                    ? Text(
                        '${profileController.user.value.country}, ${profileController.user.value.city}',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Theme.of(context).primaryColor),
                      )
                    : Container(),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 80,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            profileController.user.value.totalPost.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(fontWeight: FontWeight.w600),
                          ).bP16,
                          Text(
                            LocalizationString.posts,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 80,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '${profileController.followers.length}',
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(fontWeight: FontWeight.w600),
                          ).bP16,
                          Text(
                            LocalizationString.followers,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ).ripple(() {
                        List<UserModel> followers = profileController.followers;

                        if (followers.isNotEmpty) {
                          Get.to(() => const FollowerFollowingList(
                                  isFollowersList: true))!
                              .then((value) {
                            loadNetwork();
                          });
                        }
                      }),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 80,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '${profileController.following.length}',
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(fontWeight: FontWeight.w600),
                          ).bP16,
                          Text(
                            LocalizationString.following,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ).ripple(() {
                        List<UserModel> following = profileController.following;

                        if (following.isNotEmpty) {
                          Get.to(() => const FollowerFollowingList(
                                  isFollowersList: false))!
                              .then((value) {
                            loadNetwork();
                          });
                        }
                      }),
                    )
                  ],
                ).hP16,
                const SizedBox(
                  height: 20,
                ),
                BorderButtonType1(
                    height: 30,
                    textStyle: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.w600),
                    text: LocalizationString.editProfile,
                    onPress: () {
                      Get.to(() => const UpdateProfile())!.then((value) {
                        loadProfile();
                      });
                    })
              ]).p16;
        });
  }

  Widget segmentView() {
    return HorizontalSegmentBar(
        textStyle: Theme.of(context).textTheme.titleMedium,
        selectedTextStyle: Theme.of(context)
            .textTheme
            .titleMedium!
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
                      loadHighlights();
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
                  profileController.getPosts();
                }
              } else {
                if (!profileController.mentionsPostsIsLoading) {
                  profileController.getMyMentions();
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
                            AppUtil.addProgressIndicator(context),
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
                          ));
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
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                ).hP16;
        });
  }
}
