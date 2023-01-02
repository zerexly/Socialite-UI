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

  // @override
  // Widget build(BuildContext context) {
  //   return SafeArea(
  //     child: Scaffold(
  //         backgroundColor: Theme.of(context).backgroundColor,
  //         body: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             SizedBox(
  //                 width: MediaQuery.of(context).size.width,
  //                 height: 200,
  //                 child: Stack(children: [
  //                   CachedNetworkImage(
  //                     imageUrl: widget.tvModel?.image ?? "",
  //                     fit: BoxFit.cover,
  //                     width: MediaQuery.of(context).size.width,
  //                     height: 230,
  //                   ),
  //                   IconButton(
  //                     icon: const Icon(Icons.arrow_back, color: Colors.white),
  //                     onPressed: () => Navigator.of(context).pop(),
  //                   )
  //                 ])),
  //             Padding(
  //                 padding: const EdgeInsets.all(10.0),
  //                 child: SingleChildScrollView(
  //                     child: Column(children: [
  //                   Row(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: <Widget>[
  //                         Padding(
  //                             padding: const EdgeInsets.only(right: 5),
  //                             child: CachedNetworkImage(
  //                               imageUrl: widget.tvModel?.image ?? "",
  //                               fit: BoxFit.cover,
  //                               width: 85,
  //                               height: 110,
  //                             )),
  //                         Flexible(
  //                             child: Column(
  //                                 crossAxisAlignment: CrossAxisAlignment.start,
  //                                 children: [
  //                               Text(widget.tvModel?.name ?? "",
  //                                   style:
  //                                       const TextStyle(fontWeight: FontWeight.bold)),
  //                               readMore.ReadMoreText(
  //                                 widget.tvModel?.description ?? "",
  //                                 trimLines: 2,
  //                                 trimMode: readMore.TrimMode.Line,
  //                                 colorClickableText: Colors.white,
  //                                 trimCollapsedText: 'Show more',
  //                                 trimExpandedText: '    Show less',
  //                                 moreStyle: const TextStyle(
  //                                     fontSize: 14,
  //                                     fontWeight: FontWeight.bold),
  //                                 lessStyle: const TextStyle(
  //                                     fontSize: 14,
  //                                     fontWeight: FontWeight.bold),
  //                               )
  //                             ]))
  //                       ]),
  //                 ]))),
  //             Padding(
  //               padding: const EdgeInsets.only(top: 10.0, bottom: 0, left: 10.0, right: 10.0),
  //               child: Text("More Shows",
  //                   style: TextStyle(
  //                       fontFamily: AppTheme.fontName,
  //                       color: Theme.of(context).primaryColor,
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 20)),
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.all(10.0),
  //               child: GetBuilder<TvStreamingController>(
  //                   init: _tvStreamingController,
  //                   builder: (ctx) {
  //                     return Expanded(
  //                         child: ListView.builder(
  //                       shrinkWrap: true,
  //                       scrollDirection: Axis.vertical,
  //                       itemCount: _tvStreamingController.tvShows.length,
  //                       itemBuilder: (context, index) => Card(
  //                         child: ListTile(
  //                           contentPadding: const EdgeInsets.all(0),
  //                           leading: Stack(
  //                             children: [
  //                               CachedNetworkImage(
  //                                 imageUrl: _tvStreamingController
  //                                         .tvShows[index].imageUrl ??
  //                                     "",
  //                                 fit: BoxFit.cover,
  //                                 height: 50,
  //                                 width: MediaQuery.of(context).size.width / 4.5,
  //                               ),
  //                               const Positioned.fill(child: Icon(Icons.play_circle))
  //                             ],
  //                           ),
  //                           title: Text(
  //                               _tvStreamingController.tvShows[index].name ?? ""),
  //                           subtitle: const Text("25-12-2022"),
  //                           dense: true,
  //                         ),
  //                       ),
  //                     ));
  //                   }),
  //             ),
  //           ],
  //         )),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  child: Stack(children: [
                    CachedNetworkImage(
                      imageUrl: widget.tvModel?.image ?? "",
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                      height: 230,
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  ])),
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GetBuilder<TvStreamingController>(
                        init: _tvStreamingController,
                        builder: (ctx) {
                          return ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount:
                            _tvStreamingController.tvShows.length + 1,
                            itemBuilder: (context, index) => index == 0
                                ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                right: 5),
                                            child: CachedNetworkImage(
                                              imageUrl: widget
                                                  .tvModel?.image ??
                                                  "",
                                              fit: BoxFit.cover,
                                              width: 85,
                                              height: 110,
                                            )),
                                        Flexible(
                                            child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      widget.tvModel?.name ??
                                                          "",
                                                      style: const TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold)),
                                                  read_more.ReadMoreText(
                                                    widget.tvModel
                                                        ?.description ??
                                                        "",
                                                    trimLines: 2,
                                                    trimMode:
                                                    read_more.TrimMode.Line,
                                                    colorClickableText:
                                                    Colors.white,
                                                    trimCollapsedText:
                                                    'Show more',
                                                    trimExpandedText:
                                                    '    Show less',
                                                    moreStyle: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                    lessStyle: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  )
                                                ])),
                                      ]),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15.0, bottom: 2),
                                    child: Text("Albums",
                                        style: TextStyle(
                                            fontFamily: AppTheme.fontName,
                                            color: Theme.of(context)
                                                .primaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20)),
                                  )
                                ])
                                : Card(
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(0),
                                leading: Stack(
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: _tvStreamingController
                                          .tvShows[index - 1].imageUrl ?? '',
                                      fit: BoxFit.cover,
                                      height: 50,
                                      width:
                                      MediaQuery.of(context).size.width /
                                          4.5,
                                    ),
                                    const Positioned.fill(
                                        child: Icon(Icons.play_circle))
                                  ],
                                ),
                                title: Text(_tvStreamingController
                                    .tvShows[index - 1].name ?? ''),
                                subtitle: Text(_tvStreamingController
                                    .tvShows[index - 1].showTime ?? ''),
                                dense: true,
                              ),
                            ).round(10).ripple(() {
                              // _tvStreamingController
                              //     .getPodcastShowsEpisode(
                              //     podcastShowId:
                              //     _tvStreamingController
                              //         .podcastShows[index - 1].id)
                              //     .then((response) {
                              //   List<PodcastShowSongModel> songs = response.podcastShowSongs;
                              //   if (songs.isNotEmpty) {
                              //     Get.to(() => AudioSongPlayer(songsArray: songs, show: _tvStreamingController
                              //         .podcastShows[index - 1]));
                              //   }
                              // });
                            }),
                          );
                        }),
                  )),
            ],
          )),
    );
  }
}