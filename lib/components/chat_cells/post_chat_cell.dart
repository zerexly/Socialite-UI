import 'package:foap/helper/common_import.dart';

class PostChatTile extends StatelessWidget {
  final ChatMessageModel message;

  const PostChatTile({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 350,
        width: double.infinity,
        child: Container(
          color: message.isMineMessage
              ? Theme.of(context).disabledColor.withOpacity(0.2)
              : Theme.of(context).primaryColor.withOpacity(0.2),
          child: FutureBuilder<PostModel?>(
              future: getPostDetail(message.postContent.postId),
              builder:
                  (BuildContext context, AsyncSnapshot<PostModel?> snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data == null
                      ? Center(
                          child: Text(LocalizationString.postDeleted,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w900)),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                AvatarView(
                                  url: snapshot.data!.user.picture,
                                  name: snapshot.data!.user.userName,
                                  size: 25,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  snapshot.data!.user.userName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ).hP8,
                            const SizedBox(
                              height: 10,
                            ),
                            Expanded(
                              child: Stack(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot.data!.gallery.first
                                          .thumbnail,
                                      httpHeaders: const {'accept': 'image/*'},
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          AppUtil.addProgressIndicator(context,100),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                  snapshot.data!.gallery.first.isVideoPost
                                      ? Container(
                                          color: Colors.black26,
                                          height: 280,
                                          width: double.infinity,
                                        ).round(15)
                                      : Container()
                                ],
                              ),
                            ),
                          ],
                        );
                } else {
                  if (snapshot.data == null &&
                      snapshot.connectionState == ConnectionState.done) {
                    return Center(
                      child: Text(
                        LocalizationString.postDeleted,
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w900),
                      ),
                    );
                  } else {
                    return AppUtil.addProgressIndicator(context,100);
                  }
                }
              }),
        ).round(15));
  }

  Future<PostModel?> getPostDetail(int postId) async {
    PostModel? post;
    await ApiController().getPostDetail(postId).then((value) {
      post = value.post;
    });

    return post;
  }
}

class MinimalInfoPostChatTile extends StatelessWidget {
  final ChatMessageModel message;

  const MinimalInfoPostChatTile({Key? key, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 350,
        width: double.infinity,
        child: Container(
          color: message.isMineMessage
              ? Theme.of(context).disabledColor.withOpacity(0.2)
              : Theme.of(context).primaryColor.withOpacity(0.2),
          child: FutureBuilder<PostModel?>(
              future: getPostDetail(message.postContent.postId),
              builder:
                  (BuildContext context, AsyncSnapshot<PostModel?> snapshot) {
                if (snapshot.hasData) {
                  return Stack(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: CachedNetworkImage(
                          imageUrl: snapshot.data!.gallery.first.thumbnail,
                          httpHeaders: const {'accept': 'image/*'},
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              AppUtil.addProgressIndicator(context,100),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      snapshot.data!.gallery.first.isVideoPost
                          ? Container(
                              color: Colors.black26,
                              height: 280,
                              width: double.infinity,
                            ).round(15)
                          : Container()
                    ],
                  );
                } else {
                  if (snapshot.data == null &&
                      snapshot.connectionState == ConnectionState.done) {
                    return Center(
                      child: Text(
                        LocalizationString.postDeleted,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w900),
                      ),
                    );
                  } else {
                    return AppUtil.addProgressIndicator(context,100);
                  }
                }
              }),
        ).round(15));
  }

  Future<PostModel?> getPostDetail(int postId) async {
    PostModel? post;
    await ApiController().getPostDetail(postId).then((value) {
      post = value.post;
    });

    return post;
  }
}
