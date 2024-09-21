

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  // Request Notification permission
  Future<void> requestPermission() async{
    PermissionStatus status = await Permission.notification.request();
    if(status != PermissionStatus.granted) {
      throw Exception("Permission not Granted");
    }
  }

  //
  final firebaseFirestore = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser;

  Future<void> uploadFcmToken() async {
    try {
      await FirebaseMessaging.instance.getToken().then((token) async {
        print("Get Token $token");
        await firebaseFirestore.collection('users').doc(currentUser!.uid).set({
          'notificationToken' : token,
        });
      },);
      FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
        print("Get Token $token");
        await firebaseFirestore.collection('users').doc(currentUser!.uid).set({
          'notificationToken' : token,
          'email' : currentUser!.email,
        });
      });
    }catch (e) {
      throw Text(e.toString());
    }
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Local notifications
  Future<void> init() async {
    // Initialize Notification
    AndroidInitializationSettings initializedAndroidSetting = const AndroidInitializationSettings('@mipmap/ic_launcher');
    InitializationSettings initializationSettings = InitializationSettings(android: initializedAndroidSetting);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Show Notification
  showNotification(RemoteMessage message) async {
    AndroidNotificationDetails androidNotificationDetails = const AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'Channel Description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    int notificationId = 1;

    NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
      notificationId,
      message.notification!.title,
      message.notification!.body,
      notificationDetails,
      payload: 'Not present',
    );
  }

}