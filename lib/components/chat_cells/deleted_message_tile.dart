import 'package:foap/helper/common_import.dart';

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
