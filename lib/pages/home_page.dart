import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagramclon/controllers/home_controller.dart';
import 'package:instagramclon/pages/home_page1.dart';
import 'package:instagramclon/pages/like_page.dart';
import 'package:instagramclon/pages/profile_page.dart';
import 'package:instagramclon/pages/search_page.dart';
import 'package:instagramclon/pages/upload_page.dart';
import 'package:instagramclon/services/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const String id = "home_page";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final pageController = PageController();
  int _selectedIndex = 0;

  _initNotification() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Utils.showLocalNotification(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Utils.showLocalNotification(message);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    Get.find<HomeController>().initNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: HomeController(),
        builder: (HomeController controller) => WillPopScope(
              onWillPop: () async {
                if (_selectedIndex == 0) {
                  return true;
                } else {
                  pageController.jumpToPage(0);
                  return false;
                }
              },
              child: Scaffold(
                body: PageView(
                  controller: pageController,
                  children: [
                    HomePage1(
                      pageController: pageController,
                    ),
                    SearchPage(),
                    UploadPage(
                      pageController: pageController,
                    ),
                    LikePage(),
                    ProfilePage(),
                  ],
                  onPageChanged: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                ),
                bottomNavigationBar: CupertinoTabBar(
                  backgroundColor: Colors.white,
                  currentIndex: _selectedIndex,
                  onTap: (index) {
                    setState(() {
                      _selectedIndex = index;
                      pageController.jumpToPage(index);
                    });
                  },
                  activeColor: Colors.purple,
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.home,
                      ),
                      label: "",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.search,
                      ),
                      label: "",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.add_box,
                      ),
                      label: "",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.favorite,
                      ),
                      label: "",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.person_pin,
                      ),
                      label: "",
                    ),
                  ],
                ),
              ),
            ));
  }
}
