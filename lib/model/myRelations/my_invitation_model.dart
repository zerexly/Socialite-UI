import 'package:foap/model/user_model.dart';

class MyInvitationsModel  {
  int? id;
  int? relationShipId;
  int? userId;
  int? status;
  int? createdAt;
  int? createdBy;
  RelationShip? relationShip;
  UserModel? createdByObj;

  MyInvitationsModel(
      {this.id,
        this.relationShipId,
        this.userId,
        this.status,
        this.createdAt,
        this.createdBy,
        this.relationShip,
        this.createdByObj});

  MyInvitationsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    relationShipId = json['relation_ship_id'];
    userId = json['user_id'];
    status = json['status'];
    createdAt = json['created_at'];
    createdBy = json['created_by'];
    relationShip = json['relationShip'] != null
        ? RelationShip.fromJson(json['relationShip'])
        : null;
    createdByObj = json['createdBy'] != null
        ? UserModel.fromJson(json['createdBy'])
        : null;
  }
}

class RelationShip {
  int? id;
  String? name;

  RelationShip({this.id, this.name});

  RelationShip.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

// class CreatedBy {
//   int? id;
//   String? username;
//   String? email;
//   String? bio;
//   String? sex;
//   String? image;
//   int? isReported;
//   String? picture;
//   String? userStory;
//   String? profileCategoryName;
//
//   CreatedBy(
//       {this.id,
//         this.username,
//         this.email,
//         this.bio,
//         this.sex,
//         this.image,
//         this.isReported,
//         this.picture,
//         this.userStory,
//         this.profileCategoryName});
//
//   CreatedBy.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     username = json['username'];
//     email = json['email'];
//     bio = json['bio'];
//     sex = json['sex'];
//     image = json['image'];
//     isReported = json['is_reported'];
//     picture = json['picture'];
//     userStory = json['userStory'];
//     profileCategoryName = json['profileCategoryName'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['username'] = username;
//     data['email'] = email;
//     data['bio'] = bio;
//     data['sex'] = sex;
//     data['image'] = image;
//     data['is_reported'] = isReported;
//     data['picture'] = picture;
//     data['userStory'] = userStory;
//     data['profileCategoryName'] = profileCategoryName;
//     return data;
//   }
// }