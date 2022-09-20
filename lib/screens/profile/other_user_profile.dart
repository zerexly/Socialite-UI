import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class OtherUserProfile extends StatefulWidget {
  final int? userId;

  // final UserModel? user;

  const OtherUserProfile({Key? key, this.userId}) : super(key: key);

  @override
  OtherUserProfileState createState() => OtherUserProfileState();
}

class OtherUserProfileState extends State<OtherUserProfile> {
  final ProfileController profileController = Get.find();
  final HighlightsController highlightsController = Get.find();

  int? userId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      profileController.clear();
      initialLoad();
    });
  }

  initialLoad() {
    PostSearchQuery query = PostSearchQuery();

    query.userId = widget.userId!;
    query.isRecent = 1;

    userId = widget.userId!;

    MentionedPostSearchQuery mentionedPostSearchQuery =
        MentionedPostSearchQuery(userId: userId!);

    profileController.setMentionedPostSearchQuery(mentionedPostSearchQuery);
    profileController.setPostSearchQuery(query);
    profileController.getOtherUserDetail(
        userId: widget.userId!, context: context);
    highlightsController.getHighlights(userId: widget.userId!);
  }

  @override
  void didUpdateWidget(covariant OtherUserProfile oldWidget) {
    super.didUpdateWidget(oldWidget);
    PostSearchQuery query = PostSearchQuery();

    query.userId = widget.userId!;
    query.isRecent = 1;

    MentionedPostSearchQuery mentionedPostSearchQuery =
        MentionedPostSearchQuery(userId: userId!);
    query.userId = userId!;
    profileController.setMentionedPostSearchQuery(mentionedPostSearchQuery);
    profileController.setPostSearchQuery(query);
  }

  @override
  void dispose() {
    profileController.clear();
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ThemeIconWidget(
                  ThemeIcon.backArrow,
                  size: 20,
                  color: Theme.of(context).iconTheme.color,
                ).ripple(() {
                  Get.back();
                }),
                Obx(() => Text(
                      profileController.user.value.userName,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.w600),
                    )),
                SizedBox(
                  height: 25,
                  width: 20,
                  child: ThemeIconWidget(
                    ThemeIcon.more,
                    color: Theme.of(context).iconTheme.color,
                    size: 20,
                  ).ripple(() {
                    openActionPopup();
                  }),
                )
              ],
            ).setPadding(left: 16, right: 16, top: 8, bottom: 16),
            divider(context: context).vP8,
            Obx(() => profileController.noDataFound.value == false
                ? Expanded(
                    child: ListView(
                      padding: const EdgeInsets.only(top: 10),
                      children: [
                        addProfileView(),
                        // const SizedBox(height: 20),
                        addHighlightsView(),
                        const SizedBox(height: 20),
                        segmentView(),
                        addPhotoGrid(),
                        const SizedBox(height: 50),
                      ],
                    ),
                  )
                : Expanded(child: noUserFound(context))),
          ],
        ));
  }

  addProfileView() {
    return GetBuilder<ProfileController>(
        init: profileController,
        builder: (ctx) {
          userId ??= profileController.user.value.id;

          return Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                UserAvatarView(
                    user: profileController.user.value,
                    size: 65,
                    onTapHandler: () {
                      //open live
                    }),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  profileController.user.value.userName,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.w800),
                ).bP4,
                profileController.user.value.country != null
                    ? Text(
                        '${profileController.user.value.country},${profileController.user.value.city}',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium,
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
                            '${profileController.user.value.totalFollower}',
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
                              isFollowersList: true));
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
                            '${profileController.user.value.totalFollowing}',
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
                              isFollowersList: false));
                        }
                      }),
                    )
                  ],
                ).hP16,
                const SizedBox(
                  height: 40,
                ),
                Row(
                  children: [
                    const Spacer(),
                    BorderButtonType1(
                        height: 30,
                        backgroundColor:
                            profileController.user.value.isFollowing == 1
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).cardColor,
                        width: MediaQuery.of(context).size.width * 0.3,
                        textStyle: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(fontWeight: FontWeight.w600),
                        text: profileController.user.value.isFollowing == 1
                            ? LocalizationString.unFollow.toUpperCase()
                            : profileController.user.value.isFollower == 1
                                ? LocalizationString.followBack.toUpperCase()
                                : LocalizationString.follow.toUpperCase(),
                        onPress: () {
                          profileController.followUnFollowUserApi(
                              context: context,
                              isFollowing:
                                  profileController.user.value.isFollowing == 1
                                      ? 0
                                      : 1);
                        }),
                    const Spacer(),
                    BorderButtonType1(
                        height: 30,
                        width: MediaQuery.of(context).size.width * 0.3,
                        textStyle: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(fontWeight: FontWeight.w600),
                        text: LocalizationString.message.toUpperCase(),
                        onPress: () {
                          Get.to(() => ChatDetail(
                                opponent: profileController.user.value,
                                chatRoom: null,
                              ));
                        }),
                    const Spacer(),
                  ],
                )
              ]).p16;
        });
  }

  addHighlightsView() {
    return GetBuilder<HighlightsController>(
      init: highlightsController,
      builder: (ctx) {
        return highlightsController.isLoading
            ? const StoryAndHighlightsShimmer().vP25
            : highlightsController.highlights.isNotEmpty
                ? HighlightsBar(
                    highlights: highlightsController.highlights,
                    addHighlightCallback: () {
                      Get.to(() => const ChooseStoryForHighlights());
                    },
                    viewHighlightCallback: (highlight) {
                      Get.to(() => HighlightViewer(highlight: highlight));
                    },
                  ).vP25
                : Container();
      },
    );
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

  void openActionPopup() {
    showModalBottomSheet(
        context: context,
        builder: (context) => Wrap(
              children: [
                ListTile(
                    title: Center(child: Text(LocalizationString.report)),
                    onTap: () async {
                      Get.back();

                      profileController.reportUser(context);
                    }),
                divider(context: context),
                ListTile(
                    title: Center(child: Text(LocalizationString.block)),
                    onTap: () async {
                      Get.back();

                      profileController.blockUser(context);
                    }),
                divider(context: context),
                ListTile(
                    title: Center(child: Text(LocalizationString.cancel)),
                    onTap: () {
                      Get.back();
                    }),
              ],
            ));
  }
}
