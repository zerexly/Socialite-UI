import 'package:foap/helper/common_import.dart';


///This class will contain the necessary data of selected media
class Media {
  ///File saved on local storage
  File? file;

  ///Unique id to identify
  String? id;

  ///A low resolution image to show as preview
  Uint8List? thumbnail;

  // ///The image file in bytes format
  Uint8List? mediaByte;

  ///Image Dimensions
  Size? size;

  ///Creation time of the media file on local storage
  DateTime? creationTime;

  ///media name or title
  String? title;

  ///Type of the media, Image/Video
  GalleryMediaType? mediaType;

  ///File size
  int? fileSize;

  int get mediaTypeId {
    if (mediaType == GalleryMediaType.photo) {
      return 1;
    }
    if (mediaType == GalleryMediaType.video) {
      return 2;
    }
    if (mediaType == GalleryMediaType.audio) {
      return 3;
    }
    if (mediaType == GalleryMediaType.pdf) {
      return 4;
    }
    if (mediaType == GalleryMediaType.ppt) {
      return 5;
    }
    if (mediaType == GalleryMediaType.doc) {
      return 6;
    }
    if (mediaType == GalleryMediaType.xls) {
      return 7;
    }
    return 1;
  }

  Media({
    this.id,
    this.file,
    this.thumbnail,
    this.mediaByte,
    this.size,
    this.creationTime,
    this.title,
    this.mediaType,
    this.fileSize,
  });
}

