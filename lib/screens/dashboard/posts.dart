import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class Posts extends StatefulWidget {
  final String? hashTag;
  final int? userId;
  final int? locationId;
  final List<PostModel>? posts;
  final int? index;
  final PostSource? source;

  const Posts(
      {Key? key,
      this.hashTag,
      this.userId,
      this.locationId,
      this.posts,
      this.source,
      this.index})
      : super(key: key);

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  final PostController postController = Get.find();
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  @override
  void initState() {
    super.initState();

    postController.addPosts(widget.posts ?? []);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
      if (widget.index != null) {
        Future.delayed(const Duration(milliseconds: 100), () {
          itemScrollController.jumpTo(
            index: widget.index!,
          );
        });
      }
    });
  }

  void loadData() {
    if (widget.userId != null) {
      PostSearchQuery query = PostSearchQuery();
      query.userId = widget.userId!;
      postController.setPostSearchQuery(query);
    }
    if (widget.hashTag != null) {
      PostSearchQuery query = PostSearchQuery();
      query.hashTag = widget.hashTag!;
      postController.setPostSearchQuery(query);
    }
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
                ThemeIconWidget(
                  ThemeIcon.backArrow,
                  color: Theme.of(context).iconTheme.color,
                  size: 25,
                ).ripple(() {
                  Get.back();
                }),
                const Spacer(),
                Image.asset(
                  'assets/logo.png',
                  width: 80,
                  height: 25,
                ),
                const Spacer(),
                ThemeIconWidget(
                  ThemeIcon.notification,
                  color: Theme.of(context).iconTheme.color,
                  size: 25,
                ).ripple(() {
                  Get.to(() => const NotificationsScreen1());
                }),
              ],
            ).hp(20),
            const SizedBox(
              height: 20,
            ),
            Expanded(child: postsView()),
          ],
        ));
  }

  postsView() {
    ScrollController scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        if (widget.source == PostSource.posts) {
          if (!postController.isLoadingPosts) {
            // postController.getPosts();
          }
        } else {
          if (!postController.mentionsPostsIsLoading) {
            // postController.getMyMentions();
          }
        }
      }
    });

    return GetBuilder<PostController>(
        init: postController,
        builder: (ctx) {
          List<PostModel> posts = widget.source == PostSource.posts
              ? postController.posts
              : postController.mentions;

          return postController.isLoadingPosts
              ? const HomeScreenShimmer()
              : posts.isEmpty
                  ? Center(child: Text(LocalizationString.noData))
                  : ScrollablePositionedList.builder(
                      itemScrollController: itemScrollController,
                      itemPositionsListener: itemPositionsListener,
                      padding: const EdgeInsets.only(top: 10, bottom: 50),
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        PostModel model = posts[index];
                        return Column(
                          children: [
                            PostCard(
                              model: model,
                              textTapHandler: (text) {
                                postController.postTextTapHandler(
                                    post: model, text: text);
                              },
                              likeTapHandler: () {
                                postController.likeUnlikePost(model, context);
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            )
                          ],
                        );
                      },
                    );
        });
  }
}
