class ResCallAcceptModel {
  String? channel;
  String? token;
  int? id;
  int? otherUserId;

  ResCallAcceptModel(
      { this.channel,  this.token,  this.id,  this.otherUserId});

  factory ResCallAcceptModel.fromJson(dynamic json) {
    ResCallAcceptModel resCallAcceptModel = ResCallAcceptModel(
        channel: json['channel'],
        token: json['token'],
        id: json['id'],
        otherUserId: int.parse(json['otherUserId'])
    );

    return resCallAcceptModel;
  }

  Map<String, dynamic> toJson() =>
      {
        'channel': channel,
        'token': token,
        'id': id,
        'otherUserId': otherUserId,
      };
}
