import 'package:foap/helper/common_import.dart';

class MyRelationsModel {
  int? id;
  int? relationShipId;
  int? userId;
  int? status;
  int? createdAt;
  int? createdBy;
  UserModel? user;

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
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['relation_ship_id'] = relationShipId;
    data['user_id'] = userId;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['created_by'] = createdBy;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}
