class TVBannersModel {
  int? id;
  String? name;
  String? coverImage;
  String? bannerType;
  int? startTime;
  int? endTime;
  int? referenceId;
  int? createdAt;
  int? updatedAt;
  String? coverImageUrl;

  TVBannersModel(
      {this.id,
        this.name,
        this.coverImage,
        this.bannerType,
        this.startTime,
        this.endTime,
        this.referenceId,
        this.createdAt,
        this.updatedAt,
        this.coverImageUrl});

  TVBannersModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    coverImage = json['cover_image'];
    bannerType = json['banner_type'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    referenceId = json['reference_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    coverImageUrl = json['coverImageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['cover_image'] = this.coverImage;
    data['banner_type'] = this.bannerType;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['reference_id'] = this.referenceId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['coverImageUrl'] = this.coverImageUrl;
    return data;
  }
}