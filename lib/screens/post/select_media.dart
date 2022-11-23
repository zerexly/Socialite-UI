import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class SelectMedia extends StatefulWidget {
  final int? competitionId;
  final int? clubId;
  final PostMediaType? mediaType;

  const SelectMedia({Key? key, this.competitionId, this.mediaType, this.clubId})
      : super(key: key);

  @override
  State<SelectMedia> createState() => _SelectMediaState();
}

class _SelectMediaState extends State<SelectMedia> {
  final SelectPostMediaController _selectPostMediaController =
      SelectPostMediaController();
  late PostMediaType mediaType;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _selectPostMediaController.clear();
    });
    mediaType = widget.mediaType ?? PostMediaType.all;

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
                color: Theme.of(context).primaryColor,
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
              ThemeIconWidget(
                ThemeIcon.nextArrow,
                color: Theme.of(context).primaryColor,
                size: 27,
              ).ripple(() {
                if (_selectPostMediaController.selectedMediaList.isNotEmpty) {
                  Get.to(() => AddPostScreen(
                        items: _selectPostMediaController.selectedMediaList,
                        competitionId: widget.competitionId,
                        clubId: widget.clubId,
                      ));
                }
              }),
            ],
          ).hp(20),
          const SizedBox(height: 20),
          Stack(
            children: [
              AspectRatio(
                  aspectRatio: 1.2,
                  child: Obx(() {
                    return CarouselSlider(
                      items: [
                        for (Media media
                            in _selectPostMediaController.selectedMediaList)
                          media.mediaType == GalleryMediaType.photo
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
                          _selectPostMediaController.updateGallerySlider(index);
                        },
                      ),
                    );
                  })),
              Obx(() {
                return _selectPostMediaController.selectedMediaList.length > 1
                    ? Positioned(
                        bottom: 10,
                        left: 0,
                        right: 0,
                        child: Align(
                            alignment: Alignment.center,
                            child: DotsIndicator(
                              dotsCount: _selectPostMediaController
                                  .selectedMediaList.length,
                              position: _selectPostMediaController
                                  .currentIndex.value
                                  .toDouble(),
                              decorator: DotsDecorator(
                                  activeColor: Theme.of(context).primaryColor),
                            )))
                    : Container();
              })
            ],
          ).p16,
          Expanded(
              child: CustomGalleryPicker(
            hideMultiSelection: widget.competitionId != null,
            mediaType: mediaType,
            mediaSelectionCompletion: (medias) {
              _selectPostMediaController.mediaSelected(medias);
            },
            mediaCapturedCompletion: (media) {
              Get.to(() => AddPostScreen(
                    items: [media],
                    competitionId: widget.competitionId,
                    clubId: widget.clubId,
                  ));
            },
          ))
        ],
      ),
    );
  }
}
