import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({Key? key}) : super(key: key);

  @override
  HomeFeedState createState() => HomeFeedState();
}

class HomeFeedState extends State<HomeFeedScreen> {
  final HomeController homeController = Get.find();
  final AgoraLiveController agoraLiveController = Get.find();

  final List<String> options = [
    LocalizationString.story,
    LocalizationString.highlights,
    LocalizationString.live
  ];
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
    });
  }

  @override
  void dispose() {
    super.dispose();
    homeController.clear();
  }

  void loadData() {
    if (getIt<UserProfileManager>().user != null) {
      PostSearchQuery query = PostSearchQuery();
      query.isFollowing = 1;
      query.isRecent = 1;
      homeController.setPostSearchQuery(query);

      // postController.getPosts();
      homeController.getStories();
    }
  }

  @override
  void didUpdateWidget(covariant HomeFeedScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 55,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                        height: 25,
                        width: 25,
                        color: Theme.of(context).primaryColor,
                        child: const ThemeIconWidget(
                          ThemeIcon.camera,
                          color: Colors.white,
                          size: 15,
                        )).circular,
                    const SizedBox(width: 5),
                    Text(
                      AppConfigConstants.appName,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.w900,
                          color: Theme.of(context).primaryColor),
                    )
                  ],
                ),
                const Spacer(),
                DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    customButton: Container(
                      color: Theme.of(context).backgroundColor,
                      height: 25,
                      width: 25,
                      child: const ThemeIconWidget(
                        ThemeIcon.plus,
                        // color: Theme.of(context).primaryColor,
                        size: 25,
                      ),
                    ),
                    items: options
                        .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                            ))
                        .toList(),
                    value: selectedValue,
                    onChanged: (value) {
                      homeController.contentOptionSelected(value as String);
                    },
                    itemPadding: const EdgeInsets.only(left: 16, right: 16),
                    dropdownWidth: 150,
                    dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
                    dropdownElevation: 8,
                    offset: const Offset(0, 8),
                    dropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Container(
                  color: Theme.of(context).backgroundColor,
                  height: 25,
                  width: 25,
                  child: const ThemeIconWidget(
                    ThemeIcon.chat,
                    // color: Theme.of(context).primaryColor,
                    size: 17,
                  ),
                ).ripple(() {
                  Get.to(() => const ChatHistory());
                }),
                const SizedBox(width: 15),
                const ThemeIconWidget(
                  ThemeIcon.mobile,
                  // color: Theme.of(context).primaryColor,
                  size: 23,
                ).ripple(() {
                  Get.to(() => const CallHistory());
                }),
                const SizedBox(width: 15),
                const ThemeIconWidget(
                  ThemeIcon.notification,
                  // color: Theme.of(context).primaryColor,
                  size: 27,
                ).ripple(() {
                  Get.to(() => const NotificationsScreen1());
                }),
              ],
            ).hp(20),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverList(
                      delegate: SliverChildBuilderDelegate(
                          (ctx, index) => Column(
                                children: [
                                  const SizedBox(height: 20),
                                  storiesView()
                                      .shadow(context: context, radius: 25)
                                      .hP16,
                                  postsView(),
                                  const SizedBox(
                                    height: 50,
                                  )
                                ],
                              ),
                          childCount: 1))
                ],
              ),
            ),
          ],
        ));
  }

  Widget storiesView() {
    return SizedBox(
      height: 110,
      child: GetBuilder<HomeController>(
          init: homeController,
          builder: (ctx) {
            return StoryUpdatesBar(
              stories: homeController.stories,
              liveUsers: homeController.liveUsers,
              addStoryCallback: () {
                Get.to(() => const ChooseMediaForStory());
              },
              viewStoryCallback: (story) {
                Get.to(() => StoryViewer(story: story));
              },
              joinLiveUserCallback: (user) {
                Live live = Live(
                    channelName: user.liveCallDetail!.channelName,
                    isHosting: false,
                    host: user,
                    token: user.liveCallDetail!.token,
                    liveId: user.liveCallDetail!.id);
                agoraLiveController.joinAsAudience(
                  live: live,
                );
              },
            ).vP16;
          }),
    );
  }

  // Future<void> imagesSelectedForStory(SelectedImagesDetails details) async {
  //   if (details.multiSelectionMode == true) {
  //     List<GalleryMedia> medias = (details.selectedFiles ?? [])
  //         .map((e) => GalleryMedia(
  //             bytes: e.readAsBytesSync(),
  //             id: randomId(),
  //             dateCreated: DateTime.now().millisecondsSinceEpoch,
  //             mediaType: mime(e.path) == 'image' ? 1 : 2,
  //             path: ''))
  //         .toList();
  //     storyController.uploadAllPostImages(items: medias);
  //   } else {
  //     print(mime(details.selectedFile.path));
  //     GalleryMedia media = GalleryMedia(
  //         bytes: details.selectedFile.readAsBytesSync(),
  //         id: randomId(),
  //         dateCreated: DateTime.now().millisecondsSinceEpoch,
  //         mediaType: mime(details.selectedFile.path) == 'image' ? 1 : 2,
  //         path: '');
  //     storyController.uploadAllPostImages(items: [media]);
  //   }
  // }

  postsView() {
    ScrollController scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        if (!homeController.isLoadingPosts) {
          homeController.getPosts();
        }
      }
    });

    return homeController.isLoadingPosts == true
        ? SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: const HomeScreenShimmer())
        : GetBuilder<HomeController>(
            init: homeController,
            builder: (ctx) {
              return homeController.posts.isNotEmpty
                  ? SizedBox(
                      height: homeController.posts.length * 540,
                      child: ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: scrollController,
                          padding: const EdgeInsets.only(top: 20),
                          itemCount: homeController.posts.length,
                          itemBuilder: (context, index) {
                            PostModel model = homeController.posts[index];
                            return PostCard(
                              model: model,
                              textTapHandler: (text) {
                                homeController.postTextTapHandler(
                                    post: model, text: text);
                              },
                              likeTapHandler: () {
                                homeController.likeUnlikePost(model, context);
                              },
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 25,
                            );
                          }),
                    )
                  : SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: emptyPost(
                          context: context,
                          title: LocalizationString.noPostFound,
                          subTitle:
                              LocalizationString.followFriendsToSeeUpdates),
                    );
            },
          );
  }
}
