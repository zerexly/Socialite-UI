import 'package:foap/helper/common_import.dart';

class ChatHistoryTile extends StatelessWidget {
  final ChatRoomModel model;

  const ChatHistoryTile({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 55,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  UserAvatarView(
                    size: 50,
                    user: model.opponent,
                    onTapHandler: () {},
                  ),
                  // AvatarView(size: 50, url: model.opponent.picture),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          model.opponent.userName,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        model.isTyping == true
                            ? Text(
                                LocalizationString.typing,
                                style: Theme.of(context).textTheme.bodyMedium,
                              )
                            : messageTypeShortInfo(
                                model: model.lastMessage,
                                context: context,
                              ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                model.unreadMessages > 0
                    ? Container(
                        height: 25,
                        width: 25,
                        color: Theme.of(context).primaryColor,
                        child: Center(
                          child: Text(
                            '${model.unreadMessages}',
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontWeight: FontWeight.w900,
                                    ),
                          ),
                        ),
                      ).circular.bP8
                    : Container(),
                Text(
                  model.lastMessage.messageTime,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.w900,color: Theme.of(context).primaryColor),
                ),
              ],
            ),
          ],
        ));
  }
}
