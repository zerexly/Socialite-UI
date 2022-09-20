import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class ReplyOriginalMessageTile extends StatelessWidget {
  final ChatMessageModel message;
  final Function(ChatMessageModel) replyMessageTapHandler;

  const ReplyOriginalMessageTile(
      {Key? key, required this.message, required this.replyMessageTapHandler})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChatDetailController chatDetailController = Get.find();

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                message.isMineMessage
                    ? LocalizationString.you
                    : chatDetailController.opponent.value!.userName,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).primaryColor),
              ),
              const SizedBox(height: 15),
              messageTypeShortInfo(
                model: message,
                context: context,
              )
            ],
          ).p8,
        ),
        messageMainContent(message),
      ],
    ).ripple(() {
      replyMessageTapHandler(message);
    });
  }
}

class ReplyTextChatTile extends StatelessWidget {
  final ChatMessageModel message;
  final Function(ChatMessageModel) replyMessageTapHandler;
  final Function(ChatMessageModel) messageTapHandler;

  const ReplyTextChatTile(
      {Key? key,
      required this.message,
      required this.replyMessageTapHandler,
      required this.messageTapHandler})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            height: 70,
            color: message.originalMessage.isMineMessage
                ? Theme.of(context).disabledColor.withOpacity(0.2)
                : Theme.of(context).primaryColor.withOpacity(0.2),
            child: ReplyOriginalMessageTile(
              message: message.originalMessage,
              replyMessageTapHandler: replyMessageTapHandler,
            )).round(8),
        const SizedBox(
          height: 10,
        ),
        Text(
          message.reply.messageContent,
          maxLines: 1,
          style: Theme.of(context).textTheme.bodyLarge,
        ).round(8),
      ],
    );
  }
}

class ReplyAudioChatTile extends StatefulWidget {
  final ChatMessageModel message;
  final Function(ChatMessageModel) replyMessageTapHandler;

  const ReplyAudioChatTile(
      {Key? key, required this.message, required this.replyMessageTapHandler})
      : super(key: key);

  @override
  State<ReplyAudioChatTile> createState() => _ReplyAudioChatTileState();
}

class _ReplyAudioChatTileState extends State<ReplyAudioChatTile> {
  @override
  void initState() {
    super.initState();
  }

  playAudio() {
    getIt<PlayerManager>().playAudio(widget.message.reply);
  }

  stopAudio() {
    getIt<PlayerManager>().stopAudio();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
                height: 70,
                color: widget.message.originalMessage.isMineMessage
                    ? Theme.of(context).disabledColor.withOpacity(0.2)
                    : Theme.of(context).primaryColor.withOpacity(0.2),
                child: ReplyOriginalMessageTile(
                    message: widget.message.originalMessage,
                    replyMessageTapHandler: widget.replyMessageTapHandler))
            .round(8),
        const SizedBox(
          height: 10,
        ),
        ValueListenableBuilder<String?>(
            key: UniqueKey(),
            valueListenable: getIt<PlayerManager>().playStateNotifier,
            builder: (_, value, __) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  value == widget.message.reply.id.toString()
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
                  const Expanded(
                    child: SizedBox(
                      height: 20,
                      child: AudioProgressBar(),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  )
                ],
              );
            }),
      ],
    );
  }
}

class ReplyImageChatTile extends StatelessWidget {
  final ChatMessageModel message;
  final Function(ChatMessageModel) replyMessageTapHandler;
  final Function(ChatMessageModel) messageTapHandler;

  const ReplyImageChatTile(
      {Key? key,
      required this.message,
      required this.replyMessageTapHandler,
      required this.messageTapHandler})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
                height: 70,
                color: message.originalMessage.isMineMessage
                    ? Theme.of(context).disabledColor.withOpacity(0.2)
                    : Theme.of(context).primaryColor.withOpacity(0.2),
                child: ReplyOriginalMessageTile(
                    message: message.originalMessage,
                    replyMessageTapHandler: replyMessageTapHandler))
            .round(8),
        const SizedBox(
          height: 10,
        ),
        ImageChatTile(message: message.reply).ripple(() {
          messageTapHandler(message.reply);
        }),
      ],
    );
  }
}

