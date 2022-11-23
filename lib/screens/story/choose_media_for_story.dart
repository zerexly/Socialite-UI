import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class ChooseMediaForStory extends StatefulWidget {
  const ChooseMediaForStory({Key? key}) : super(key: key);

  @override
  State<ChooseMediaForStory> createState() => _ChooseMediaForStoryState();
}

class _ChooseMediaForStoryState extends State<ChooseMediaForStory> {
  final AppStoryController storyController = Get.find();

  @override
  void initState() {
    // storyController.loadGalleryData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          const SizedBox(
            height: 55,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ThemeIconWidget(
                ThemeIcon.close,
                color: Theme.of(context).iconTheme.color,
                size: 27,
              ).ripple(() {
                Get.back();
              }),
              const Spacer(),
              // Image.asset(
              //   'assets/logo.png',
              //   width: 80,
              //   height: 25,
              // ),
              const Spacer(),
              Obx(() => Text(
                    LocalizationString.post,
                    style: storyController.mediaList.isNotEmpty
                        ? Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontWeight: FontWeight.w900)
                        : Theme.of(context).textTheme.titleLarge,
                  ).ripple(() {
                    if (storyController.mediaList.isNotEmpty) {
                      storyController.uploadAllMedia(
                          context: context, items: storyController.mediaList);
                    }
                    // Get.to(() => ChooseStoryViewers(
                    //       images: storyController.selectedItems,
                    //     ));
                  })),
            ],
          ).hp(20),
          const SizedBox(height: 20),
          Expanded(
              child: GetBuilder<AppStoryController>(
                  init: storyController,
                  builder: (ctx) {
                    return CustomGalleryPicker(
                        mediaSelectionCompletion: (medias) {
                      storyController.mediaSelected(medias);
                    }, mediaCapturedCompletion: (media) {
                      storyController
                          .uploadAllMedia(context: context, items: [media]);
                    });
                  }))
        ],
      ),
    );
  }
}
