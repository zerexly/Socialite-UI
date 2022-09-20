import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class HighlightViewer extends StatefulWidget {
  final HighlightsModel highlight;

  const HighlightViewer({Key? key, required this.highlight}) : super(key: key);

  @override
  State<HighlightViewer> createState() => _HighlightViewerState();
}

class _HighlightViewerState extends State<HighlightViewer> {
  final controller = StoryController();
  final HighlightsController highlightController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      resizeToAvoidBottomInset: false,
      body: storyWidget(),
    );
  }

  Widget storyWidget() {
    return Stack(
      children: [
        StoryView(
            storyItems: [
              for (HighlightMediaModel media
                  in widget.highlight.medias.reversed)
                media.story.isVideoPost() == true
                    ? StoryItem.pageImage(
                        key: Key(media.id.toString()),
                        url: media.story.video!,
                        controller: controller,
                      )
                    : StoryItem.pageImage(
                        key: Key(media.id.toString()),
                        url: media.story.image!,
                        controller: controller,
                      ),
            ],
            controller: controller,
            // pass controller here too
            repeat: true,
            // should the stories be slid forever
            onStoryShow: (s) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                highlightController.setCurrentStoryMedia(widget.highlight.medias
                    .where(
                        (element) => Key(element.id.toString()) == s.view.key)
                    .first);
              });
            },
            onComplete: () {
              Get.back();
            },
            onVerticalSwipeComplete: (direction) {
              if (direction == Direction.down) {
                Get.back();
              }
            }),
        Positioned(top: 70, left: 20, right: 0, child: userProfileView()),
      ],
    );
  }

  Widget replyWidget() {
    return FooterLayout(
      footer: KeyboardAttachable(
        // backgroundColor: Colors.blue,
        child: Container(
          height: 60,
          color: Theme.of(context).primaryColor,
          child: Row(
            children: [
              Expanded(
                child: InputField(
                  hintText: LocalizationString.reply,
                ),
              ),
              ThemeIconWidget(
                ThemeIcon.send,
                color: Theme.of(context).iconTheme.color,
              )
            ],
          ).hP25,
        ),
      ),
      child: storyWidget(),
    );
  }

  Widget userProfileView() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Obx(() => AvatarView(
                  url: highlightController
                      .storyMediaModel.value!.story.user!.picture,
                  size: 30,
                )).rP8,
            SizedBox(
              child: Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        highlightController
                            .storyMediaModel.value!.story.user!.userName,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Text(
                        highlightController.storyMediaModel.value!.createdAt,
                        style:
                            Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white70),
                      )
                    ],
                  )),
            )
          ],
        ),
        // const Spacer(),
        SizedBox(
          height: 25,
          width: 40,
          child: ThemeIconWidget(
            ThemeIcon.more,
            color: Theme.of(context).iconTheme.color,
            size: 20,
          ).ripple(() {
            openActionPopup();
          }),
        )
      ],
    );
  }

  void openActionPopup() {
    controller.pause();

    showModalBottomSheet(
        context: context,
        builder: (context) => Wrap(
              children: [
                ListTile(
                    title: Center(
                        child: Text(LocalizationString.deleteFromHighlight)),
                    onTap: () async {
                      Get.back();
                      controller.play();

                      highlightController.deleteStoryFromHighlight();
                    }),
                divider(context: context),
                ListTile(
                    title: Center(child: Text(LocalizationString.cancel)),
                    onTap: () {
                      controller.play();
                      Get.back();
                    }),
              ],
            )).then((value) {
      controller.play();
    });
  }
}
