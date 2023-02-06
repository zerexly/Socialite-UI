import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';
import 'package:foap/model/live_tv_model.dart';

import '../../model/tv_show_model.dart';

class TVShowDetail extends StatefulWidget {
  final TvModel tvModel;
  final TVShowModel showModel;

  const TVShowDetail({Key? key, required this.tvModel, required this.showModel})
      : super(key: key);

  @override
  State<TVShowDetail> createState() => _TVShowDetailState();
}

class _TVShowDetailState extends State<TVShowDetail> {
  final TvStreamingController _liveTvStreamingController = Get.find();
  TextEditingController messageTextField = TextEditingController();

  @override
  void initState() {
    super.initState();
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

      _liveTvStreamingController.getTvShowEpisodes(showId: widget.showModel.id);
    });
  }

  @override
  void dispose() {
    AutoOrientation.portraitAutoMode();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      if (orientation == Orientation.portrait) {
        AutoOrientation.portraitAutoMode();
      } else {
        AutoOrientation.landscapeAutoMode();
      }
      return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
        return Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: Column(
            children: [
              if (orientation == Orientation.portrait)
                Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    backNavigationBar(
                      context: context,
                      title: widget.showModel.name!,
                    ),
                    divider(context: context).tP8,
                  ],
                ),
              Obx(() {
                return _liveTvStreamingController.selectedEpisode.value != null
                    ? SocialifiedVideoPlayer(
                        tvModel: widget.tvModel,
                        url: _liveTvStreamingController
                            .selectedEpisode.value!.videoUrl!,
                        play: false,
                        orientation: orientation,

                        // showMinimumHeight: isKeyboardVisible,
                      )
                    : Container();
              }),
              // orientation == Orientation.portrait &&
              //         widget.tvModel.isLiveBroadcasting
              //     ? segmentView().tP16
              //     :
              if (orientation == Orientation.portrait)
                Expanded(child: detailView()),
            ],
          ),
        );
      });
    });
  }

  // Widget segmentView() {
  //   List<String> tabs = [
  //     LocalizationString.info,
  //     LocalizationString.chat,
  //   ];
  //   return DefaultTabController(
  //     length: tabs.length,
  //     initialIndex: 0,
  //     child: SizedBox(
  //       height: 460,
  //       child: Column(children: [
  //         TabBar(
  //           labelColor: Colors.white,
  //           unselectedLabelColor: Theme.of(context).dividerColor,
  //           tabs: List.generate(tabs.length, (int index) {
  //             return Tab(
  //               text: tabs[index],
  //             );
  //           }),
  //         ),
  //         const SizedBox(
  //           height: 10,
  //         ),
  //         Expanded(child: TabBarView(children: [detailView(), liveChatView()]))
  //       ]),
  //     ),
  //   );
  // }

  Widget detailView() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      scrollDirection: Axis.vertical,
      itemCount: _liveTvStreamingController.tvEpisodes.length + 1,
      itemBuilder: (BuildContext context, int index) {
        return index == 0
            ? episodeInfo()
            : episodeTile(_liveTvStreamingController.tvEpisodes[index - 1]);
      },
    );
  }

  episodeTile(TVShowEpisodeModel episode) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(6),
        leading: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: episode.imageUrl ?? '',
              fit: BoxFit.cover,
              height: 50,
              width: MediaQuery.of(context).size.width / 4.5,
            ),
            const Positioned.fill(child: Icon(Icons.play_circle))
          ],
        ),
        title: Text(episode.name ?? ''),
        dense: true,
      ).ripple(() {
        _liveTvStreamingController.playEpisode(episode);
      }),
    ).setPadding(left: 16, right: 16, bottom: 5).round(10);
  }

  Widget episodeInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
                    color: Theme.of(context).primaryColor,
                    child: Text(widget.showModel.ageGroup ?? "")
                        .setPadding(left: 10, right: 10, top: 5, bottom: 5))
                .round(10),
            const SizedBox(width: 10),
            Container(
                    color: Theme.of(context).primaryColor,
                    child: Text(widget.showModel.language ?? "")
                        .setPadding(left: 10, right: 10, top: 5, bottom: 5))
                .round(10),
          ],
        ).bP25,
        Row(
          children: [
            CachedNetworkImage(
              imageUrl: widget.showModel.imageUrl ?? '',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ).round(10),
            const SizedBox(
              width: 10,
            ),
            Column(
              children: [
                Text(
                  widget.showModel.name ?? '',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.w700),
                  // maxLines: 3,
                ),
                // Text(
                //   widget.tvModel.description,
                //   style: Theme.of(context).textTheme.bodySmall,
                //   // maxLines: 3,
                // )
              ],
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          widget.showModel.description ?? '',
          style: Theme.of(context).textTheme.bodyMedium,
          // maxLines: 3,
        ),
      ],
    ).p16;
  }
}
