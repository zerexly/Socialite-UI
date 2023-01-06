import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart' as read_more;

class PodcastShowEpisodeDetail extends StatefulWidget {
  final PodcastShowModel? podcastShowModel;

  const PodcastShowEpisodeDetail({Key? key, this.podcastShowModel})
      : super(key: key);

  @override
  State<PodcastShowEpisodeDetail> createState() =>
      _PodcastShowEpisodeDetailState();
}

class _PodcastShowEpisodeDetailState extends State<PodcastShowEpisodeDetail> {
  final PodcastStreamingController _podcastStreamingController = Get.find();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _podcastStreamingController.getPodcastShowsEpisode(
          podcastShowId: widget.podcastShowModel?.id);
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
                      context: context,
                      title: widget.podcastShowModel?.name ?? "")
                  .tp(50),
              divider(context: context).tP8,
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.vertical,
                  itemCount:
                      _podcastStreamingController.podcastShowEpisodes.length +
                          1,
                  itemBuilder: (BuildContext context, int index) {
                    return index == 0
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: 200,
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          widget.podcastShowModel?.image ?? "",
                                      fit: BoxFit.cover,
                                      width: MediaQuery.of(context).size.width,
                                      height: 200,
                                    )),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(widget.podcastShowModel?.name ?? "",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold))
                                          .bP4,
                                      read_more.ReadMoreText(
                                        widget.podcastShowModel?.description ??
                                            "",
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
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(LocalizationString.songs,
                                              style: TextStyle(
                                                  fontFamily: AppTheme.fontName,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20))
                                          .setPadding(top: 15)
                                    ]).setPadding(left: 15, right: 15, top: 15),
                              ])
                        : addRecord(index - 1);
                  },
                ),
              ),
            ]));
  }

  Widget addRecord(int index) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(6),
        leading: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: _podcastStreamingController
                  .podcastShowEpisodes[index].imageUrl,
              fit: BoxFit.cover,
              height: 50,
              width: MediaQuery.of(context).size.width / 4.5,
            ),
            const Positioned.fill(child: Icon(Icons.play_circle))
          ],
        ),
        title: Text(
            _podcastStreamingController.podcastShowEpisodes[index].name),
// subtitle: Text(_podcastStreamingController
//     .podcastShowEpisodes[index].ep ??
// ''),
        dense: true,
      ),
    ).setPadding(left: 16, right: 16, bottom: 5).round(10).ripple(() {
      Get.to(() => AudioSongPlayer(
          songsArray: _podcastStreamingController.podcastShowEpisodes,
          show: widget.podcastShowModel));
    });
  }
}
