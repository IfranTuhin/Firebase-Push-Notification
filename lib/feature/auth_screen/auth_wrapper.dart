import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:push_notification/feature/auth_screen/login_screen.dart';
import 'package:push_notification/feature/home_screen/home_screen.dart';
import 'package:push_notification/services/notification_services.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }else {
            if(snapshot.hasData) {
              LocalNotificationService().uploadFcmToken();
              return HomeScreen(user: snapshot.data!);
            } else {
              return const LoginScreen();
            }
          }
        },
      ),
    );
  }
}
