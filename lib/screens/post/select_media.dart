import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class SelectMedia extends StatefulWidget {
  final int? competitionId;
  final PostMediaType? mediaType;

  const SelectMedia({Key? key, this.competitionId, this.mediaType})
      : super(key: key);

  @override
  State<SelectMedia> createState() => _SelectMediaState();
}

class _SelectMediaState extends State<SelectMedia> {
  final AddPostController addPostController = Get.find();
  late PostMediaType mediaType;

  @override
  void initState() {
    mediaType = widget.mediaType ?? PostMediaType.all;
    // addPostController.loadMedia(
    //     context: context,
    //     mediaType: mediaType,
    //     canSelectMultiple: widget.competitionId == null);

    super.initState();

    // Timer(const Duration(seconds: 1), () {
    //   addPostController.selectItem(
    //       index: 0, canSelectMultiple: widget.competitionId == null);
    // });
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
              const SizedBox(width: 20),
              const Spacer(),
              Image.asset(
                'assets/logo.png',
                width: 80,
                height: 25,
              ),
              const Spacer(),
              ThemeIconWidget(
                ThemeIcon.nextArrow,
                color: Theme.of(context).primaryColor,
                size: 27,
              ).ripple(() {
                if (addPostController.mediaList.isNotEmpty) {
                  Get.to(() => AddPostScreen(
                        items: addPostController.mediaList,
                        competitionId: widget.competitionId,
                      ));
                }
              }),
            ],
          ).hp(20),
          const SizedBox(height: 20),
          Stack(
            children: [
              AspectRatio(
                  aspectRatio: 1.1,
                  child: Obx(() {
                    return CarouselSlider(
                      items: [
                        for (Media media in addPostController.mediaList)
                          media.mediaType == GalleryMediaType.image
                              ? Image.file(media.file!, fit: BoxFit.cover)
                              : VideoPostTile(
                                  url: media.file!.path,
                                  isLocalFile: true,
                                  play: true,
                                )
                      ],
                      options: CarouselOptions(
                        aspectRatio: 1,
                        enlargeCenterPage: false,
                        enableInfiniteScroll: false,
                        height: double.infinity,
                        viewportFraction: 1,
                        onPageChanged: (index, reason) {
                          addPostController.updateGallerySlider(index);
                        },
                      ),
                    );
                  })),
              Obx(() {
                return addPostController.mediaList.length > 1
                    ? Positioned(
                        bottom: 10,
                        left: 0,
                        right: 0,
                        child: Align(
                            alignment: Alignment.center,
                            child: DotsIndicator(
                              dotsCount: addPostController.mediaList.length,
                              position: addPostController.currentIndex.value
                                  .toDouble(),
                              decorator: DotsDecorator(
                                  activeColor: Theme.of(context).primaryColor),
                            )))
                    : Container();
              })
            ],
          ).p16,
          Expanded(
              child: Obx(() => MediaPicker(
                    onPick: (selectedList) {
                      if (addPostController.mediaList.length < 10) {
                        addPostController.mediaSelected(selectedList);
                      }
                    },
                    onSelectMediaCount: (count) {
                      addPostController.mediaCountSelected(count);
                    },
                    capturedMedia: (media) async {
                      Get.to(() => AddPostScreen(
                            items: [media],
                            competitionId: widget.competitionId,
                          ));
                    },
                    mediaCount: addPostController.mediaCount.value,
                    mediaType: GalleryMediaType.all,
                    decoration: PickerDecoration(
                      actionBarPosition: ActionBarPosition.top,
                      blurStrength: 2,
                      completeText: 'Next',
                    ),
                  )))
          // Expanded(
          //   child: Obx(() => GridView.builder(
          //       padding: EdgeInsets.zero,
          //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //           crossAxisCount: _numberOfColumns),
          //       itemCount: addPostController.numberOfItems.value,
          //       itemBuilder: (context, index) {
          //         return _buildItem(index);
          //       }).hP16),
          // )
        ],
      ),
    );
  }

// _buildItem(int index) {
//   GalleryMedia item = addPostController.mediaList[index];
//   return GestureDetector(
//       onTap: () {
//         addPostController.selectItem(
//             index: index, canSelectMultiple: widget.competitionId == null);
//       },
//       child: Card(
//         elevation: 2.0,
//         child: Obx(() => Stack(children: [
//               Image.memory(
//                 item.mediaType == 1 ? item.bytes : item.thumbnailBytes!,
//                 fit: BoxFit.cover,
//                 height: double.infinity,
//                 width: double.infinity,
//               ).round(5),
//               item.mediaType == 2
//                   ? Positioned(
//                       top: 0,
//                       right: 0,
//                       left: 0,
//                       bottom: 0,
//                       child: Container(
//                         color: Colors.black38,
//                         child: const ThemeIconWidget(
//                           ThemeIcon.play,
//                           size: 40,
//                           color: Colors.white,
//                         ),
//                       ).round(5))
//                   : Container(),
//               addPostController.isSelected(item.id)
//                   ? Positioned(
//                       top: 5,
//                       right: 5,
//                       child: Container(
//                         height: 20,
//                         width: 20,
//                         color: Theme.of(context).primaryColor,
//                         child: const ThemeIconWidget(ThemeIcon.checkMark),
//                       ).circular)
//                   : Container(),
//             ])),
//       ));
// }
}
