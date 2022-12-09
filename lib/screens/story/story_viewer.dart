import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class StoryViewer extends StatefulWidget {
  final StoryModel story;

  const StoryViewer({Key? key, required this.story}) : super(key: key);

  @override
  State<StoryViewer> createState() => _StoryViewerState();
}

class _StoryViewerState extends State<StoryViewer> {
  final controller = StoryController();
  final AppStoryController storyController = Get.find();
  final SettingsController settingsController = Get.find();

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
              for (StoryMediaModel media in widget.story.media.reversed)
                media.isVideoPost() == true
                    ? StoryItem.pageVideo(
                        media.video!,
                        controller: controller,
                        duration: Duration(
                            seconds: int.parse(settingsController
                                .setting.value!.maximumVideoDurationAllowed!)),
                        key: Key(media.id.toString()),
                      )
                    : StoryItem.pageImage(
                        key: Key(media.id.toString()),
                        url: media.image!,
                        controller: controller,
                      ),
            ],
            controller: controller,
            // pass controller here too
            repeat: true,
            // should the stories be slid forever
            onStoryShow: (s) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                storyController.setCurrentStoryMedia(widget.story.media
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
            } // To disable vertical swipe gestures, ignore this parameter.
            // Preferrably for inline story view.
            ),
        Positioned(top: 70, left: 20, right: 0, child: userProfileView()),
        // Positioned(bottom: 0, left: 0, right: 0, child: replyView()),
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
            AvatarView(
              url: widget.story.image,
              size: 30,
            ).rP8,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.story.userName,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w600, color: Colors.white),
                ),
                Obx(() => storyController.storyMediaModel.value != null
                    ? Text(
                        storyController.storyMediaModel.value!.createdAt,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.white70),
                      )
                    : Container())
              ],
            ),
          ],
        ),
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
                    title: Center(child: Text(LocalizationString.deleteStory)),
                    onTap: () async {
                      Get.back();
                      controller.play();

                      storyController.deleteStory();
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

// Widget replyView() {
//   return Column(
//     children: [
//       Text(
//         widget.story.title,
//         style: Theme.of(context).textTheme.bodyLarge.bold,
//         textAlign: TextAlign.center,
//       ).hP16,
//       divider(height: 0.5, color: AppTheme.dividerColor).tP16,
//     ],
//   );
// }
}
