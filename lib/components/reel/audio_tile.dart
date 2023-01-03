import 'package:foap/helper/common_import.dart';

class AudioTile extends StatelessWidget {
  final ReelMusicModel audio;
  final bool isPlaying;
  final VoidCallback playCallBack;
  final VoidCallback stopBack;
  final VoidCallback useAudioBack;

  const AudioTile(
      {Key? key,
      required this.audio,
      required this.isPlaying,
      required this.playCallBack,
      required this.useAudioBack,
      required this.stopBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CachedNetworkImage(
            imageUrl: audio.thumbnail,
            fit: BoxFit.cover,
            height: 50,
            width: 50,
          ).round(10),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                audio.name,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text(
                    audio.artists,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).dividerColor.darken(),
                        fontWeight: FontWeight.w500),
                  ),
                  Container(
                    height: 5,
                    width: 5,
                    color: Theme.of(context).dividerColor,
                  ).circular.hP8,
                  Text(
                    '${audio.numberOfReelsMade.formatNumber} ${LocalizationString.reels}',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).dividerColor.darken(),
                        fontWeight: FontWeight.w500),
                  ),
                  Container(
                    height: 5,
                    width: 5,
                    color: Theme.of(context).dividerColor,
                  ).circular.hP8,
                  Text(
                    audio.duration.formatTime,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).dividerColor.darken(),
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ).ripple(() {
            useAudioBack();
          }),
          const Spacer(),
          if (isPlaying)
            Container(
                child: Lottie.asset('assets/lottie/audio_playing.json').p4.rP8),
          Container(
            child: ThemeIconWidget(
              isPlaying ? ThemeIcon.pause : ThemeIcon.play,
              size: 20,
            ).p4,
          ).borderWithRadius(context: context, value: 2, radius: 20).ripple(() {
            if (isPlaying) {
              stopBack();
            } else {
              playCallBack();
            }
          })
        ],
      ),
    );
  }
}
