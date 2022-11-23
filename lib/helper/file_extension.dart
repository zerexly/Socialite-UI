import 'package:foap/helper/common_import.dart';
import 'package:mime/mime.dart';

extension FileExtension on File {
  GalleryMediaType get mediaType {
    final mimeType = lookupMimeType(path)!.toLowerCase();

    switch (mimeType) {
      case 'image/png':
        return GalleryMediaType.photo;
      case 'image/jpg':
        return GalleryMediaType.photo;
      case 'image/jpeg':
        return GalleryMediaType.photo;

      case 'video/mp4':
        return GalleryMediaType.video;
      case 'video/mpeg':
        return GalleryMediaType.video;

      case 'audio/mpeg':
        return GalleryMediaType.audio;

      case 'application/pdf':
        return GalleryMediaType.pdf;

      case 'application/msword':
        return GalleryMediaType.doc;
      case 'application/vnd.openxmlformats-officedocument.wordprocessingml.template':
        return GalleryMediaType.doc;
      case 'application/vnd.openxmlformats-officedocument.wordprocessingml.document':
        return GalleryMediaType.doc;

      case 'application/vnd.ms-excel':
        return GalleryMediaType.xls;

      case 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet':
        return GalleryMediaType.xls;

      case 'application/vnd.ms-powerpoint':
        return GalleryMediaType.ppt;
      case 'application/vnd.openxmlformats-officedocument.presentationml.presentation':
        return GalleryMediaType.ppt;

      case 'text/plain':
        return GalleryMediaType.txt;
    }
    return GalleryMediaType.photo;
  }
}
