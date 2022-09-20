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
              Image.asset(
                'assets/logo.png',
                width: 80,
                height: 25,
              ),
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
                    return MediaPicker(
                      // mediaList: mediaList,
                      onPick: (selectedList) {
                        storyController.mediaSelected(selectedList);
                      },
                      onSelectMediaCount: (count) {
                        storyController.mediaCountSelected(count);
                      },
                      capturedMedia: (media) {
                        storyController.mediaSelected([media]);
                      },
                      mediaCount: storyController.mediaCount.value,
                      mediaType: GalleryMediaType.all,
                      decoration: PickerDecoration(
                          actionBarPosition: ActionBarPosition.top,
                          blurStrength: 2,
                          completeText: 'Next',
                          childAspectRatio: 0.5),
                    );
                  })
              // GetBuilder<AppStoryController>(
              //     init: storyController,
              //     builder: (ctx) {
              //       return GridView.builder(
              //           padding: EdgeInsets.zero,
              //           gridDelegate:
              //               const SliverGridDelegateWithFixedCrossAxisCount(
              //                   crossAxisSpacing: 5,
              //                   mainAxisSpacing: 5,
              //                   childAspectRatio: 0.6,
              //                   crossAxisCount: 3),
              //           itemCount: storyController.numberOfItems.value + 1,
              //           itemBuilder: (context, index) {
              //             if (index == 0) {
              //               return Container(
              //                 color: Theme.of(context).disabledColor,
              //                 child: const ThemeIconWidget(
              //                   ThemeIcon.camera,
              //                   color: Colors.white,
              //                   size: 40,
              //                 ),
              //               ).round(10).ripple(() {
              //                 captureImage();
              //               });
              //             } else {
              //               return _buildItem(index - 1);
              //             }
              //           }).hP16;
              //     }),
              )
        ],
      ),
    );
  }

  // captureImage() async {
  //   final XFile? photo =
  //       await ImagePicker().pickImage(source: ImageSource.camera);
  //   if (photo != null) {
  //     storyController.mediaSelected([]);
  //     Uint8List bytes = await photo.readAsBytes();
  //     var galleryImage = Media(
  //       mediaByte: bytes,
  //       id: '1',
  //       creationTime: DateTime.now(),
  //       mediaType: GalleryMediaType.image,
  //     );
  //     storyController.mediaSelected([galleryImage]);
  //
  //     Get.to(() => ChooseStoryViewers(
  //           images: storyController.mediaList,
  //         ));
  //   }
  // }

// _buildItem(int index) {
//   return GetBuilder<AppStoryController>(
//       init: storyController,
//       builder: (ctx) {
//         GalleryMedia item = storyController.mediaList[index];
//
//         return GestureDetector(
//             onTap: () {
//               storyController.selectItem(index);
//             },
//             child: Stack(
//               children: [
//                 SizedBox(
//                   height: double.infinity,
//                   width: double.infinity,
//                   child: Stack(
//                     children: [
//                       Image.memory(
//                         item.mediaType == 1
//                             ? item.bytes
//                             : item.thumbnailBytes!,
//                         fit: BoxFit.cover,
//                         height: double.infinity,
//                         width: double.infinity,
//                       ).round(5),
//                       item.mediaType == 2
//                           ? Positioned(
//                               top: 0,
//                               right: 0,
//                               left: 0,
//                               bottom: 0,
//                               child: Container(
//                                 color: Colors.black38,
//                                 child: const ThemeIconWidget(
//                                   ThemeIcon.play,
//                                   size: 80,
//                                   color: Colors.white,
//                                 ),
//                               ).round(5))
//                           : Container()
//                     ],
//                   ),
//                 ),
//                 storyController.isSelected(item.id)
//                     ? Positioned(
//                         top: 5,
//                         right: 5,
//                         child: Container(
//                           height: 20,
//                           width: 20,
//                           color: Theme.of(context).primaryColor,
//                           child: const ThemeIconWidget(ThemeIcon.checkMark),
//                         ).circular)
//                     : Container()
//               ],
//             ));
//       });
// }
}
