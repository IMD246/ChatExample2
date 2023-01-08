import 'dart:convert';

import 'package:http/http.dart' as http;

class FcmHandler {
  static Future<void> sendMessage({
    required Map<String, dynamic> notification,
    required String tokenUserFriend,
    required Map<String, dynamic> data,
  }) async {
    String url = 'https://fcm.googleapis.com/fcm/send';
    String keyApp =
        'key=AAAAnXc3Pd8:APA91bEQcgSFtPNobPniU2a3mr3NC_clNjk5yQk6oucV_hGuYP0gul85rAwjWMajy1M9h-kNcbgyFw4jYqhUA2q8TbgbgXmq--imA3vAEy5iFOpaxb0UU1Qm5QLacyJVvGASEi0vL2ga';
    final headers = <String, String>{
      'Content-type': 'application/json',
      'Authorization': keyApp,
    };
    try {
      await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(
          <String, dynamic>{
            'notification': notification,
            'priority': 'high',
            'data': data,
            "to": tokenUserFriend,
          },
        ),
      );
    } catch (e) {
      rethrow;
    }
  }
}
