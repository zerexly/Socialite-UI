import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class PostController extends GetxController {
  RxList<PostModel> posts = <PostModel>[].obs;
  RxList<PostModel> mentions = <PostModel>[].obs;

  bool isLoadingPosts = false;
  int postsCurrentPage = 1;
  bool canLoadMorePosts = true;

  int mentionsPostPage = 1;
  bool canLoadMoreMentionsPosts = true;
  bool mentionsPostsIsLoading = false;

  PostSearchQuery? postSearchQuery;

  MentionedPostSearchQuery? mentionedPostSearchQuery;

  clearPosts() {
    isLoadingPosts = false;
    postsCurrentPage = 1;
    canLoadMorePosts = true;

    mentionsPostPage = 1;
    canLoadMoreMentionsPosts = true;
    mentionsPostsIsLoading = false;

    posts.value = [];
    mentions.value = [];

    update();
  }

  addPosts(List<PostModel> postsList) {
    posts.addAll(postsList);
    update();
  }

  setPostSearchQuery(PostSearchQuery query) {
    if (query != postSearchQuery) {
      clearPosts();
    }
    update();
    postSearchQuery = query;
    getPosts();
  }

  setMentionedPostSearchQuery(MentionedPostSearchQuery query) {
    mentionedPostSearchQuery = query;
    getMyMentions();
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

  void getMyMentions() {
    if (canLoadMoreMentionsPosts) {
      AppUtil.checkInternet().then((value) {
        if (value) {
          mentionsPostsIsLoading = true;
          ApiController()
              .getMyMentions(userId: mentionedPostSearchQuery!.userId)
              .then((response) async {
            mentionsPostsIsLoading = false;

            mentions.addAll(
                response.success ? response.posts.reversed.toList() : []);

            if (response.posts.length == response.metaData?.perPage) {
              mentionsPostPage += 1;
              canLoadMoreMentionsPosts = true;
            } else {
              canLoadMoreMentionsPosts = false;
            }
            update();
          });
        }
      });
    }
  }

  void reportPost(int postId,BuildContext context) {
    AppUtil.checkInternet().then((value) async {
      if (value) {
        ApiController().reportPost(postId).then((response) async {});
      } else {
        AppUtil.showToast(context:context,
            message: LocalizationString.noInternet, isSuccess: true);
      }
    });
  }

  void likeUnlikePost(PostModel post, BuildContext context) {
    post.isLike = !post.isLike;
    post.totalLike = post.isLike ? (post.totalLike) + 1 : (post.totalLike) - 1;
    AppUtil.checkInternet().then((value) async {
      if (value) {
        ApiController()
            .likeUnlike(post.isLike, post.id)
            .then((response) async {});
      } else {
        AppUtil.showToast(context:context,
            message: LocalizationString.noInternet, isSuccess: true);
      }
    });

    posts.refresh();
    update();
  }

  postTextTapHandler({required PostModel post, required String text}) {
    if (text.startsWith('#')) {
      PostSearchQuery query = PostSearchQuery();
      query.hashTag = text.replaceAll('#', '');
      setPostSearchQuery(query);

      // Get.to(() => Posts(
      //     hashTag: text.replaceAll('#', ''), source: PostSource.posts))!
      //     .then((value) {
        getPosts();
      // });
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
        });
      }
      else{
        // print('not found');
      }
    }
  }
}
