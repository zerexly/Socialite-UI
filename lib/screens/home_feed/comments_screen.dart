import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class CommentsScreen extends StatefulWidget {
  final PostModel? model;
  final int? postId;
  final bool? isPopup;
  final VoidCallback? handler;

  const CommentsScreen(
      {Key? key, this.model, this.postId, this.handler, this.isPopup})
      : super(key: key);

  @override
  CommentsScreenState createState() => CommentsScreenState();
}

class CommentsScreenState extends State<CommentsScreen> {
  TextEditingController commentInputField = TextEditingController();
  final ScrollController _controller = ScrollController();
  final CommentsController _commentsController = CommentsController();

  @override
  void initState() {
    super.initState();
    _commentsController.getComments(widget.postId ?? widget.model!.id, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Column(
          children: <Widget>[
            SizedBox(
              height: widget.isPopup == true ? 20 : 50,
            ),
            backNavigationBar(
                context: context, title: LocalizationString.comments),
            divider(context: context).tP8,
            Obx(() => _commentsController.hashTags.isNotEmpty ||
                _commentsController.searchedUsers.isNotEmpty
                ? Expanded(
              child: Container(
                // height: 500,
                width: double.infinity,
                color: Theme.of(context).disabledColor.withOpacity(0.1),
                child: _commentsController.hashTags.isNotEmpty
                    ? hashTagView()
                    : _commentsController.searchedUsers.isNotEmpty
                    ? usersView()
                    : Container(),
              ),
            )
                : Flexible(
                child: GetBuilder<CommentsController>(
                    init: _commentsController,
                    builder: (ctx) {
                      return ListView.separated(
                        padding: const EdgeInsets.only(
                            top: 20, left: 16, right: 16),
                        itemCount: _commentsController.comments.length,
                        // reverse: true,
                        controller: _controller,
                        itemBuilder: (context, index) {
                          return CommentTile(
                              model: _commentsController.comments[index]);
                        },
                        separatorBuilder: (ctx, index) {
                          return const SizedBox(
                            height: 20,
                          );
                        },
                      );
                    }))),
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
              child: Obx(() {
                commentInputField.value = TextEditingValue(
                    text: _commentsController.searchText.value,
                    selection: TextSelection.fromPosition(
                        TextPosition(offset: _commentsController.position.value)));

                return TextField(
                  controller: commentInputField,
                  onChanged: (text) {
                    _commentsController.textChanged(
                        text, commentInputField.selection.baseOffset);
                  },
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
                ).hP8;
              }).borderWithRadius(context: context, value: 0.5, radius: 25)),
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
    if (commentInputField.text.trim().isNotEmpty) {
      final filter = ProfanityFilter();
      bool hasProfanity = filter.hasProfanity(commentInputField.text);
      if (hasProfanity) {
        AppUtil.showToast(
            context: context,
            message: LocalizationString.notAllowedMessage,
            isSuccess: true);
        return;
      }

      _commentsController.postCommentsApiCall(
          comment: commentInputField.text.trim(),
          postId: widget.postId ?? widget.model!.id);
      commentInputField.text = '';
      // widget.model?.totalComment = comments.length;

      Timer(const Duration(milliseconds: 500),
              () => _controller.jumpTo(_controller.position.maxScrollExtent));
    }
  }

  usersView() {
    return GetBuilder<CommentsController>(
        init: _commentsController,
        builder: (ctx) {
          return ListView.separated(
              padding: const EdgeInsets.only(top: 20),
              itemCount: _commentsController.searchedUsers.length,
              itemBuilder: (BuildContext ctx, int index) {
                return UserTile(
                  profile: _commentsController.searchedUsers[index],
                  viewCallback: () {
                    _commentsController.addUserTag(
                        _commentsController.searchedUsers[index].userName);
                  },
                );
              },
              separatorBuilder: (BuildContext ctx, int index) {
                return const SizedBox(
                  height: 20,
                );
              }).hP16;
        });
  }

  hashTagView() {
    return GetBuilder<CommentsController>(
        init: _commentsController,
        builder: (ctx) {
          return ListView.builder(
            padding: const EdgeInsets.only(left: 16, right: 16),
            itemCount: _commentsController.hashTags.length,
            itemBuilder: (BuildContext ctx, int index) {
              return HashTagTile(
                hashtag: _commentsController.hashTags[index],
                onItemCallback: () {
                  _commentsController
                      .addHashTag(_commentsController.hashTags[index].name);
                },
              );
            },
          );
        });
  }
}