class ReplyStickerChatTile extends StatelessWidget {
  final ChatMessageModel message;
  final Function(ChatMessageModel) replyMessageTapHandler;
  final Function(ChatMessageModel) messageTapHandler;

  const ReplyStickerChatTile(
      {Key? key,
      required this.message,
      required this.replyMessageTapHandler,
      required this.messageTapHandler})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
                height: 70,
                color: message.originalMessage.isMineMessage
                    ? Theme.of(context).disabledColor.withOpacity(0.2)
                    : Theme.of(context).primaryColor.withOpacity(0.2),
                child: ReplyOriginalMessageTile(
                    message: message.originalMessage,
                    replyMessageTapHandler: replyMessageTapHandler))
            .round(8),
        const SizedBox(
          height: 10,
        ),
        StickerChatTile(message: message.reply).ripple(() {
          messageTapHandler(message.reply);
        }),
      ],
    );
  }
}

class ReplyVideoChatTile extends StatelessWidget {
  final ChatMessageModel message;
  final Function(ChatMessageModel) replyMessageTapHandler;
  final Function(ChatMessageModel) messageTapHandler;

  const ReplyVideoChatTile(
      {Key? key,
      required this.message,
      required this.replyMessageTapHandler,
      required this.messageTapHandler})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
                height: 70,
                color: message.originalMessage.isMineMessage
                    ? Theme.of(context).disabledColor.withOpacity(0.2)
                    : Theme.of(context).primaryColor.withOpacity(0.2),
                child: ReplyOriginalMessageTile(
                    message: message.originalMessage,
                    replyMessageTapHandler: replyMessageTapHandler))
            .round(8),
        const SizedBox(
          height: 10,
        ),
        VideoChatTile(message: message.reply).ripple(() {
          messageTapHandler(message.reply);
        }),
      ],
    );
  }
}

class ReplyLocationChatTile extends StatelessWidget {
  final ChatMessageModel message;
  final Function(ChatMessageModel) replyMessageTapHandler;
  final Function(ChatMessageModel) messageTapHandler;

  const ReplyLocationChatTile(
      {Key? key,
      required this.message,
      required this.replyMessageTapHandler,
      required this.messageTapHandler})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            height: 70,
            color: message.originalMessage.isMineMessage
                ? Theme.of(context).disabledColor.withOpacity(0.2)
                : Theme.of(context).primaryColor.withOpacity(0.2),
            child: ReplyOriginalMessageTile(
                message: message.originalMessage,
                replyMessageTapHandler: replyMessageTapHandler))
            .round(8),
        const SizedBox(
          height: 10,
        ),
        LocationChatTile(message: message.reply).ripple(() {
          messageTapHandler(message.reply);
        }),
      ],
    );
  }
}

class ReplyContactChatTile extends StatelessWidget {
  final ChatMessageModel message;
  final Function(ChatMessageModel) replyMessageTapHandler;
  final Function(ChatMessageModel) messageTapHandler;

  const ReplyContactChatTile(
      {Key? key,
        required this.message,
        required this.replyMessageTapHandler,
        required this.messageTapHandler})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            height: 70,
            color: message.originalMessage.isMineMessage
                ? Theme.of(context).disabledColor.withOpacity(0.2)
                : Theme.of(context).primaryColor.withOpacity(0.2),
            child: ReplyOriginalMessageTile(
                message: message.originalMessage,
                replyMessageTapHandler: replyMessageTapHandler))
            .round(8),
        const SizedBox(
          height: 10,
        ),
        ContactChatTile(message: message.reply).ripple(() {
          messageTapHandler(message.reply);
        }),
      ],
    );
  }
}
