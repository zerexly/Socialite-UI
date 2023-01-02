import 'package:foap/helper/common_import.dart';

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
            color: message.isMineMessage
                ? Theme.of(context).disabledColor
                : Theme.of(context).primaryColor,
            child: ReplyOriginalMessageTile(
              message: message.repliedOnMessage,
              replyMessageTapHandler: replyMessageTapHandler,
            )).round(8),
        const SizedBox(
          height: 10,
        ),
        Text(
          message.textMessage,
          maxLines: 1,
          style: Theme.of(context).textTheme.bodyLarge,
        ).round(8),
      ],
    );
  }
}
