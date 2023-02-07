import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

import '../settings_menu/add_relationship/view_relationships.dart';

class OtherUserProfile extends StatefulWidget {
  final int userId;

  const OtherUserProfile({Key? key, required this.userId}) : super(key: key);

  @override
  OtherUserProfileState createState() => OtherUserProfileState();
}

class OtherUserProfileState extends State<OtherUserProfile> {
  final ProfileController _profileController = Get.find();
  final HighlightsController _highlightsController = Get.find();
  final ChatDetailController _chatDetailController = Get.find();
  final SettingsController _settingsController = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _profileController.clear();
      initialLoad();
    });
  }

  initialLoad() {
    _profileController.getMyMentions(widget.userId);
    _profileController.getPosts(widget.userId);
    _profileController.getOtherUserDetail(
        userId: widget.userId, context: context);
    _highlightsController.getHighlights(userId: widget.userId);
    _profileController.getReels(getIt<UserProfileManager>().user!.id);
  }

  @override
  void didUpdateWidget(covariant OtherUserProfile oldWidget) {
    super.didUpdateWidget(oldWidget);
    initialLoad();
  }

  @override
  void dispose() {
    _profileController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Stack(
          children: [profileInfoView(), giftSendingOverlay()],
        ));
  }

  Widget profileInfoView() {
    return Column(
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
            Obx(() => _profileController.user.value != null
                ? Text(
                    _profileController.user.value!.userName,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.w600),
                  )
                : Container()),
            Obx(() => _profileController.user.value?.isMe == false
                ? SizedBox(
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
                : Container())
          ],
        ).setPadding(left: 16, right: 16, top: 8, bottom: 16),
        divider(context: context).vP8,
        Obx(() => _profileController.noDataFound.value == false
            ? Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(top: 10),
                  children: [
                    const SizedBox(height: 20),
                    addProfileView(),
                    const SizedBox(height: 10),
                    addHighlightsView(),
                    const SizedBox(height: 50),
                    segmentView(),
                    Obx(() => _profileController.selectedSegment.value == 1
                        ? addReelsGrid()
                        : addPhotoGrid()),
                    const SizedBox(height: 50),
                  ],
                ),
              )
            : Expanded(child: noUserFound(context))),
      ],
    );
  }

  Widget giftSendingOverlay() {
    return Obx(() => _profileController.sendingGift.value == null
        ? Container()
        : Positioned(
            left: 0,
            top: 0,
            right: 0,
            bottom: 0,
            child: Pulse(
              duration: const Duration(milliseconds: 500),
              child: Center(
                child: Image.network(
                  _profileController.sendingGift.value!.logo,
                  height: 80,
                  width: 80,
                  fit: BoxFit.contain,
                ),
              ),
            )));
  }

  addProfileView() {
    return GetBuilder<ProfileController>(
        init: _profileController,
        builder: (ctx) {
          return _profileController.user.value != null
              ? Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            UserAvatarView(
                                user: _profileController.user.value!,
                                size: 65,
                                onTapHandler: () {
                                  //open live
                                }),
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
                            _profileController.user.value?.country != null
                                ? Text(
                                    '${_profileController.user.value!.country},${_profileController.user.value!.city}',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  )
                                : Container(),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    statsView(),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // const Spacer(),
                        Expanded(
                          child: FilledButtonType1(
                              height: 35,
                              enabledBackgroundColor: _profileController
                                      .user.value!.isFollowing
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).primaryColor.lighten(0.1),
                              enabledTextStyle:
                                  Theme.of(context).textTheme.bodyLarge,
                              text: _profileController.user.value!.isFollowing
                                  ? LocalizationString.unFollow
                                  : _profileController.user.value!.isFollower
                                      ? LocalizationString.followBack
                                      : LocalizationString.follow.toUpperCase(),
                              onPress: () {
                                _profileController.followUnFollowUserApi(
                                    context: context,
                                    isFollowing: !_profileController
                                        .user.value!.isFollowing);
                              }),
                        ),

                        if (_settingsController.setting.value!.enableChat)
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.25,
                              child: FilledButtonType1(
                                  height: 35,
                                  enabledBackgroundColor:
                                      Theme.of(context).disabledColor,
                                  enabledTextStyle:
                                      Theme.of(context).textTheme.bodyLarge,
                                  text: LocalizationString.chat,
                                  onPress: () {
                                    EasyLoading.show(
                                        status: LocalizationString.loading);
                                    _chatDetailController.getChatRoomWithUser(
                                        userId:
                                            _profileController.user.value!.id,
                                        callback: (room) {
                                          EasyLoading.dismiss();
                                          Get.to(() => ChatDetail(
                                                chatRoom: room,
                                              ));
                                        });
                                  })).lP8,
                        if (_settingsController.setting.value!.enableGift)
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.30,
                              child: FilledButtonType1(
                                  height: 35,
                                  enabledBackgroundColor:
                                      Theme.of(context).disabledColor,
                                  enabledTextStyle:
                                      Theme.of(context).textTheme.bodyLarge,
                                  text: LocalizationString.sendGift,
                                  onPress: () {
                                    showModalBottomSheet<void>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return FractionallySizedBox(
                                              heightFactor: 0.8,
                                              child: GiftsPageView(
                                                  giftSelectedCompletion:
                                                      (gift) {
                                                Get.back();
                                                _profileController
                                                    .sendGift(gift);
                                              }));
                                        });
                                  })).lP8,


                      ],
                    ),
                  //  if (_profileController.user.value?.userSetting?[0].relationSetting == 0)
                    Container(
                      margin: const EdgeInsets.only(top: 15.0),
                      child : SizedBox(
                            width: MediaQuery.of(context).size.width * 0.40,
                            child: FilledButtonType1(
                                height: 35,
                                enabledBackgroundColor:
                                Theme.of(context).disabledColor,
                                enabledTextStyle:
                                Theme.of(context).textTheme.bodyLarge,
                                text: LocalizationString.relationship,
                                onPress: () {
                                  Get.to(() => const ViewRelationship());
                                })).lP8,
                      ),
                  ],
                ).hP16
              : Container();
        });
  }

  statsView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _profileController.user.value!.totalPost.toString(),
              style: Theme.of(context).textTheme.titleLarge,
            ).bP8,
            Text(
              LocalizationString.posts,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        // const SizedBox(
        //   width: 20,
        // ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '${_profileController.user.value!.totalFollower}',
              style: Theme.of(context).textTheme.titleLarge,
            ).bP8,
            Text(
              LocalizationString.followers,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ).ripple(() {
          if (_profileController.user.value!.totalFollower > 0) {
            Get.to(() => FollowerFollowingList(
                      isFollowersList: true,
                      userId: widget.userId,
                    ))!
                .then((value) {
              initialLoad();
            });
          }
        }),
        // const SizedBox(
        //   width: 20,
        // ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '${_profileController.user.value!.totalFollowing}',
              style: Theme.of(context).textTheme.titleLarge,
            ).bP8,
            Text(
              LocalizationString.following,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ).ripple(() {
          if (_profileController.user.value!.totalFollowing > 0) {
            Get.to(() => FollowerFollowingList(
                      isFollowersList: false,
                      userId: widget.userId,
                    ))!
                .then((value) {
              initialLoad();
            });
          }
        }),
        _profileController.user.value?.giftSummary == null
            ? Container()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    _profileController
                        .user.value!.giftSummary!.totalCoin.formatNumber
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
    ).p16.shadow(context: context);
  }

  addHighlightsView() {
    return GetBuilder<HighlightsController>(
      init: _highlightsController,
      builder: (ctx) {
        return _highlightsController.isLoading
            ? const StoryAndHighlightsShimmer().vP25
            : _highlightsController.highlights.isNotEmpty
                ? HighlightsBar(
                    highlights: _highlightsController.highlights,
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
        textStyle: Theme.of(context).textTheme.bodyLarge,
        selectedTextStyle: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(color: Theme.of(context).primaryColor)
            .copyWith(fontWeight: FontWeight.w900),
        width: MediaQuery.of(context).size.width,
        onSegmentChange: (segment) {
          _profileController.segmentChanged(segment);
        },
        hideHighlightIndicator: false,
        segments: [
          LocalizationString.posts,
          LocalizationString.reels,
          LocalizationString.mentions,
        ]);
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
                  _profileController.getPosts(widget.userId);
                }
              } else {
                if (!_profileController.mentionsPostsIsLoading) {
                  _profileController.getMyMentions(widget.userId);
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
                                source:
                                    _profileController.selectedSegment.value ==
                                            0
                                        ? PostSource.posts
                                        : PostSource.mentions,
                                page:
                                    _profileController.selectedSegment.value ==
                                            0
                                        ? _profileController.postsCurrentPage
                                        : _profileController.mentionsPostPage,
                                totalPages: _profileController.totalPages,
                              ))!
                          .then((value) {
                        initialLoad();
                      });
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

  void openActionPopup() {
    showModalBottomSheet(
        context: context,
        builder: (context) => Wrap(
              children: [
                ListTile(
                    title: Center(child: Text(LocalizationString.report)),
                    onTap: () async {
                      Get.back();

                      _profileController.reportUser(context);
                    }),
                divider(context: context),
                ListTile(
                    title: Center(child: Text(LocalizationString.block)),
                    onTap: () async {
                      Get.back();

                      _profileController.blockUser(context);
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
