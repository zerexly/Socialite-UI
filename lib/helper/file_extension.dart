import 'dart:io';
import 'package:foap/components/media_selector/enums.dart';
import 'package:mime/mime.dart';

extension FileExtension on File {
  GalleryMediaType get mediaType {
    final mimeType = lookupMimeType(path)!.toLowerCase();

    switch (mimeType){
      case 'image/png':
        return GalleryMediaType.image;
      case 'image/jpg':
        return GalleryMediaType.image;
      case 'image/jpeg':
        return GalleryMediaType.image;
      case 'video/mp4':
        return GalleryMediaType.video;
      case 'video/mpeg':
        return GalleryMediaType.video;
    }
    return GalleryMediaType.image;
  }
}
