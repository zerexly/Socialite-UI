class ResCancelCall {
  String msg;
  String role;
  int hotLinkId;
  bool isCallAccepted;

  ResCancelCall(
      {required this.msg,
      required this.role,
      required this.hotLinkId,
      required this.isCallAccepted});

  factory ResCancelCall.fromJson(dynamic json) {
    ResCancelCall resCancelCall = ResCancelCall(
        msg: json['channel'],
        role: json['role'],
        hotLinkId: json['hotLinkId'],
        isCallAccepted: json['isCallAccepted']);

    return resCancelCall;
  }

  Map<String, dynamic> toJson() => {
        'msg': msg,
        'role': role,
        'hotLinkId': hotLinkId,
        'isCallAccepted': isCallAccepted,
      };
}
