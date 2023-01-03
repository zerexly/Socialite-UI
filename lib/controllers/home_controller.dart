import 'package:foap/helper/common_import.dart';
import 'package:foap/screens/podcast/podcast_list_dashboard.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final SettingsController _settingsController = Get.find();

  RxList<PostModel> posts = <PostModel>[].obs;
  RxList<StoryModel> stories = <StoryModel>[].obs;
  RxList<UserModel> liveUsers = <UserModel>[].obs;

  RxList<BannerAd> bannerAds = <BannerAd>[].obs;

  RxInt currentVisibleVideoId = 0.obs;
  Map<int, double> _mediaVisibilityInfo = {};
  PostSearchQuery postSearchQuery = PostSearchQuery();

  RxBool isRefreshingPosts = false.obs;
  RxBool isRefreshingStories = false.obs;

  RxInt categoryIndex = 0.obs;

  int _postsCurrentPage = 1;
  bool _canLoadMorePosts = true;

  RxBool openQuickLinks = false.obs;

  RxList<QuickLink> quickLinks = <QuickLink>[].obs;

  clear() {
    stories.clear();
    liveUsers.clear();
  }

  clearPosts() {
    _postsCurrentPage = 1;
    _canLoadMorePosts = true;
    posts.clear();
  }

  quickLinkSwitchToggle() {
    openQuickLinks.value = !openQuickLinks.value;
  }

  closeQuickLinks() {
    openQuickLinks.value = false;
  }

  loadQuickLinksAccordingToSettings() {
    quickLinks.clear();
    if (_settingsController.setting.value!.enableStories) {
      quickLinks.add(QuickLink(
          icon: 'assets/stories.png',
          heading: LocalizationString.story,
          subHeading: LocalizationString.story,
          linkType: QuickLinkType.story));
    }
    if (_settingsController.setting.value!.enableHighlights) {
      quickLinks.add(QuickLink(
          icon: 'assets/highlights.png',
          heading: LocalizationString.highlights,
          subHeading: LocalizationString.highlights,
          linkType: QuickLinkType.highlights));
    }
    if (_settingsController.setting.value!.enableLive) {
      quickLinks.add(QuickLink(
          icon: 'assets/live.png',
          heading: LocalizationString.goLive,
          subHeading: LocalizationString.goLive,
          linkType: QuickLinkType.goLive));
    }
    if (_settingsController.setting.value!.enableCompetitions) {
      quickLinks.add(QuickLink(
          icon: 'assets/competitions.png',
          heading: LocalizationString.competition,
          subHeading: LocalizationString.joinCompetitionsToEarn,
          linkType: QuickLinkType.competition));
    }
    if (_settingsController.setting.value!.enableClubs) {
      quickLinks.add(QuickLink(
          icon: 'assets/club_colored.png',
          heading: LocalizationString.clubs,
          subHeading: LocalizationString.placeForPeopleOfCommonInterest,
          linkType: QuickLinkType.clubs));
    }
    if (_settingsController.setting.value!.enableEvents) {
      quickLinks.add(QuickLink(
          icon: 'assets/events.png',
          heading: LocalizationString.events,
          subHeading: '',
          linkType: QuickLinkType.event));
    }
    if (_settingsController.setting.value!.enableStrangerChat) {
      quickLinks.add(QuickLink(
          icon: 'assets/chat_colored.png',
          heading: LocalizationString.strangerChat,
          subHeading: LocalizationString.haveFunByRandomChatting,
          linkType: QuickLinkType.randomChat));
    }
    // if (_settingsController.setting.value!.enableCompetitions) {
    //   quickLinks.add(QuickLink(
    //       icon: 'assets/competitions.png',
    //       heading: LocalizationString.competition,
    //       subHeading: LocalizationString.joinCompetitionsToEarn,
    //       linkType: QuickLinkType.competition));
    // }
    if (_settingsController.setting.value!.enableReel) {
      quickLinks.add(QuickLink(
          icon: 'assets/reel.png',
          heading: LocalizationString.reel,
          subHeading: LocalizationString.reel,
          linkType: QuickLinkType.reel));
    }
    if (_settingsController.setting.value!.enableWatchTv) {
      quickLinks.add(QuickLink(
          icon: 'assets/television.png',
          heading: LocalizationString.tvs,
          subHeading: LocalizationString.tvs,
          linkType: QuickLinkType.tv));
    }
    if (_settingsController.setting.value!.enablePodcasts) {
      quickLinks.add(QuickLink(
          icon: 'assets/podcast.png',
          heading: LocalizationString.podcast,
          subHeading: LocalizationString.podcast,
          linkType: QuickLinkType.podcast));
    }
  }

  categoryIndexChanged({required int index, required VoidCallback callback}) {
    if (index != categoryIndex.value) {
      categoryIndex.value = index;
      clearPosts();
      postSearchQuery = PostSearchQuery();

      if (index == 1) {
        postSearchQuery.isFollowing = 1;
        postSearchQuery.isRecent = 1;
      }
      // else if (index == 2) {
      //   postSearchQuery.isPopular = 1;
      // }
      else if (index == 2) {
        postSearchQuery.isRecent = 1;
      } else if (index == 3) {
        postSearchQuery.isMine = 1;
        postSearchQuery.isRecent = 1;
      } else {
        postSearchQuery.isRecent = 1;
      }

      getPosts(isRecent: false, callback: callback);
    }
  }

  removePostFromList(PostModel post) {
    posts.removeWhere((element) => element.id == post.id);
    posts.refresh();
  }

  void addNewPost(PostModel post) {
    posts.insert(0, post);
    posts.refresh();
  }

  void getPosts(
      {required bool? isRecent, required VoidCallback callback}) async {
    if (_canLoadMorePosts == true) {
      // for (int i = 0; i < 5; i++) {
      //   BannerAdsHelper().loadBannerAds((ad) {
      //     bannerAds.add(ad);
      //     bannerAds.refresh();
      //   });
      // }

      if (isRecent == true) {
        postSearchQuery.isRecent = 1;
      }

      if (_postsCurrentPage == 1) {
        isRefreshingPosts.value = true;
      }

      AppUtil.checkInternet().then((value) async {
        if (value) {
          ApiController()
              .getPosts(
              userId: postSearchQuery.userId,
              isPopular: postSearchQuery.isPopular,
              isFollowing: postSearchQuery.isFollowing,
              isSold: postSearchQuery.isSold,
              isMine: postSearchQuery.isMine,
              isRecent: postSearchQuery.isRecent,
              title: postSearchQuery.title,
              hashtag: postSearchQuery.hashTag,
              clubId: postSearchQuery.clubId,
              page: _postsCurrentPage)
              .then((response) async {
            posts.addAll(response.success
                ? response.posts
                .where((element) => element.gallery.isNotEmpty)
                .toList()
                : []);
            posts.sort((a, b) => b.createDate!.compareTo(a.createDate!));
            isRefreshingPosts.value = false;

            if (_postsCurrentPage >= response.metaData!.pageCount) {
              _canLoadMorePosts = false;
            } else {
              _canLoadMorePosts = true;
            }
            _postsCurrentPage += 1;

            callback();
          });
        }
      });
    }
  }

  contentOptionSelected(String option, BuildContext context) {
    if (option == LocalizationString.story) {
      Get.to(() => const ChooseMediaForStory());
    } else if (option == LocalizationString.post) {
      // Get.offAll(const DashboardScreen(
      //   selectedTab: 2,
      // ));
    } else if (option == LocalizationString.highlights) {
      Get.to(() => const ChooseStoryForHighlights());
    } else if (option == LocalizationString.goLive) {
      Get.to(() => const CheckingLiveFeasibility());
    } else if (option == LocalizationString.competition) {
      Get.to(() => const CompetitionsScreen());
    } else if (option == LocalizationString.liveNow) {
      Get.to(() => const RandomLiveListing());
    } else if (option == LocalizationString.liveTv) {
      Get.to(() => const TvListDashboard());
      // Get.to(() => const LiveTVStreaming());

    } else if (option == LocalizationString.podcast) {
      Get.to(() => const PodcastListDashboard());

    } else if (option == LocalizationString.reel) {
      Get.to(() => const CreateReelScreen());
      // Get.to(() => const LiveTVStreaming());
    }
  }

  setCurrentVisibleVideo(
      {required PostGallery media, required double visibility}) {
    // print(visibility);
    if (visibility < 20) {
      currentVisibleVideoId.value = -1;
    }
    _mediaVisibilityInfo[media.id] = visibility;
    double maxVisibility =
        _mediaVisibilityInfo[_mediaVisibilityInfo.keys.first] ?? 0;
    int maxVisibilityMediaId = _mediaVisibilityInfo.keys.first;

    for (int key in _mediaVisibilityInfo.keys) {
      double visibility = _mediaVisibilityInfo[key] ?? 0;
      if (visibility >= maxVisibility) {
        maxVisibilityMediaId = key;
      }
    }

    if (currentVisibleVideoId.value != maxVisibilityMediaId &&
        visibility > 80) {
      currentVisibleVideoId.value = maxVisibilityMediaId;
      // update();
    }
  }

  void reportPost(int postId, BuildContext context) {
    AppUtil.checkInternet().then((value) async {
      if (value) {
        ApiController().reportPost(postId).then((response) async {
          if (response.success == true) {
            AppUtil.showToast(
                context: context,
                message: LocalizationString.postReportedSuccessfully,
                isSuccess: true);
          } else {
            AppUtil.showToast(
                context: context,
                message: LocalizationString.errorMessage,
                isSuccess: true);
          }
        });
      } else {
        AppUtil.showToast(
            context: context,
            message: LocalizationString.noInternet,
            isSuccess: true);
      }
    });
  }

  // void likeUnlikePost(PostModel post, BuildContext context) {
  //   post.isLike = !post.isLike;
  //   post.totalLike = post.isLike ? (post.totalLike) + 1 : (post.totalLike) - 1;
  //   AppUtil.checkInternet().then((value) async {
  //     if (value) {
  //       ApiController()
  //           .likeUnlike(post.isLike, post.id)
  //           .then((response) async {});
  //     } else {
  //       AppUtil.showToast(
  //           context: context,
  //           message: LocalizationString.noInternet,
  //           isSuccess: true);
  //     }
  //   });
  //
  //   posts.refresh();
  //   update();
  // }

  postTextTapHandler({required PostModel post, required String text}) {
    if (text.startsWith('#')) {
      Get.to(() =>
          Posts(
            hashTag: text.replaceAll('#', ''),
            source: PostSource.posts,
          ))!
          .then((value) {
        getPosts(isRecent: false, callback: () {});
        getStories();
      });
    } else {
      String userTag = text.replaceAll('@', '');
      if (post.mentionedUsers
          .where((element) => element.userName == userTag)
          .isNotEmpty) {
        int mentionedUserId = post.mentionedUsers
            .where((element) => element.userName == userTag)
            .first
            .id;
        Get.to(() => OtherUserProfile(userId: mentionedUserId))!.then((value) {
          getPosts(isRecent: false, callback: () {});
          getStories();
        });
      }
    }
  }

