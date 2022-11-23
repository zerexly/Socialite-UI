import 'package:foap/helper/common_import.dart';

class ContactChatTile extends StatelessWidget {
  final ChatMessageModel message;

  const ContactChatTile({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocalizationString.contact,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.w900),
              ),
              Text(
                message.mediaContent.contact!.displayName,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                message.mediaContent.contact!.phones
                    .map((e) => e.number)
                    .toString(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
        ThemeIconWidget(
          ThemeIcon.nextArrow,
          size: 15,
          color: Theme.of(context).iconTheme.color,
        )
      ],
    ).bP8;
  }
}
