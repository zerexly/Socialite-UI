import 'package:foap/helper/common_import.dart';
import 'package:foap/screens/tvs/tv_show_detail.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart' as read_more;
import 'package:foap/model/live_tv_model.dart';

class TVChannelDetail extends StatefulWidget {
  final TvModel tvModel;

  const TVChannelDetail({Key? key, required this.tvModel}) : super(key: key);

  @override
  State<TVChannelDetail> createState() => _TVChannelDetailState();
}

class _TVChannelDetailState extends State<TVChannelDetail> {
  final TvStreamingController _tvStreamingController = Get.find();

  @override
  void initState() {
    if (widget.tvModel.isLiveBroadcasting == true) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft
      ]);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Add Your Code here.
        if (MediaQuery.of(context).orientation == Orientation.portrait) {
          AutoOrientation.portraitAutoMode();
        } else {
          AutoOrientation.landscapeAutoMode();
        }
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tvStreamingController.setCurrentViewingTv(widget.tvModel);
      _tvStreamingController.getTvShows(liveTvId: widget.tvModel.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      if (orientation == Orientation.portrait) {
        AutoOrientation.portraitAutoMode();
      } else {
        AutoOrientation.landscapeAutoMode();
      }
      return Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ThemeIconWidget(
                    ThemeIcon.backArrow,
                    size: 18,
                    color: Theme.of(context).iconTheme.color,
                  ).ripple(() {
                    Get.back();
                  }),
                  Text(
                    widget.tvModel.name,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  Obx(() => ThemeIconWidget(
                        _tvStreamingController.currentViewingTv.value?.isFav ==
                                1
                            ? ThemeIcon.favFilled
                            : ThemeIcon.fav,
                        size: 18,
                        color: _tvStreamingController
                                    .currentViewingTv.value?.isFav ==
                                1
                            ? Colors.red
                            : Theme.of(context).iconTheme.color,
                      ).ripple(() {
                        _tvStreamingController.favUnfavTv(_tvStreamingController
                            .currentViewingTv.value!);
                      })),
                ],
              ).setPadding(left: 16, right: 16, top: 50, bottom: 16),
              divider(context: context).tP8,
              Expanded(
                child: ListView(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            widget.tvModel.isLiveBroadcasting == true
                                ? SocialifiedVideoPlayer(
                                    tvModel: widget.tvModel,
                                    url: widget.tvModel.tvUrl,
                                    play: true,
                                    orientation: orientation,
                                    isPlayingTv: true,
                                    // showMinimumHeight: isKeyboardVisible,
                                  )
                                : SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: 250,
                                    child: CachedNetworkImage(
                                      imageUrl: widget.tvModel.image,
                                      fit: BoxFit.cover,
                                      width: MediaQuery.of(context).size.width,
                                      height: 200,
                                    )),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.tvModel.name,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold))
                                      .bP4,
                                  read_more.ReadMoreText(
                                      widget.tvModel.description,
                                      trimLines: 2,
                                      trimMode: read_more.TrimMode.Line,
                                      colorClickableText: Colors.white,
                                      trimCollapsedText:
                                          LocalizationString.showMore,
                                      trimExpandedText:
                                          '    ${LocalizationString.showLess}',
                                      moreStyle: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                      lessStyle: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold)),
                                  Text('${LocalizationString.moreFrom} ${widget.tvModel.name}',
                                          style: TextStyle(
                                              fontFamily: AppTheme.fontName,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20))
                                      .setPadding(top: 15)
                                ]).setPadding(left: 15, right: 15, top: 15),
                          ]),
                      GetBuilder<TvStreamingController>(
                          init: _tvStreamingController,
                          builder: (ctx) {
                            return GridView.builder(
                                itemCount:
                                    _tvStreamingController.tvShows.length,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                // You won't see infinite size error
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 10.0,
                                        mainAxisSpacing: 10.0,
                                        mainAxisExtent: 180),
                                itemBuilder: (ctx, index) {
                                  MediaModel model = MediaModel(
                                      _tvStreamingController
                                          .tvShows[index].name,
                                      _tvStreamingController
                                          .tvShows[index].imageUrl,
                                      _tvStreamingController
                                          .tvShows[index].showTime);
                                  return MediaCard(model: model).ripple(() {
                                    Get.to(() => TVShowDetail(
                                        tvModel: widget.tvModel,
                                        showModel: _tvStreamingController
                                            .tvShows[index]));
                                  });
                                }).setPadding(left: 15, right: 15, bottom: 50);
                          }),
                    ]),
              ),
            ],
          ));
    });
  }
}
