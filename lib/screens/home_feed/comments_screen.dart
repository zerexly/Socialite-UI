import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class CommentsScreen extends StatefulWidget {
  final PostModel? model;
  final int? postId;
  final VoidCallback? handler;

  const CommentsScreen({Key? key, this.model, this.postId, this.handler})
      : super(key: key);

  @override
  CommentsScreenState createState() => CommentsScreenState();
}

class CommentsScreenState extends State<CommentsScreen> {
  TextEditingController textEditingController = TextEditingController();
  final ScrollController _controller = ScrollController();
  final CommentsController commentsController = CommentsController();

  @override
  void initState() {
    super.initState();
    commentsController.getComments(widget.postId ?? widget.model!.id, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Column(
          children: <Widget>[
            const SizedBox(
              height: 50,
            ),
            backNavigationBar(context, LocalizationString.comments),
            divider(context: context).tP8,
            Flexible(
                child: GetBuilder<CommentsController>(
                    init: commentsController,
                    builder: (ctx) {
                      return ListView.separated(
                        padding:
                            const EdgeInsets.only(top: 20, left: 16, right: 16),
                        itemCount: commentsController.comments.length,
                        // reverse: true,
                        controller: _controller,
                        itemBuilder: (context, index) {
                          return CommentTile(
                              model: commentsController.comments[index]);
                        },
                        separatorBuilder: (ctx, index) {
                          return const SizedBox(
                            height: 20,
                          );
                        },
                      );
                    })),
            buildMessageTextField(),
            const SizedBox(
              height: 20,
            )
          ],
        ));
  }

  Widget buildMessageTextField() {
    return Container(
      height: 50.0,
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Container(
            child: TextField(
              controller: textEditingController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: LocalizationString.writeComment,
                hintStyle: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              textInputAction: TextInputAction.send,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.w600),
              onSubmitted: (_) {
                addNewMessage();
              },
              onTap: () {
                Timer(
                    const Duration(milliseconds: 300),
                    () => _controller
                        .jumpTo(_controller.position.maxScrollExtent));
              },
            ).hP8,
          ).borderWithRadius(context: context, value: 0.5, radius: 25)),
          SizedBox(
            width: 50.0,
            child: InkWell(
              onTap: addNewMessage,
              child: Icon(
                Icons.send,
                color: Theme.of(context).primaryColor,
              ),
            ),
          )
        ],
      ),
    );
  }

  void addNewMessage() {
    if (textEditingController.text.trim().isNotEmpty) {
      final filter = ProfanityFilter();
      bool hasProfanity = filter.hasProfanity(textEditingController.text);
      if (hasProfanity) {
        AppUtil.showToast(
            context: context,
            message: LocalizationString.notAllowedMessage,
            isSuccess: true);
        return;
      }

      commentsController.postCommentsApiCall(
          comment: textEditingController.text.trim(),
          postId: widget.postId ?? widget.model!.id);
      textEditingController.text = '';
      // widget.model?.totalComment = comments.length;

      Timer(const Duration(milliseconds: 500),
          () => _controller.jumpTo(_controller.position.maxScrollExtent));
    }
  }
}
