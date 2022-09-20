import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:link_preview_generator/link_preview_generator.dart';
import 'package:google_static_maps_controller/google_static_maps_controller.dart';

class ChatMessageTile extends StatelessWidget {
  final ChatMessageModel message;
  final bool actionMode;
  final ChatDetailController chatDetailController = Get.find();
  final Function(ChatMessageModel) replyMessageTapHandler;
  final Function(ChatMessageModel) messageTapHandler;

  ChatMessageTile(
      {Key? key,
      required this.message,
      required this.actionMode,
      required this.replyMessageTapHandler,
      required this.messageTapHandler})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        actionMode
            ? Obx(() => Row(
                  children: [
                    ThemeIconWidget(
                      chatDetailController.isSelected(message)
                          ? ThemeIcon.checkMarkWithCircle
                          : ThemeIcon.circleOutline,
                      size: 20,
                      color: Theme.of(context).disabledColor,
                    ).ripple(() {
                      chatDetailController.selectMessage(message);
                    }),
                    const SizedBox(
                      width: 10,
                    )
                  ],
                ))
            : Container(),
        // message.isMineMessage ? const Spacer() : Container(),
        Expanded(
          child: Container(
            color: message.messageContentType == MessageContentType.gif ||
                    message.messageContentType == MessageContentType.sticker
                ? Colors.transparent
                : message.isMineMessage
                    ? Theme.of(context).backgroundColor
                    : Theme.of(context)
                        .primaryColor
                        .lighten(0.2)
                        .withOpacity(0.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // nameWidget(),
                message.messageContentType == MessageContentType.forward &&
                        message.isMineMessage == false
                    ? Row(
                        children: [
                          ThemeIconWidget(
                            ThemeIcon.fwd,
                            size: 15,
                            color: Theme.of(context).iconTheme.color,
                          ).rP4,
                          Text(
                            LocalizationString.forward,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      )
                    : Container(),
                const SizedBox(
                  height: 5,
                ),
                message.isDeleted == 1
                    ? deletedMessageWidget()
                    : message.isReply
                        ? replyContentWidget()
                        : contentWidget(message).ripple(() {
                            messageTapHandler(message);
                          }),
                const SizedBox(
                  height: 5,
                ),
                MessageDeliveryStatusView(message: message),
              ],
            ).p8,
          ).round(10).setPadding(
              left: message.isMineMessage ? 50 : 0,
              right: message.isMineMessage ? 0 : 50),
        ),
        // message.isMineMessage ? Container() : const Spacer(),
      ],
    );
  }

  Widget deletedMessageWidget() {
    return DeletedMessageChatTile(message: message);
  }

  Widget replyContentWidget() {
    if (message.reply.messageContentType == MessageContentType.text) {
      return ReplyTextChatTile(
        message: message,
        messageTapHandler: messageTapHandler,
        replyMessageTapHandler: replyMessageTapHandler,
      );
    } else if (message.reply.messageContentType == MessageContentType.photo) {
      return ReplyImageChatTile(
          message: message,
          messageTapHandler: messageTapHandler,
          replyMessageTapHandler: replyMessageTapHandler);
    } else if (message.reply.messageContentType == MessageContentType.gif) {
      return ReplyStickerChatTile(
          message: message,
          messageTapHandler: messageTapHandler,
          replyMessageTapHandler: replyMessageTapHandler);
    } else if (message.reply.messageContentType == MessageContentType.video) {
      return ReplyVideoChatTile(
          message: message,
          messageTapHandler: messageTapHandler,
          replyMessageTapHandler: replyMessageTapHandler);
    } else if (message.reply.messageContentType == MessageContentType.audio) {
      return ReplyAudioChatTile(
          message: message, replyMessageTapHandler: replyMessageTapHandler);
    } else if (message.reply.messageContentType == MessageContentType.contact) {
      return ReplyContactChatTile(
          message: message,
          messageTapHandler: messageTapHandler,
          replyMessageTapHandler: replyMessageTapHandler);
    } else if (message.reply.messageContentType ==
        MessageContentType.location) {
      return ReplyLocationChatTile(
          message: message,
          messageTapHandler: messageTapHandler,
          replyMessageTapHandler: replyMessageTapHandler);
    }
    return TextChatTile(message: message);
  }

  Widget contentWidget(ChatMessageModel messageModel) {
    if (messageModel.messageContentType == MessageContentType.text) {
      return TextChatTile(message: messageModel);
    } else if (messageModel.messageContentType == MessageContentType.photo) {
      return ImageChatTile(message: messageModel);
    } else if (messageModel.messageContentType == MessageContentType.gif) {
      return StickerChatTile(message: messageModel);
    } else if (messageModel.messageContentType == MessageContentType.video) {
      return VideoChatTile(message: messageModel);
    } else if (messageModel.messageContentType == MessageContentType.audio) {
      return AudioChatTile(message: messageModel);
    } else if (messageModel.messageContentType == MessageContentType.post) {
      return PostChatTile(message: messageModel);
    } else if (messageModel.messageContentType == MessageContentType.location) {
      return LocationChatTile(message: messageModel);
    } else if (messageModel.messageContentType == MessageContentType.forward) {
      return contentWidget(messageModel.originalMessage);
    } else if (messageModel.messageContentType == MessageContentType.contact) {
      return ContactChatTile(message: messageModel);
    }
    return TextChatTile(message: message);
  }

  Widget nameWidget(BuildContext context) {
    return Text(
      'Message sender name',
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(fontWeight: FontWeight.w900),
    );
  }
}

