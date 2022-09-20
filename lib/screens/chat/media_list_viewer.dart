import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class MediaListViewer extends StatefulWidget {
  final ChatRoomModel chatRoom;
  final List<ChatMessageModel> medias;
  final int startFrom;

  const MediaListViewer(
      {Key? key,
      required this.medias,
      required this.chatRoom,
      required this.startFrom})
      : super(key: key);

  @override
  State<MediaListViewer> createState() => _MediaListViewerState();
}

class _MediaListViewerState extends State<MediaListViewer> {
  final MediaListViewerController mediaListViewerController = Get.find();

  @override
  void initState() {
    mediaListViewerController.setCurrentMediaIndex(widget.startFrom);
    mediaListViewerController.setMessages(widget.medias);
    super.initState();
  }

  @override
  void dispose() {
    mediaListViewerController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SizedBox(
          child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ThemeIconWidget(
                ThemeIcon.backArrow,
                color: Theme.of(context).iconTheme.color,
                size: 20,
              ).p8.ripple(() {
                Get.back();
              }),
              Text(
                LocalizationString.media,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w900).copyWith(color: Theme.of(context).primaryColor),
              ),
              ThemeIconWidget(
                ThemeIcon.delete,
                size: 25,
                color: Theme.of(context).iconTheme.color,
              ).ripple(() {
                mediaListViewerController.deleteMessage(
                    inChatRoom: widget.chatRoom);
              })
            ],
          ).hP16,
          divider(context: context).vP8,
          GetBuilder<MediaListViewerController>(
              init: mediaListViewerController,
              builder: (ctx) {
                return CarouselSlider(
                  items: addImages(),
                  options: CarouselOptions(
                      enlargeCenterPage: false,
                      enableInfiniteScroll: false,
                      height: MediaQuery.of(context).size.height * 0.8,
                      viewportFraction: 1,
                      onPageChanged: (index, reason) {
                        mediaListViewerController.setCurrentMediaIndex(index);
                      },
                      initialPage: widget.startFrom),
                );
              }),
        ],
      )),
    );
  }

  List<Widget> addImages() {
    return widget.medias
        .map((item) => MessageImage(
              message: item,
              fitMode: BoxFit.contain,
              disableRoundCorner: true,
            ))
        .toList();
  }
}
