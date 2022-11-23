import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class SinglePostDetail extends StatefulWidget {
  final int postId;

  const SinglePostDetail({Key? key, required this.postId}) : super(key: key);

  @override
  State<SinglePostDetail> createState() => _SinglePostDetailState();
}

class _SinglePostDetailState extends State<SinglePostDetail> {
  final SinglePostDetailController singlePostDetailController = Get.find();

  @override
  void initState() {
    singlePostDetailController.getPostDetail(widget.postId);
    super.initState();
  }

  @override
  void dispose() {
    singlePostDetailController.clear();
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
          backNavigationBar(context: context, title: LocalizationString.post),
          divider(context: context).tP8,
          const SizedBox(
            height: 20,
          ),
          GetBuilder<SinglePostDetailController>(
              init: singlePostDetailController,
              builder: (ctx) {
                return singlePostDetailController.post.value == null &&
                        singlePostDetailController.isLoading == false
                    ? Center(
                        child: Text(
                          LocalizationString.postDeleted,
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: Theme.of(context).primaryColor),
                        ),
                      )
                    : singlePostDetailController.isLoading == false
                        ? PostCard(
                            model: singlePostDetailController.post.value!,
                            textTapHandler: (text) {},
                            // likeTapHandler: () {
                            //   singlePostDetailController
                            //       .likeUnlikePost(context);
                            // },
                            removePostHandler: () {
                              Get.back();
                            },
                            // mediaTapHandler: (post) {
                            //   Get.to(() => PostMediaFullScreen(post: post));
                            // },
                          )
                        : Container();
              }),
        ],
      ),
    );
  }
}
