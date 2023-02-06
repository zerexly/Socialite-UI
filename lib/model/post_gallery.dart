class PostGallery {
  int id;
  int postId;
  String fileName;
  String filePath;
  String? videoThumbnail;
  int mediaType;
  int type;
  int currentIndexOfMediaToShow = 0;

  PostGallery(
      {required this.id,
      required this.fileName,
      required this.filePath,
      required this.postId,
      required this.mediaType,
      required this.type,
      this.videoThumbnail});

  factory PostGallery.fromJson(dynamic json) {
    PostGallery galleryPost = PostGallery(
        id: json['id'],
        fileName: json['filename'] ?? "",
        filePath: json['filenameUrl'] ?? "",
        postId: json['post_id'],
        mediaType: json['media_type'],
        type: json['type'],
        videoThumbnail: json['videoThumbUrl']);

    return galleryPost;
  }

  String get thumbnail {
    return isVideoPost == true ? videoThumbnail! : filePath;
  }

  bool get isVideoPost {
    return mediaType == 2 || videoThumbnail != null;
  }
}
