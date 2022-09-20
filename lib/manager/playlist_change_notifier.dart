import 'package:foap/helper/common_import.dart';

class PlaylistChangeNotifier extends ValueNotifier<List<ChatMessageModel>> {
  PlaylistChangeNotifier() : super(_initialValue);
  static final _initialValue = [
    ChatMessageModel()
  ];
}
