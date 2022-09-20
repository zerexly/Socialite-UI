import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class ChooseMediaForChat extends StatefulWidget {
  final Function(List<Media>) selectedMediaCompletetion;

  const ChooseMediaForChat({Key? key, required this.selectedMediaCompletetion})
      : super(key: key);

  @override
  State<ChooseMediaForChat> createState() => _ChooseMediaForChatState();
}

class _ChooseMediaForChatState extends State<ChooseMediaForChat> {
  final SelectMediaController selectMediaController = Get.find();

  @override
  void initState() {
    // selectMediaController.loadGalleryData(context);
    selectMediaController.mediaCountSelected(MediaCount.single);
    super.initState();
  }

  @override
  void dispose() {
    selectMediaController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GetBuilder<SelectMediaController>(
              init: selectMediaController,
              builder: (ctx) {
                return Stack(
                  children: [
                    MediaPicker(
                      onPick: (selectedList) {
                        selectMediaController.mediaSelected(selectedList);
                      },
                      onSelectMediaCount: (count) {
                        selectMediaController.mediaCountSelected(count);
                      },
                      capturedMedia: (media) {
                        widget.selectedMediaCompletetion([media]);
                      },
                      mediaCount: selectMediaController.mediaCount.value,
                      mediaType: GalleryMediaType.all,
                      decoration: PickerDecoration(
                        actionBarPosition: ActionBarPosition.top,
                        blurStrength: 2,
                        completeText: 'Next',
                      ),
                    ).round(20).p16,
                    Obx(() {
                      return selectMediaController.mediaList.isNotEmpty
                          ? Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                color: Theme.of(context).primaryColor,
                                height: 60,
                                width: 60,
                                child: const ThemeIconWidget(
                                  ThemeIcon.send,
                                  size: 25,
                                ),
                              ).circular.p25.ripple(() {
                                widget.selectedMediaCompletetion(
                                    selectMediaController.mediaList);
                              }),
                            )
                          : Container();
                    })
                  ],
                );
              }),
        ),
        const SizedBox(
          height: 10,
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            height: 50,
            width: 50,
            color: Theme.of(context).backgroundColor,
            child: Center(
              child: ThemeIconWidget(
                ThemeIcon.close,
                color: Theme.of(context).iconTheme.color,
                size: 25,
              ),
            ),
          ).circular.ripple(() {
            Get.back();
          }),
        ),
        const SizedBox(
          height: 40,
        ),
      ],
    );
  }

// captureImage() async {
//   final XFile? photo =
//       await ImagePicker().pickImage(source: ImageSource.camera);
//   if (photo != null) {
//     selectMediaController.selectedItems.clear();
//     Uint8List bytes = await photo.readAsBytes();
//     var galleryImage = Media(
//       mediaByte: bytes,
//       id: '1',
//       creationTime: DateTime.now(),
//       mediaType: GalleryMediaType.image,
//     );
//     selectMediaController.selectedItems.add(galleryImage);
//
//     Get.to(() => ChooseStoryViewers(
//           images: selectMediaController.selectedItems,
//         ));
//   }
// }

// _buildItem(int index) => GestureDetector(
//     onTap: () async {
//       await selectMediaController.selectItem(index);
//       widget.selectedMedia(selectMediaController.selectedItems.first);
//     },
//     child: GetBuilder<SelectMediaController>(
//         init: selectMediaController,
//         builder: (ctx) {
//           Media item = selectMediaController.mediaList[index];
//           return Stack(
//             children: [
//               SizedBox(
//                 height: double.infinity,
//                 width: double.infinity,
//                 child: Stack(
//                   children: [
//                     Image.memory(
//                       item.thumbnail!,
//                       fit: BoxFit.cover,
//                       height: double.infinity,
//                       width: double.infinity,
//                     ).round(5),
//                     item.mediaType == GalleryMediaType.video
//                         ? const Positioned(
//                             top: 0,
//                             right: 0,
//                             left: 0,
//                             bottom: 0,
//                             child: ThemeIconWidget(
//                               ThemeIcon.play,
//                               size: 80,
//                               color: Colors.white,
//                             ))
//                         : Container()
//                   ],
//                 ),
//               ),
//               selectMediaController.isSelected(item.id)
//                   ? Positioned(
//                       top: 5,
//                       right: 5,
//                       child: Container(
//                         height: 20,
//                         width: 20,
//                         color: Theme.of(context).primaryColor,
//                         child: const ThemeIconWidget(ThemeIcon.checkMark),
//                       ).circular)
//                   : Container()
//             ],
//           );
//         }));
}
