class ResOnCallConnectModel {
  String channel;
  String token;
  int id;

  ResOnCallConnectModel(
      {required this.channel, required this.token, required this.id});

  factory ResOnCallConnectModel.fromJson(dynamic json) {
    ResOnCallConnectModel resOnCallConnectModel = ResOnCallConnectModel(
        channel: json['channel'],
        token: json['token'],
        id: int.parse(json['id']));

    return resOnCallConnectModel;
  }

  Map<String, dynamic> toJson() => {
        'channel': channel,
        'token': token,
        'id': id,
      };
}
