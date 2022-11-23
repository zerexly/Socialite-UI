import 'package:foap/helper/common_import.dart';

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
