import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:midnightcity/services/firebase.service.dart';

class GeneralAppService {
  //

//Hnadle background message
  static Future<void> onBackgroundMessageHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    FirebaseService().showNotification(message);
  }
}
