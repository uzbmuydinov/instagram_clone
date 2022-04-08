import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagramclon/services/utils.dart';

class HomeController extends GetxController{
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final pageController = PageController();
  int selectedIndex = 0;

  initNotification(){
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Utils.showLocalNotification(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Utils.showLocalNotification(message);
    });
  }

}