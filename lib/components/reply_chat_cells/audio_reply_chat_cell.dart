import 'package:foap/helper/common_import.dart';


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
