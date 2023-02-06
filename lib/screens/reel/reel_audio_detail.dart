import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class ReelAudioDetail extends StatefulWidget {
  final ReelMusicModel audio;

  const ReelAudioDetail({Key? key, required this.audio}) : super(key: key);

  @override
  State<ReelAudioDetail> createState() => _ReelAudioDetailState();
}

class _ReelAudioDetailState extends State<ReelAudioDetail> {
  final ReelsController _reelsController = Get.find();

  @override
  void initState() {
    _reelsController.getReelsWithAudio(widget.audio.id);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _reelsController.clearReelsWithAudio();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Column(children: [
          const SizedBox(
            height: 50,
          ),
          backNavigationBar(context: context, title: LocalizationString.audio),
          divider(context: context).tP8,
          Row(
            children: [
              CachedNetworkImage(
                      height: 70, width: 70, imageUrl: widget.audio.thumbnail)
                  .round(10),
              const SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.audio.name,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.audio.artists,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    '${widget.audio.numberOfReelsMade.formatNumber} ${LocalizationString.reels}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.w400),
                  )
                ],
              )
            ],
          ).p16,
          Expanded(
              child: GetBuilder<ReelsController>(
                  init: _reelsController,
                  builder: (ctx) {
                    return GridView.builder(
                        itemCount: _reelsController.filteredMoments.length,
                        padding: const EdgeInsets.only(top: 20, bottom: 50),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 2.0,
                                mainAxisSpacing: 2.0,
                                childAspectRatio: 0.7),
                        itemBuilder: (ctx, index) {
                          PostModel reel =
                              _reelsController.filteredMoments[index];
                          return CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: reel.gallery.first.thumbnail)
                              .ripple(() {
                            Get.to(() => ReelsList(
                                audioId: widget.audio.id, index: index));
                          });
                        });
                  }))
        ]));
  }
}
