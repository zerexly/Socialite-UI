import 'package:foap/helper/common_import.dart';

class ReplyOriginalMessageTile extends StatelessWidget {
  final ChatMessageModel message;
  final Function(ChatMessageModel) replyMessageTapHandler;

  const ReplyOriginalMessageTile(
      {Key? key, required this.message, required this.replyMessageTapHandler})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    : message.userName,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).primaryColor.darken(0.5)),
              ),
              const SizedBox(height: 15),

              messageTypeShortInfo(
                message: message,
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
