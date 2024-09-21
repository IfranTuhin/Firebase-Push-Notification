import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Constants {
  //
  static const String BASE_URL = "https://fcm.googleapis.com/fcm/send";

  //
  static const String KEY_SERVER = '';

  //
  static const String SENDER_ID = '';
}

class AdminNotificationServices {
  Future<bool> pushNotification({
    required String title,
    body,
    token,
  }) async {
    Map<String, dynamic> payload = {
      'to': token,
      'notification': {
        "priority" : "high",
        'title' : title,
        'body' : body,
        'sound' : 'default',
      }
    };

    String dataNotification = jsonEncode(payload);
    var response = await http.post(
      Uri.parse(Constants.BASE_URL),
      headers: <String, String> {
        'Content-Type': 'application/json',
        'Authorization' : 'key= ${Constants.KEY_SERVER}',
      },
      body: dataNotification,
    );
    debugPrint('Notification Body : ${response.body.toString()}');
    return true;
  }
}
