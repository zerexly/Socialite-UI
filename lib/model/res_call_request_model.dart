class ResCallRequestModel {
  int? id;
  String? channel;
  String? token;

  ResCallRequestModel({ this.id,  this.channel,  this.token});

  factory ResCallRequestModel.fromJson(dynamic json) {
    ResCallRequestModel resCallRequestModel = ResCallRequestModel(
        id: int.parse(json['id']),
        channel: json['channel'],
        token: json['token'],
    );

    return resCallRequestModel;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'channel': channel,
        'token': token,
      };
}
