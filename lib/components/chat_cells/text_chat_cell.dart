import 'package:foap/helper/common_import.dart';
import 'package:link_preview_generator/link_preview_generator.dart';

class TextChatTile extends StatelessWidget {
  final ChatMessageModel message;

  const TextChatTile({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // bool validURL = Uri.parse(message.messageContent).isAbsolute;
    bool validURL = message.messageContent.isValidUrl;

    return validURL == true
        ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinkPreviewGenerator(
          bodyMaxLines: 3,
          link: message.messageContent,
          linkPreviewStyle: LinkPreviewStyle.large,
          showGraphic: true,
          errorBody: message.messageContent,
        ),
        const SizedBox(
          height: 10,
        ),
        Linkify(
          onOpen: (link) async {
            if (await canLaunchUrl(Uri.parse(link.url))) {
              await launchUrl(Uri.parse(link.url));
            } else {
              throw 'Could not launch $link';
            }
          },
          text: message.messageContent,
          style: Theme.of(context).textTheme.bodyLarge,
        )
      ],
    )
        : Linkify(
      onOpen: (link) async {
        if (await canLaunchUrl(Uri.parse(link.url))) {
          await launchUrl(Uri.parse(link.url));
        } else {
          throw 'Could not launch $link';
        }
      },
      text: message.messageContent,
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }
}
