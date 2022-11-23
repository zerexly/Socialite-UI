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
                children: [
                  model.isGroupChat
                      ? Container(
                          color: Theme.of(context).primaryColor,
                          height: 45,
                          width: 45,
                          child: const ThemeIconWidget(
                            ThemeIcon.group,
                            color: Colors.white,
                            size: 35,
                          ),
                        ).round(15)
                      : UserAvatarView(
                          size: 45,
                          user: model.opponent.userDetail,
                          onTapHandler: () {},
                        ),
                  // AvatarView(size: 50, url: model.opponent.picture),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Spacer(),
                        Text(
                          model.isGroupChat
                              ? model.name!
                              : model.opponent.userDetail.userName,
                          maxLines: 1,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        model.whoIsTyping.isNotEmpty
                            ? Text(
                                '${model.whoIsTyping.join(',')} ${LocalizationString.typing}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              )
                            : model.lastMessage == null
                                ? Container()
                                : messageTypeShortInfo(
                                    model: model.lastMessage!,
                                    context: context,
                                  ),
                        const Spacer(),
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
                model.lastMessage == null
                    ? Container()
                    : Text(
                        model.lastMessage!.messageTime,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w900,
                            color: Theme.of(context).primaryColor),
                      ),
              ],
            ),
          ],
        ));
  }
}
