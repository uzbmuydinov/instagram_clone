import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagramclon/controllers/user_controller.dart';
import 'package:instagramclon/views/user_views.dart';

class UserPage extends StatefulWidget {
  static const String id = "user_page";
  String? uid;
  UserPage({this.uid,Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  void initState() {
    Get.find<UserController>().apiLoadUser(widget.uid);
    Get.find<UserController>().apiLoadPosts(widget.uid);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Profile",
          style: TextStyle(
              fontFamily: "Billabong", fontSize: 25, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: GetBuilder(
        builder: (UserController controller) =>controller.user != null
            ? userBody(context,controller)
            : const Center(
          child: CircularProgressIndicator(),
        ),
      )
    );
  }

}
