import 'package:foap/helper/common_import.dart';

class AudioChatTile extends StatefulWidget {
  final ChatMessageModel message;

  const AudioChatTile({Key? key, required this.message}) : super(key: key);

  @override
  State<AudioChatTile> createState() => _AudioChatTileState();
}

class _AudioChatTileState extends State<AudioChatTile> {
  @override
  void initState() {
    super.initState();
  }

  playAudio() {
    getIt<PlayerManager>().playAudio(widget.message);
  }

  stopAudio() {
    getIt<PlayerManager>().stopAudio();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
        key: UniqueKey(),
        valueListenable: getIt<PlayerManager>().playStateNotifier,
        builder: (_, value, __) {
          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  value == widget.message.id.toString()
                      ? const ThemeIconWidget(
                    ThemeIcon.stop,
                    color: Colors.white,
                    size: 30,
                  ).ripple(() {
                    stopAudio();
                  })
                      : const ThemeIconWidget(
                    ThemeIcon.play,
                    color: Colors.white,
                    size: 30,
                  ).ripple(() {
                    playAudio();
                  }),
                  const SizedBox(
                    width: 15,
                  ),
                  const SizedBox(
                    width: 230,
                    height: 20,
                    child: AudioProgressBar(),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              )
            ],
          );
        });
  }
}

class AudioProgressBar extends StatelessWidget {
  const AudioProgressBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PlayerManager>();
    return ValueListenableBuilder<ProgressBarState>(
      valueListenable: pageManager.progressNotifier,
      builder: (_, value, __) {
        return ProgressBar(
          thumbColor: Theme.of(context).backgroundColor,
          progressBarColor: Theme.of(context).backgroundColor,
          baseBarColor: Theme.of(context).backgroundColor.lighten(),
          thumbRadius: 8,
          barHeight: 2,
          progress: value.current,
          // buffered: value.buffered,
          total: value.total,
          timeLabelPadding: 5,
          timeLabelTextStyle: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(fontWeight: FontWeight.w900),
          // onSeek: pageManager.seek,
        );
      },
    );
  }
}
