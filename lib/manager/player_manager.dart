import 'package:foap/helper/common_import.dart';
import 'package:just_audio/just_audio.dart';

enum PlayStateState { paused, playing, loading, idle }

class PlayerManager {
  final player = AudioPlayer();
  final playStateNotifier = ValueNotifier<String?>(null);
  final progressNotifier = ProgressNotifier();

  Duration totalDuration = const Duration(seconds: 0);
  Duration currentPosition = const Duration(seconds: 0);

  playAudio(ChatMessageModel message) async {
    playStateNotifier.value = message.id.toString();

    await player.setUrl(message.mediaContent.audio!);

    player.play();
    listenToStates();
  }

  listenToStates() {
    player.positionStream.listen((event) {
      currentPosition = event;
      progressNotifier.value = ProgressBarState(current: currentPosition, total: totalDuration);
    });

    player.durationStream.listen((event) {
      totalDuration = event!;
    });

    player.playerStateStream.listen((state) {
      if (state.playing) {
      } else {}
      switch (state.processingState) {
        case ProcessingState.idle:{
            return;
          }
        case ProcessingState.loading:
          return;
        case ProcessingState.buffering:
          return;
        case ProcessingState.ready:
          return;
        case ProcessingState.completed:
          playStateNotifier.value = null;

          return;
      }
    });
  }

  stopAudio() {
    player.stop();
    playStateNotifier.value = null;
  }
}
