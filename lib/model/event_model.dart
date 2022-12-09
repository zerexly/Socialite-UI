class EventModel {
  int categoryId;
  int id;
  String name;
  String desc;
  bool isJoined;
  int createdBy;
  int totalMembers;
  bool isFavourite;

  String address;

  String image;
  String imageName;

  String sponsorImage;
  String sponsorName;

  EventModel({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.desc,
    required this.isJoined,
    required this.image,
    required this.imageName,
    required this.createdBy,
    required this.totalMembers,
    required this.isFavourite,
    required this.address,
    required this.sponsorImage,
    required this.sponsorName,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
        id: json["id"],
        categoryId: json["category_id"],
        name: json["name"],
        image: json["imageUrl"],
        imageName: json["image"],
        desc: json["description"],
        isJoined: json["is_joined"] == 1,
        createdBy: json["created_by"],
        totalMembers: json["totalJoinedUser"],
        address: json["address"],
        sponsorImage: json["sponsorImage"],
        sponsorName: json["sponsorName"],
        isFavourite: json["is_favourite"] == 1,
      );
}
