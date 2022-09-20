import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final AgoraLiveController agoraLiveController = Get.find();
  List<UserModel> followingUsers = [];
  RxList<PostModel> posts = <PostModel>[].obs;
  RxList<StoryModel> stories = <StoryModel>[].obs;
  RxList<UserModel> liveUsers = <UserModel>[].obs;

  bool isLoading = false;

  RxInt currentVisibleVideoId = 0.obs;
  Map<int, double> mediaVisibilityInfo = {};
  PostSearchQuery? postSearchQuery;

  bool isLoadingPosts = false;
  int postsCurrentPage = 1;
  bool canLoadMorePosts = true;
  bool isLoadingStories = false;

  int currentPage = 1;
  bool canLoadMore = true;

  clear() {
    currentPage = 0;
    canLoadMore = false;
    stories.clear();
    liveUsers.clear();
    // update();
  }

  setPostSearchQuery(PostSearchQuery query) {
    if (query != postSearchQuery) {
      clear();
    }
    update();
    postSearchQuery = query;
    getPosts();
  }

  void getPosts() async {
    if (canLoadMorePosts == true) {
      AppUtil.checkInternet().then((value) async {
        if (value) {
          isLoadingPosts = true;
          ApiController()
              .getPosts(
                  userId: postSearchQuery!.userId,
                  isPopular: postSearchQuery!.isPopular,
                  isFollowing: postSearchQuery!.isFollowing,
                  isSold: postSearchQuery!.isSold,
                  isMine: postSearchQuery!.isMine,
                  isRecent: postSearchQuery!.isRecent,
                  title: postSearchQuery!.title,
                  hashtag: postSearchQuery!.hashTag,
                  page: postsCurrentPage)
              .then((response) async {
            // posts.value = [];
            posts.addAll(response.success
                ? response.posts
                    .where((element) => element.gallery.isNotEmpty)
                    .toList()
                : []);
            posts.sort((a, b) => b.createDate!.compareTo(a.createDate!));
            isLoadingPosts = false;

            if (response.posts.length == response.metaData?.perPage) {
              postsCurrentPage += 1;
              canLoadMorePosts = true;
            } else {
              canLoadMorePosts = false;
            }
            update();
          });
        }
      });
    }
  }

  contentOptionSelected(String option) {
    if (option == 'Story') {
      Get.to(() => const ChooseMediaForStory());
    } else if (option == 'Post') {
      // Get.offAll(const DashboardScreen(
      //   selectedTab: 2,
      // ));
    } else if (option == 'Highlights') {
      Get.to(() => const ChooseStoryForHighlights());
    } else if (option == 'Live') {
      agoraLiveController.initializeLive();
    }
  }

  setCurrentVisibleVideo(
      {required PostGallery media, required double visibility}) {
    mediaVisibilityInfo[media.id] = visibility;
    double maxVisibility =
        mediaVisibilityInfo[mediaVisibilityInfo.keys.first] ?? 0;
    int maxVisibilityMediaId = mediaVisibilityInfo.keys.first;

    for (int key in mediaVisibilityInfo.keys) {
      double visibility = mediaVisibilityInfo[key] ?? 0;
      if (visibility >= maxVisibility) {
        maxVisibilityMediaId = key;
      }
    }

    if (currentVisibleVideoId.value != maxVisibilityMediaId) {
      currentVisibleVideoId.value = maxVisibilityMediaId;
      update();
    }
  }

  void getFollowingUsers() async {
    AppUtil.checkInternet().then((value) async {
      if (value) {
        isLoading = true;
        ApiController().getFollowingUsers().then((response) async {
          followingUsers = response.users;

          bool biometricAuthStatus =
              response.user?.isBioMetricLoginEnabled == 1;
          SharedPrefs().setBioMetricAuthStatus(biometricAuthStatus);
          isLoading = false;
          update();
        });
      }
    });
  }

  void reportPost(int postId, BuildContext context) {
    AppUtil.checkInternet().then((value) async {
      if (value) {
        ApiController().reportPost(postId).then((response) async {
          if (response.success == true) {
            AppUtil.showToast(context: context,
                message: LocalizationString.postReportedSuccessfully,
                isSuccess: true);
          } else {
            AppUtil.showToast(context: context,
                message: LocalizationString.errorMessage, isSuccess: true);
          }
        });
      } else {
        AppUtil.showToast(context: context,
            message: LocalizationString.noInternet, isSuccess: true);
      }
    });
  }

  void likeUnlikePost(PostModel post,BuildContext context) {
    post.isLike = !post.isLike;
    post.totalLike = post.isLike ? (post.totalLike) + 1 : (post.totalLike) - 1;
    AppUtil.checkInternet().then((value) async {
      if (value) {
        ApiController()
            .likeUnlike(post.isLike, post.id)
            .then((response) async {});
      } else {
        AppUtil.showToast(context: context,
            message: LocalizationString.noInternet, isSuccess: true);
      }
    });

    posts.refresh();
    update();
  }

  postTextTapHandler({required PostModel post, required String text}) {
    if (text.startsWith('#')) {
      Get.to(() => Posts(
              hashTag: text.replaceAll('#', ''), source: PostSource.posts))!
          .then((value) {
        getPosts();
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
          getPosts();
          getStories();
        });
      }
    }
  }

  // stories

  void getStories() async {
    stories.clear();
    AppUtil.checkInternet().then((value) async {
      if (value) {
        isLoadingStories = true;
        var responses = await Future.wait([
          getCurrentActiveStories(),
          getFollowersStories(),
          getLiveUsers()
        ]).whenComplete(() {});

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
        update();
      }
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

      isLoadingStories = false;
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
