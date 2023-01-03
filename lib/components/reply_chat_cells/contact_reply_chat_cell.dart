import 'package:foap/helper/common_import.dart';

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
                color: message.isMineMessage
                    ? Theme.of(context).disabledColor.withOpacity(0.2)
                    : Theme.of(context).primaryColor.withOpacity(0.2),
                child: ReplyOriginalMessageTile(
                    message: message.repliedOnMessage,
                    replyMessageTapHandler: replyMessageTapHandler))
            .round(8),
        const SizedBox(
          height: 10,
        ),
        ContactChatTile(message: message).ripple(() {
          messageTapHandler(message);
        }),
      ],
    );
  }
}
