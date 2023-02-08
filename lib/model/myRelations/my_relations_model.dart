class MyRelationsModel  {
int? id;
int? relationShipId;
int? userId;
int? status;
int? createdAt;
int? createdBy;
User? user;

MyRelationsModel(
    {this.id,
      this.relationShipId,
      this.userId,
      this.status,
      this.createdAt,
      this.createdBy,
      this.user});

MyRelationsModel.fromJson(Map<String, dynamic> json) {
id = json['id'];
relationShipId = json['relation_ship_id'];
userId = json['user_id'];
status = json['status'];
createdAt = json['created_at'];
createdBy = json['created_by'];
user = json['user'] != null ? new User.fromJson(json['user']) : null;
}

Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['id'] = this.id;
  data['relation_ship_id'] = this.relationShipId;
  data['user_id'] = this.userId;
  data['status'] = this.status;
  data['created_at'] = this.createdAt;
  data['created_by'] = this.createdBy;
  if (this.user != null) {
    data['user'] = this.user!.toJson();
  }
  return data;
}
}

class User {
  int? id;
  String? username;
  String? email;
  Null? bio;
  Null? sex;
  String? image;
  int? isReported;
  String? picture;
  Null? userStory;

  User(
      {this.id,
        this.username,
        this.email,
        this.bio,
        this.sex,
        this.image,
        this.isReported,
        this.picture,
        this.userStory});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    bio = json['bio'];
    sex = json['sex'];
    image = json['image'];
    isReported = json['is_reported'];
    picture = json['picture'];
    userStory = json['userStory'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['bio'] = this.bio;
    data['sex'] = this.sex;
    data['image'] = this.image;
    data['is_reported'] = this.isReported;
    data['picture'] = this.picture;
    data['userStory'] = this.userStory;
    return data;
  }
}