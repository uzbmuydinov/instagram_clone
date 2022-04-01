import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:instagramclon/animations/fade_animation.dart';
import 'package:instagramclon/pages/home_page.dart';
import 'package:instagramclon/services/hive_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  
  _openSignInPage()async{
    Timer(const Duration(seconds: 2), (){
      Navigator.of(context).pushReplacementNamed(HomePage.id);
    });
  }

  _initNotification() async {
    await _firebaseMessaging
        .requestPermission(sound: true, badge: true, alert: true);
    _firebaseMessaging.getToken().then((String? token) {
      assert(token != null);
      HiveDB.saveFCM(token!);
    });
  }


  @override
  void initState() {
    _openSignInPage();
    _initNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(131, 58, 180, 1),
              Color.fromRGBO(193, 53, 143, 1),
            ],
          ),
        ),
        child: FadeAnimation(2, Stack(
          children: [
            const Center(
              child: Text(
                "Instagram",
                style: TextStyle(fontFamily: "Billabong", color: Colors.white,fontSize: 45),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(20),
              alignment: Alignment.bottomCenter,
              child: const Text("All rights reserved",style: TextStyle(color: Colors.white),),
            ),
          ],
        )),
      ),
    );
  }
}
