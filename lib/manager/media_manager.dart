import 'package:foap/helper/common_import.dart';
import 'package:gallery_saver/gallery_saver.dart';

class MediaManager {
  saveChatMediaImage({
    required File image,
    required String roomId,
    required String localMessageId,
  }) {
    GallerySaver.saveImage(image.path, albumName: roomId).then((savedPath) {
    });
  }
}
