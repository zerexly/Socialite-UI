class ReelMusicModel {
  int id;
  String name;
  String artists;
  String url;
  int numberOfReelsMade;
  int duration;

  ReelMusicModel({
    required this.id,
    // required this.isReported,
    required this.name,
    required this.artists,
    required this.url,
    required this.numberOfReelsMade,
    required this.duration,
  });

  factory ReelMusicModel.fromJson(dynamic json) {
    ReelMusicModel model = ReelMusicModel(
      id: json['id'],
      // isReported: json['is_reported'],
      name: json['name'],
      artists: json['artists'],
      url: json['url'],
      numberOfReelsMade: json['numberOfReelsMade'],
      duration: json['duration'],
    );

    return model;
  }
}
