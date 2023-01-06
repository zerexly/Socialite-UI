import 'package:foap/helper/common_import.dart';
import 'package:just_audio/just_audio.dart' as just_audio;
import 'package:rxdart/rxdart.dart' as rxdart;

class AudioSongPlayer extends StatefulWidget {
  final List<PodcastShowSongModel>? songsArray;
  final PodcastShowModel? show;
  const AudioSongPlayer({Key? key, this.songsArray, this.show})
      : super(key: key);

  @override
  State<AudioSongPlayer> createState() => _AudioSongPlayerState();
}

class _AudioSongPlayerState extends State<AudioSongPlayer> {
  just_audio.AudioPlayer audioPlayer = just_audio.AudioPlayer();
  int currentSongIndex = 0;
  bool _favorite = false;
  bool _showList = false;

  @override
  void initState() {
    super.initState();
    currentSongIndex = 0;
    List<just_audio.AudioSource> audios = widget.songsArray
            ?.map((e) => just_audio.AudioSource.uri(Uri.parse(e.audioUrl)))
            .toList() ??
        [];
    audioPlayer.setAudioSource(just_audio.ConcatenatingAudioSource(children: audios));
    audioPlayer.play();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Stream<SeekbarData> get _seekbarDataStream =>
      rxdart.Rx.combineLatest2<Duration, Duration?, SeekbarData>(
          audioPlayer.positionStream, audioPlayer.durationStream, (
        Duration position,
        Duration? duration,
      ) {
        return SeekbarData(position, duration ?? Duration.zero);
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: widget.songsArray?[0].imageUrl ?? "",
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            // height: 230,
          ),
          ShaderMask(
              shaderCallback: (rect) {
                return LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white,
                      Colors.white.withOpacity(.5),
                      Colors.white.withOpacity(0.0),
                    ],
                    stops: const [
                      0.0,
                      0.4,
                      0.6
                    ]).createShader(rect);
              },
              blendMode: BlendMode.dstOut,
              child: (Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      Colors.black,
                      Colors.grey.withOpacity(0.8),
                    ])),
              ))),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.songsArray?[currentSongIndex].name ?? '',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(widget.show?.name ?? '',
                    maxLines: 2,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Colors.white,
                        )),
                const SizedBox(height: 10),
                StreamBuilder<SeekbarData>(
                    stream: _seekbarDataStream,
                    builder: (context, snapshot) {
                      final positionData = snapshot.data;
                      return SeekBar(
                          position: positionData?.position ?? Duration.zero,
                          duration: positionData?.duration ?? Duration.zero,
                          onChangedEnd: audioPlayer.seek);
                    }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: IconButton(
                          onPressed: () => setState(() {
                                _favorite = !_favorite;
                              }),
                          iconSize: 30,
                          icon: Icon(
                            _favorite
                                ? Icons.favorite
                                : Icons.favorite_border_outlined,
                            color: _favorite
                                ? Theme.of(context).primaryColor
                                : Colors.white,
                          )),
                    ),
                    StreamBuilder<just_audio.SequenceState?>(
                        stream: audioPlayer.sequenceStateStream,
                        builder: (context, index) {
                          return IconButton(
                              onPressed: () {
                                if (audioPlayer.hasPrevious) {
                                  currentSongIndex = currentSongIndex - 1;
                                  audioPlayer.seek(Duration.zero,
                                      index: currentSongIndex);
                                  setState(() {});
                                  // audioPlayer.seekToPrevious;
                                }
                              },
                              iconSize: 45,
                              icon: const Icon(
                                Icons.skip_previous,
                                color: Colors.white,
                              ));
                        }),
                    StreamBuilder(
                        stream: audioPlayer.playerStateStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final playerState = snapshot.data;
                            final processingState =
                                (playerState! as just_audio.PlayerState)
                                    .processingState;

                            if (processingState == just_audio.ProcessingState.loading ||
                                processingState == just_audio.ProcessingState.buffering) {
                              return Container(
                                width: 64.0,
                                height: 64.0,
                                margin: const EdgeInsets.all(10.0),
                                child: const CircularProgressIndicator(),
                              );
                            } else if (!audioPlayer.playing) {
                              return IconButton(
                                  onPressed: audioPlayer.play,
                                  iconSize: 75,
                                  icon: const Icon(
                                    Icons.play_circle,
                                    color: Colors.white,
                                  ));
                            } else if (processingState !=
                                just_audio.ProcessingState.completed) {
                              return IconButton(
                                  onPressed: audioPlayer.pause,
                                  iconSize: 75,
                                  icon: const Icon(
                                    Icons.pause_circle,
                                    color: Colors.white,
                                  ));
                            } else {
                              return IconButton(
                                  onPressed: () {
                                    currentSongIndex = 0;
                                    audioPlayer.seek(Duration.zero,
                                        index: currentSongIndex);
                                    setState(() {});
                                    // audioPlayer.seek(
                                    //     Duration.zero,
                                    //     index:
                                    //     audioPlayer.effectiveIndices!.first)
                                  },
                                  iconSize: 75,
                                  icon: const Icon(
                                    Icons.replay_circle_filled_outlined,
                                    color: Colors.white,
                                  ));
                            }
                          } else {
                            return const CircularProgressIndicator();
                          }
                        }),
                    StreamBuilder<just_audio.SequenceState?>(
                        stream: audioPlayer.sequenceStateStream,
                        builder: (context, index) {
                          return IconButton(
                              onPressed: () {
                                if (audioPlayer.hasNext) {
                                  currentSongIndex = currentSongIndex + 1;
                                  audioPlayer.seek(Duration.zero,
                                      index: currentSongIndex);
                                  // audioPlayer.seekToNext;
                                  setState(() {});
                                }
                              },
                              iconSize: 45,
                              icon: const Icon(
                                Icons.skip_next,
                                color: Colors.white,
                              ));
                        }),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: IconButton(
                          onPressed: () => setState(() {
                                _showList = !_showList;
                              }),
                          iconSize: 30,
                          icon: const Icon(
                            Icons.list,
                            color: Colors.white,
                          )),
                    )
                  ],
                ),
                addSongList()
              ],
            ),
          ),
        ],
      ),
    );
  }

  addSongList() {
    return AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: _showList
            ? MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 2 - 100,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.songsArray?.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Transform.translate(
                              offset: const Offset(0, 3),
                              child: Text(
                                (index + 1).toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(color: Colors.white),
                              )),
                          title: Transform.translate(
                              offset: const Offset(-30, 0),
                              child: Text(
                                widget.songsArray?[index].name ?? '',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(color: Colors.white),
                              )),
                          trailing: const Icon(Icons.favorite),
                          // subtitle: Transform.translate(
                          //     offset: const Offset(-30, 0),
                          //     child: Text( fetched_data[index]['singer'],
                          //       style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.white),
                          //     )),
                          selected: true,
                          onTap: () {
                            currentSongIndex = index;
                            setState(() {});
                            audioPlayer.seek(Duration.zero,
                                index: currentSongIndex);
                          },
                        );
                      }),
                ))
            : null);
  }
}
