import 'package:flutter/cupertino.dart';
import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class ChatMediaList extends StatefulWidget {
  final ChatRoomModel chatRoom;

  const ChatMediaList({Key? key, required this.chatRoom}) : super(key: key);

  @override
  State<ChatMediaList> createState() => _ChatMediaListState();
}

class _ChatMediaListState extends State<ChatMediaList> {
  final ChatRoomDetailController chatRoomDetailController = Get.find();

  @override
  void initState() {
    chatRoomDetailController.segmentChanged(0, widget.chatRoom.id);
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
              ThemeIconWidget(
                ThemeIcon.backArrow,
                color: Theme.of(context).iconTheme.color,
                size: 20,
              ).p8.ripple(() {
                Get.back();
              }),
              Obx(() => CupertinoSlidingSegmentedControl<int>(
                    backgroundColor: Theme.of(context).cardColor,
                    thumbColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.all(8),
                    groupValue: chatRoomDetailController.selectedSegment.value,
                    children: {
                      0: Text(
                        LocalizationString.photo,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ).hP25,
                      1: Text(
                        LocalizationString.video,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ).hP25,
                    },
                    onValueChanged: (value) {
                      chatRoomDetailController.segmentChanged(
                          value!, widget.chatRoom.id);
                    },
                  )),
              const SizedBox(
                width: 20,
              )
            ],
          ).hP16,
          divider(context: context).tP8,
          mediaList()
        ],
      ),
    );
  }

  Widget mediaList() {
    return GetBuilder<ChatRoomDetailController>(
        init: chatRoomDetailController,
        builder: (ctx) {
          ScrollController scrollController = ScrollController();
          scrollController.addListener(() {
            if (scrollController.position.maxScrollExtent ==
                scrollController.position.pixels) {}
          });

          List<ChatMessageModel> messages =
              chatRoomDetailController.selectedSegment.value == 0
                  ? chatRoomDetailController.photos
                  : chatRoomDetailController.videos;

          return Expanded(
            child: MasonryGridView.count(
              controller: scrollController,
              padding: const EdgeInsets.only(top: 20),
              shrinkWrap: true,
              crossAxisCount: 3,
              itemCount: messages.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) => Stack(children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: MessageImage(
                          message: messages[index], fitMode: BoxFit.cover)
                      .round(10),
                ).ripple(() {
                  Get.to(() => MediaListViewer(
                            chatRoom: widget.chatRoom,
                            medias: messages,
                            startFrom: index,
                          ))!
                      .then((value) {
                    chatRoomDetailController.segmentChanged(
                        0, widget.chatRoom.id);
                  });
                }),
                messages[index].messageContentType == MessageContentType.video
                    ? const Positioned(
                        right: 0,
                        top: 0,
                        left: 0,
                        bottom: 0,
                        child: ThemeIconWidget(
                          ThemeIcon.play,
                          size: 70,
                          color: Colors.white,
                        ),
                      )
                    : Container()
              ]),
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
            ).hP16,
          );
        });
  }
}
