import 'package:foap/controllers/podcast_streaming_controller.dart';
import 'package:foap/helper/common_import.dart';
import 'package:foap/screens/podcast/audio_song_player.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart' as read_more;
import '../../model/podcast_model.dart';

class PodcastShowDetail extends StatefulWidget {
  final PodcastModel? podcastModel;

  const PodcastShowDetail({Key? key, this.podcastModel}) : super(key: key);

  @override
  State<PodcastShowDetail> createState() => _PodcastShowDetailState();
}

class _PodcastShowDetailState extends State<PodcastShowDetail> {
  final PodcastStreamingController _podcastStreamingController = Get.find();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _podcastStreamingController.getPodcastShows(
          podcastId: widget.podcastModel?.id);
    });
    super.initState();
  }

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
                      imageUrl: widget.podcastModel?.image ?? "",
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
                child: GetBuilder<PodcastStreamingController>(
                    init: _podcastStreamingController,
                    builder: (ctx) {
                      return ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount:
                            _podcastStreamingController.podcastShows.length + 1,
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
                                                        .podcastModel?.image ??
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
                                                    widget.podcastModel?.name ??
                                                        "",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                read_more.ReadMoreText(
                                                  widget.podcastModel
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
                                        imageUrl: _podcastStreamingController
                                            .podcastShows[index - 1].image,
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
                                  title: Text(_podcastStreamingController
                                      .podcastShows[index - 1].name),
                                  subtitle: Text(_podcastStreamingController
                                      .podcastShows[index - 1].showTime),
                                  dense: true,
                                ),
                              ).round(10).ripple(() {
                                _podcastStreamingController
                                    .getPodcastShowsEpisode(
                                        podcastShowId:
                                            _podcastStreamingController
                                                .podcastShows[index - 1].id)
                                    .then((response) {
                                      List<PodcastShowSongModel> songs = response.podcastShowSongs;
                                      if (songs.isNotEmpty) {
                                        Get.to(() => AudioSongPlayer(songsArray: songs, show: _podcastStreamingController
                                            .podcastShows[index - 1]));
                                      }
                                });
                              }),
                      );
                    }),
              )),
            ],
          )),
    );
  }
}