class DeletedMessageChatTile extends StatelessWidget {
  final ChatMessageModel message;

  const DeletedMessageChatTile({Key? key, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      LocalizationString.thisMessageIsDeleted,
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(decoration: TextDecoration.underline),
    );
  }
}

class TextChatTile extends StatelessWidget {
  final ChatMessageModel message;

  const TextChatTile({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool validURL = Uri.parse(message.messageContent).isAbsolute;

    return validURL == true
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LinkPreviewGenerator(
                bodyMaxLines: 3,
                link: message.messageContent,
                linkPreviewStyle: LinkPreviewStyle.large,
                showGraphic: true,
                errorBody: message.messageContent,
              ),
              const SizedBox(
                height: 10,
              ),
              Linkify(
                onOpen: (link) async {
                  if (await canLaunchUrl(Uri.parse(link.url))) {
                    await launchUrl(Uri.parse(link.url));
                  } else {
                    throw 'Could not launch $link';
                  }
                },
                text: message.messageContent,
                style: Theme.of(context).textTheme.bodyLarge,
              )
            ],
          )
        : Linkify(
            onOpen: (link) async {
              if (await canLaunchUrl(Uri.parse(link.url))) {
                await launchUrl(Uri.parse(link.url));
              } else {
                throw 'Could not launch $link';
              }
            },
            text: message.messageContent,
            style: Theme.of(context).textTheme.bodyLarge,
          );
  }
}

class ContactChatTile extends StatelessWidget {
  final ChatMessageModel message;

  const ContactChatTile({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocalizationString.contact,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.w900),
              ),
              Text(
                message.mediaContent.contact!.displayName,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                message.mediaContent.contact!.phones
                    .map((e) => e.number)
                    .toString(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
        ThemeIconWidget(
          ThemeIcon.nextArrow,
          size: 15,
          color: Theme.of(context).iconTheme.color,
        )
      ],
    ).bP8;
  }
}

class LocationChatTile extends StatelessWidget {
  final ChatMessageModel message;

  const LocationChatTile({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = StaticMapController(
      googleApiKey: AppConfigConstants.googleMapApiKey,
      width: 400,
      height: 400,
      zoom: 15,
      center: Location(message.mediaContent.location!.latitude,
          message.mediaContent.location!.longitude),
    );
    ImageProvider image = controller.image;

    return Image(image: image).round(10);
  }
}

class AudioChatTile extends StatefulWidget {
  final ChatMessageModel message;

  const AudioChatTile({Key? key, required this.message}) : super(key: key);

  @override
  State<AudioChatTile> createState() => _AudioChatTileState();
}

class _AudioChatTileState extends State<AudioChatTile> {
  @override
  void initState() {
    super.initState();
  }

  playAudio() {
    getIt<PlayerManager>().playAudio(widget.message);
  }

  stopAudio() {
    getIt<PlayerManager>().stopAudio();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
        key: UniqueKey(),
        valueListenable: getIt<PlayerManager>().playStateNotifier,
        builder: (_, value, __) {
          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  value == widget.message.id.toString()
                      ? const ThemeIconWidget(
                          ThemeIcon.stop,
                          color: Colors.white,
                          size: 30,
                        ).ripple(() {
                          stopAudio();
                        })
                      : const ThemeIconWidget(
                          ThemeIcon.play,
                          color: Colors.white,
                          size: 30,
                        ).ripple(() {
                          playAudio();
                        }),
                  const SizedBox(
                    width: 15,
                  ),
                  const SizedBox(
                    width: 230,
                    height: 20,
                    child: AudioProgressBar(),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              )
            ],
          );
        });
  }
}