// stories

  void getStories() async {
    isRefreshingStories.value = true;
    update();

    AppUtil.checkInternet().then((value) async {
      if (value) {
        var responses = await Future.wait([
          getCurrentActiveStories(),
          getFollowersStories(),
          getLiveUsers()
        ]).whenComplete(() {});
        stories.clear();

        StoryModel story = StoryModel(
            id: 1,
            name: '',
            userName: getIt<UserProfileManager>().user!.userName,
            email: '',
            image: getIt<UserProfileManager>().user!.picture,
            media: responses[0] as List<StoryMediaModel>);

        stories.add(story);
        stories.addAll(responses[1] as List<StoryModel>);
        liveUsers.value = responses[2] as List<UserModel>;
      }

      isRefreshingStories.value = false;
      update();
    });
  }

  Future<List<UserModel>> getLiveUsers() async {
    List<UserModel> currentLiveUsers = [];
    await AppUtil.checkInternet().then((value) async {
      if (value) {
        await ApiController().getCurrentLiveUsers().then((response) async {
          currentLiveUsers = response.liveUsers;
        });
      }
    });
    return currentLiveUsers;
  }

  Future<List<StoryModel>> getFollowersStories() async {
    List<StoryModel> followersStories = [];
    List<StoryModel> viewedAllStories = [];
    List<StoryModel> notViewedStories = [];

    List<int> viewedStoryIds = await getIt<DBManager>().getAllViewedStories();

    await ApiController().getStories().then((response) async {
      for (var story in response.stories) {
        var allMedias = story.media;
        var notViewedStoryMedias = allMedias
            .where((element) => viewedStoryIds.contains(element.id) == false);

        if (notViewedStoryMedias.isEmpty) {
          story.isViewed = true;
          viewedAllStories.add(story);
        } else {
          notViewedStories.add(story);
        }
      }
    });

    followersStories.addAll(notViewedStories);
    followersStories.addAll(viewedAllStories);

    return followersStories;
  }

  Future<List<StoryMediaModel>> getCurrentActiveStories() async {
    List<StoryMediaModel> myActiveStories = [];

    await ApiController().getCurrentActiveStories().then((response) async {
      myActiveStories = response.myActiveStories;
      update();
    });

    return myActiveStories;
  }

  liveUsersUpdated() {
    getStories();
  }
}
