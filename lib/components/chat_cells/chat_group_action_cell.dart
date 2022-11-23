import 'dart:convert';

import 'package:foap/helper/common_import.dart';

class ChatGroupActionCell extends StatelessWidget {
  final ChatMessageModel message;

  const ChatGroupActionCell({Key? key, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> actionMessage = json.decode(message.messageContent);
    int action = actionMessage['action'] as int;
    String actionMessageString = '';

    if (action == 1) {
      String userName = actionMessage['username'] as String;

      actionMessageString = '$userName ${LocalizationString.addedToGroup}';
    } else if (action == 2) {
      String userName = actionMessage['username'] as String;

      actionMessageString = '$userName ${LocalizationString.removedFromGroup}';
    } else if (action == 3) {
      String userName = actionMessage['username'] as String;

      actionMessageString = '$userName ${LocalizationString.madeAdmin}';
    } else if (action == 4) {
      String userName = actionMessage['username'] as String;

      actionMessageString = '$userName ${LocalizationString.removedFromAdmins}';
    } else if (action == 5) {
      String userName = actionMessage['username'] as String;

      actionMessageString = '$userName ${LocalizationString.leftTheGroup}';
    }

    return Container(
            color: Theme.of(context).primaryColor.lighten(0.2),
            child: Text(
              actionMessageString,
              style: Theme.of(context).textTheme.bodyLarge,
            ).setPadding(left: 8, right: 8, top: 4, bottom: 4))
        .round(10);
  }
}
