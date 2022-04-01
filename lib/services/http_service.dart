import 'dart:convert';

import 'package:http/http.dart';

class Network {
  static String SERVER = "fcm.googleapis.com";

  /* Header */
  static Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization":
        "key=AAAADhI_vgc:APA91bGt4nQCIR5vp07I2DVvPvjpu4x8u_ImmLDdOyomQVaez63fL1FW-PWijsEszzIcO0-EPlHNQlQAHaCpQ0_-lMqGI_ZhfikvHX7uY19rDluDOHS-IZSDO89FtWGyaLMeNjtijruM"
  };

  static String API_CREATE = "/fcm/send";

  static Future<String?> POST(String api, Map<String, dynamic> params) async {
    var uri = Uri.https(SERVER, api); // http or https
    var response = await post(
      uri,
      body: jsonEncode(params),
      headers: headers,
    );
    if (response.statusCode == 200) return response.body;
    return null;
  }

  static Map<String, dynamic> paramsCreate(String token,String name) {
    Map<String, dynamic> params = {};
    params.addAll({
      "notification": {
        "title": "Instagram Clone",
        "body": "$name followed you"
      },
      "registration_ids": [token],
      "click_action": "FLUTTER_NOTIFICATION_CLICK"
    });
    return params;
  }
}