class ImageChatTile extends StatelessWidget {
  final ChatMessageModel message;

  const ImageChatTile({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: message.messageContentType == MessageContentType.photo
      //     ? double.infinity
      //     : null,
      height: 280,
      child: message.media != null
          ? Stack(
              children: [
                Image.memory(
                  message.media!.mediaByte!,
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                ),
                Positioned(
                    child:
                        Center(child: AppUtil.addProgressIndicator(context))),
              ],
            )
          : MessageImage(
              message: message,
              fitMode: BoxFit.cover,
            ),
    ).round(10);
  }
}

class StickerChatTile extends StatelessWidget {
  final ChatMessageModel message;

  const StickerChatTile({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: message.media == null
          ? Align(
              alignment: message.isMineMessage
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: CachedNetworkImage(
                imageUrl: message.mediaContent.gif!,
                httpHeaders: const {'accept': 'image/*'},
                fit: BoxFit.contain,
                placeholder: (context, url) =>
                    AppUtil.addProgressIndicator(context),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ).setPadding(
                  left: message.isMineMessage ? 0 : 20,
                  right: message.isMineMessage ? 20 : 0),
            )
          : Image.memory(
              message.media!.mediaByte!,
              fit: BoxFit.cover,
            ),
    ).round(10);
  }
}

class VideoChatTile extends StatelessWidget {
  final ChatMessageModel message;
  final bool? showSmall;

  const VideoChatTile({Key? key, required this.message, this.showSmall})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      // width: 280,
      child: Stack(
        children: [
          message.media != null
              ? Stack(
                  children: [
                    Image.memory(
                      message.media!.thumbnail!,
                      fit: BoxFit.cover,
                      height: double.infinity,
                      width: double.infinity,
                    ).round(15),
                    Positioned(
                        child: Center(
                            child: AppUtil.addProgressIndicator(context))),
                  ],
                )
              : MessageImage(
                  message: message,
                  fitMode: BoxFit.cover,
                ).round(10),
          Container(
            color: Colors.black26,
            height: 280,
            width: double.infinity,
          ).round(10),
          Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              left: 0,
              child: ThemeIconWidget(
                ThemeIcon.play,
                size: showSmall == true ? 20 : 80,
                color: Colors.white,
              ))
        ],
      ),
    );
  }
}

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
                                          .thumbnail(),
                                      httpHeaders: const {'accept': 'image/*'},
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          AppUtil.addProgressIndicator(context),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                  snapshot.data!.gallery.first.isVideoPost()
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
                    return AppUtil.addProgressIndicator(context);
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
                          imageUrl: snapshot.data!.gallery.first.thumbnail(),
                          httpHeaders: const {'accept': 'image/*'},
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              AppUtil.addProgressIndicator(context),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      snapshot.data!.gallery.first.isVideoPost()
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
                    return AppUtil.addProgressIndicator(context);
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

class MessageDeliveryStatusView extends StatelessWidget {
  final ChatMessageModel message;

  const MessageDeliveryStatusView({Key? key, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          message.messageTime,
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontWeight: FontWeight.w600),
        ),
        message.isMineMessage
            ? ThemeIconWidget(
                message.messageStatusType == MessageStatus.sent
                    ? ThemeIcon.sent
                    : message.messageStatusType == MessageStatus.delivered
                        ? ThemeIcon.delivered
                        : message.messageStatusType == MessageStatus.read
                            ? ThemeIcon.read
                            : ThemeIcon.sending,
                size: 15,
                color: message.messageStatusType == MessageStatus.read
                    ? Colors.blue
                    : Theme.of(context).iconTheme.color,
              )
            : Container(),
      ],
    );
  }
}

class AudioProgressBar extends StatelessWidget {
  const AudioProgressBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PlayerManager>();
    return ValueListenableBuilder<ProgressBarState>(
      valueListenable: pageManager.progressNotifier,
      builder: (_, value, __) {
        return ProgressBar(
          thumbColor: Theme.of(context).backgroundColor,
          progressBarColor: Theme.of(context).backgroundColor,
          baseBarColor: Theme.of(context).backgroundColor.lighten(),
          thumbRadius: 8,
          barHeight: 2,
          progress: value.current,
          // buffered: value.buffered,
          total: value.total,
          timeLabelPadding: 5,
          timeLabelTextStyle: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(fontWeight: FontWeight.w900),
          // onSeek: pageManager.seek,
        );
      },
    );
  }
}
