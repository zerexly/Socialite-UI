import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class CommentTile extends StatefulWidget {
  final CommentModel model;

  const CommentTile({Key? key, required this.model}) : super(key: key);

  @override
  CommentTileState createState() => CommentTileState();
}

class CommentTileState extends State<CommentTile> {
  late final CommentModel model;

  @override
  void initState() {
    super.initState();
    model = widget.model;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
              child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AvatarView(
                url: model.userPicture,
                name: model.userName,
                size: 28,
              ).ripple(() {
                Get.to(() => OtherUserProfile(userId: model.userId));
              }),
              const SizedBox(width: 10),
              Flexible(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const SizedBox(height: 4),
                  Text(
                    model.userName,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        // color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w700),
                  ).ripple(() {
                    Get.to(() => OtherUserProfile(userId: model.userId));
                  }),
                  DetectableText(
                    text: model.comment,
                    detectionRegExp: RegExp(
                      "(?!\\n)(?:^|\\s)([#@]([$detectionContentLetters]+))|$urlRegexContent",
                      multiLine: true,
                    ),
                    detectedStyle: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.w700),
                    basicStyle: Theme.of(context).textTheme.bodyLarge,
                    onTap: (tappedText) {
                      commentTextTapHandler(text: tappedText);
                      // postCardController.titleTextTapped(text: tappedText,post: widget.model);
                    },
                  )
                ],
              ))
            ],
          )),
          Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(model.commentTime,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontWeight: FontWeight.w600)))
        ]);
  }

  commentTextTapHandler({required String text}) {
    if (text.startsWith('#')) {
      Get.to(() => Posts(
            hashTag: text.replaceAll('#', ''),
            source: PostSource.posts,
          ));
    } else {
      String userTag = text.replaceAll('@', '');

      ApiController()
          .findFriends(isExactMatch: 1, searchText: userTag)
          .then((response) {
        if (response.users.isNotEmpty) {
          Get.to(() => OtherUserProfile(userId: response.users.first.id));
        }
      });
    }
  }
}
