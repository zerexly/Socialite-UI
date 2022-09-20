import 'dart:convert';
import 'package:foap/screens/login_sign_up/instagram_constant.dart';
import 'package:http/http.dart' as http;

class InstagramModel {
  List<String> userFields = ['id', 'username'];

  String? authorizationCode;
  String? accessToken;
  String? userID;
  String? username;

  void getAuthorizationCode(String url) {
    authorizationCode = url
        .replaceAll('${InstagramConstant.redirectUri}?code=', '')
        .replaceAll('#_', '');
  }

  Future<bool> getTokenAndUserID() async {
    var url = Uri.parse('https://api.instagram.com/oauth/access_token');
    final response = await http.post(url, body: {
      'client_id': InstagramConstant.clientID,
      'redirect_uri': InstagramConstant.redirectUri,
      'client_secret': InstagramConstant.appSecret,
      'code': authorizationCode,
      'grant_type': 'authorization_code'
    });
    accessToken = json.decode(response.body)['access_token'];
    userID = json.decode(response.body)['user_id'].toString();
    return (accessToken != null && userID != null) ? true : false;
  }

  Future<bool> getUserProfile() async {
    final fields = userFields.join(',');
    final responseNode = await http.get(Uri.parse(
        'https://graph.instagram.com/$userID?fields=$fields&access_token=$accessToken'));
    username = json.decode(responseNode.body)['username'];
    return true;
  }
}