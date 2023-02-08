import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class Posts extends StatefulWidget {
  final String? hashTag;
  final int? userId;
  final int? locationId;
  final List<PostModel>? posts;
  final int? index;
  final PostSource? source;
  final int? page;
  final int? totalPages;

  const Posts(
      {Key? key,
      this.page,
      this.totalPages,
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
  final PostController _postController = Get.find();
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _postController.addPosts(
          widget.posts ?? [], widget.page, widget.totalPages);

      loadData();
      if (widget.index != null) {
        Future.delayed(const Duration(seconds: 1), () {
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
      _postController.setPostSearchQuery(query);
    }
    if (widget.hashTag != null) {
      PostSearchQuery query = PostSearchQuery();
      query.hashTag = widget.hashTag!;
      _postController.setPostSearchQuery(query);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose

    _postController.clearPosts();
    super.dispose();
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
                // Image.asset(
                //   'assets/logo.png',
                //   width: 80,
                //   height: 25,
                // ),
                const Spacer(),
                ThemeIconWidget(
                  ThemeIcon.notification,
                  color: Theme.of(context).iconTheme.color,
                  size: 25,
                ).ripple(() {
                  Get.to(() => const NotificationsScreen());
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
          if (!_postController.isLoadingPosts) {
            _postController.getPosts();
          }
        } else {
          if (!_postController.mentionsPostsIsLoading) {
            _postController.getMyMentions();
          }
        }
      }
    });

    return Obx(() {
      List<PostModel> posts = widget.source == PostSource.posts
          ? _postController.posts
          : _postController.mentions;

      return _postController.isLoadingPosts
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
                              _postController.postTextTapHandler(
                                  post: model, text: text);
                            },
                            // mediaTapHandler: (post){
                            //   Get.to(()=> PostMediaFullScreen(post: post));
                            // },
                            // likeTapHandler: () {
                            //   postController.likeUnlikePost(model, context);
                            // },
                            removePostHandler: () {
                              _postController.removePostFromList(model);
                            },
                            blockUserHandler: () {
                              _postController.removeUsersAllPostFromList(model);
                            }),
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
