import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart' as read_more;

class TVShowDetail extends StatefulWidget {
  final TvModel? tvModel;

  const TVShowDetail({Key? key, this.tvModel}) : super(key: key);

  @override
  State<TVShowDetail> createState() => _TVShowDetailState();
}

class _TVShowDetailState extends State<TVShowDetail> {
  final TvStreamingController _tvStreamingController = Get.find();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tvStreamingController.getTvShows(liveTvId: widget.tvModel?.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            backNavigationBar(
                    context: context, title: widget.tvModel?.name ?? "")
                .tp(50),
            divider(context: context).tP8,
            Expanded(
              child: ListView(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.vertical,
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 200,
                              child: CachedNetworkImage(
                                imageUrl: widget.tvModel?.image ?? "",
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width,
                                height: 200,
                              )),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.tvModel?.name ?? "",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold))
                                    .bP4,
                                read_more.ReadMoreText(
                                    widget.tvModel?.description ?? "",
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
                                Text('${LocalizationString.moreFrom} ${widget.tvModel?.name ?? ""}',
                                        style: TextStyle(
                                            fontFamily: AppTheme.fontName,
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20))
                                    .setPadding(top: 15)
                              ]).setPadding(left: 15, right: 15, top: 15),
                        ]),
                    GetBuilder<TvStreamingController>(
                        init: _tvStreamingController,
                        builder: (ctx) {
                          return GridView.builder(
                              itemCount: _tvStreamingController.tvShows.length,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap:
                                  true, // You won't see infinite size error
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10.0,
                                      mainAxisSpacing: 10.0,
                                      mainAxisExtent: 180),
                              itemBuilder: (ctx, index) {
                                MediaModel model = MediaModel(
                                    _tvStreamingController.tvShows[index].name,
                                    _tvStreamingController.tvShows[index].imageUrl,
                                    _tvStreamingController
                                        .tvShows[index].showTime);
                                return MediaCard(model: model).ripple(() {
                                  Get.to(() => LiveTVStreaming(tvModel: widget.tvModel!,
                                      showModel: _tvStreamingController
                                          .tvShows[index]));
                                });
                              }).setPadding(left: 15, right: 15, bottom: 50);
                        }),
                  ]),
            ),
          ],
        ));
  }
}
