import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class ChatImageViewer extends StatefulWidget {
  final ChatMessageModel chatMessage;
  final VoidCallback? handler;

  const ChatImageViewer({Key? key, required this.chatMessage, this.handler})
      : super(key: key);

  @override
  EnlargeImageViewState createState() => EnlargeImageViewState();
}

class EnlargeImageViewState extends State<ChatImageViewer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const ThemeIconWidget(
                  ThemeIcon.backArrow,
                  size: 20,
                  color: Colors.white,
                ).ripple(() {
                  Get.back();
                }),
              ],
            ).hP16,
            divider(context: context).vP8,
            Expanded(
                child: MessageImage(
                    message: widget.chatMessage, fitMode: BoxFit.contain)),
          ],
        ));
  }
}
