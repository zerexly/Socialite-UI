import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class MyProfile extends StatefulWidget {
  final bool showBack;

  const MyProfile({Key? key, required this.showBack}) : super(key: key);

  @override
  MyProfileState createState() => MyProfileState();
}

class MyProfileState extends State<MyProfile> {
  final ProfileController _profileController = Get.find();
  final HighlightsController _highlightsController = Get.find();
  final SettingsController _settingsController = Get.find();

  @override
  void initState() {
    super.initState();
    initialLoad();
  }

  initialLoad() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _profileController.clear();
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
    _profileController.clear();
    super.dispose();
  }

  loadData() {
    _profileController.getMyProfile();
    _profileController.getMyMentions(getIt<UserProfileManager>().user!.id);
    _profileController.getPosts(getIt<UserProfileManager>().user!.id);
    _profileController.getReels(getIt<UserProfileManager>().user!.id);

    _highlightsController.getHighlights(
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
            widget.showBack == true
                ? backNavigationBarWithIcon(
                    context: context,
                    title: _profileController.user.value?.userName ??
                        LocalizationString.loading,
                    icon: ThemeIcon.notification,
                    iconBtnClicked: () {
                      Get.to(() => const NotificationsScreen());
                    })
                : titleNavigationBarWithIcon(
                    context: context,
                    title: _profileController.user.value?.userName ??
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
                  if (_settingsController.setting.value!.enableHighlights)
                    const SizedBox(height: 20),
                  if (_settingsController.setting.value!.enableHighlights)
                    addHighlightsView(),
                  const SizedBox(height: 40),
                  segmentView(),
                  Obx(() => _profileController.selectedSegment.value == 1
                      ? addReelsGrid()
                      : addPhotoGrid()),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ));
  }

  addProfileView() {
    return GetBuilder<ProfileController>(
        init: _profileController,
        builder: (ctx) {
          return _profileController.user.value != null
              ? Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                      UserAvatarView(
                          user: _profileController.user.value!,
                          size: 65,
                          onTapHandler: () {}),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _profileController.user.value!.userName,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          if (_profileController.user.value!.isVerified)
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
                      if (_profileController
                              .user.value!.profileCategoryTypeId !=
                          0)
                        Text(
                          _profileController
                              .user.value!.profileCategoryTypeName,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.w400),
                        ).bP4,
                      _profileController.user.value!.country != null
                          ? Text(
                              '${_profileController.user.value!.country}, ${_profileController.user.value!.city}',
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
                      Container(
                        color: Theme.of(context).cardColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  _profileController.user.value!.totalPost
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
                                  '${_profileController.user.value!.totalFollower}',
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
                              if (_profileController.user.value!.totalFollower >
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
                                  '${_profileController.user.value!.totalFollowing}',
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
                              if (_profileController.user.value!.totalFollowing >
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
                                  _profileController.user.value!.giftSummary!
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
                        ).p16,
                      ).round(15),
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
          _profileController.segmentChanged(segment);
        },
        segments: [
          LocalizationString.posts,
          LocalizationString.reels,
          LocalizationString.mentions,
        ]);
  }

  addHighlightsView() {
    return GetBuilder<HighlightsController>(
        init: _highlightsController,
        builder: (ctx) {
          return _highlightsController.isLoading == true
              ? const StoryAndHighlightsShimmer()
              : HighlightsBar(
                  highlights: _highlightsController.highlights,
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
        init: _profileController,
        builder: (ctx) {
          ScrollController scrollController = ScrollController();
          scrollController.addListener(() {
            if (scrollController.position.maxScrollExtent ==
                scrollController.position.pixels) {
              if (_profileController.selectedSegment.value == 0) {
                if (!_profileController.isLoadingPosts) {
                  _profileController
                      .getPosts(getIt<UserProfileManager>().user!.id);
                }
              } else {
                if (!_profileController.mentionsPostsIsLoading) {
                  _profileController
                      .getMyMentions(getIt<UserProfileManager>().user!.id);
                }
              }
            }
          });

          List<PostModel> posts = _profileController.selectedSegment.value == 0
              ? _profileController.posts
              : _profileController.mentions;

          return _profileController.isLoadingPosts
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
                        imageUrl: posts[index].gallery.first.thumbnail,
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
                          source: _profileController.selectedSegment.value == 0
                              ? PostSource.posts
                              : PostSource.mentions,
                          page: _profileController.selectedSegment.value == 0
                              ? _profileController.postsCurrentPage
                              : _profileController.mentionsPostPage,
                          totalPages: _profileController.totalPages));
                    }),
                    posts[index].gallery.length == 1
                        ? posts[index].gallery.first.isVideoPost == true
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

  addReelsGrid() {
    return GetBuilder<ProfileController>(
        init: _profileController,
        builder: (ctx) {
          ScrollController scrollController = ScrollController();
          scrollController.addListener(() {
            if (scrollController.position.maxScrollExtent ==
                scrollController.position.pixels) {
              if (!_profileController.isLoadingReels) {
                _profileController
                    .getReels(getIt<UserProfileManager>().user!.id);
              }
            }
          });

          List<PostModel> posts = _profileController.reels;

          return _profileController.isLoadingReels
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
                      aspectRatio: 0.7,
                      child: CachedNetworkImage(
                        imageUrl: posts[index].gallery.first.thumbnail,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            AppUtil.addProgressIndicator(context, 100),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.error,
                        ),
                      ).round(10),
                    ).ripple(() {
                      Get.to(() => ReelsList(
                            reels: List.from(posts),
                            index: index,
                            userId: getIt<UserProfileManager>().user!.id,
                            page: _profileController.reelsCurrentPage,
                          ));
                    }),
                    const Positioned(
                      right: 5,
                      top: 5,
                      child: ThemeIconWidget(
                        ThemeIcon.videoPost,
                        size: 30,
                        color: Colors.white,
                      ),
                    )
                  ]),
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                ).hP16;
        });
  }
}
