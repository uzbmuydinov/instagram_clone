import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:instagramclon/pages/home_page.dart';
import 'package:instagramclon/pages/sign_in_page.dart';
import 'package:instagramclon/pages/sign_up_page.dart';
import 'package:instagramclon/pages/splash_page.dart';
import 'package:instagramclon/pages/user_page.dart';
import 'package:instagramclon/services/di_service.dart';
import 'package:instagramclon/services/get_storage.dart';

Future main() async{
  await DIService.init();
  await GetStorageDB.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var initAndroidSetting = const AndroidInitializationSettings("@mipmap/ic_launcher");
  var initIosSetting = const IOSInitializationSettings();
  var initSetting = InitializationSettings(android: initAndroidSetting,iOS: initIosSetting);
  await FlutterLocalNotificationsPlugin().initialize(initSetting);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]).then((_) => {
    runApp(const MyApp())
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Widget _startPage() {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            GetStorageDB.store(StorageKeys.UID,snapshot.data!.uid);
            return const SplashPage();
          } else {
            GetStorageDB.remove(StorageKeys.UID);
            return SignInPage();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Instagram',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: _startPage(),
      routes: {
        SignInPage.id:(context) => SignInPage(),
        SignUpPage.id:(context) => SignUpPage(),
        HomePage.id:(context) => HomePage(),
        UserPage.id:(context) => UserPage(),
      },
    );
  }
}

