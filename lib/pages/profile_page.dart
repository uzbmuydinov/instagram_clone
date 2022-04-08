import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagramclon/controllers/profile_controller.dart';
import 'package:instagramclon/views/profile_views.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    Get.find<ProfileController>().apiLoadUser();
    Get.find<ProfileController>().apiLoadPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      builder: (ProfileController controller) => DefaultTabController(
        length: 2,
        child: Scaffold(
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
            actions: [
              IconButton(
                  onPressed: () {
                    controller.actionLogOut(context);
                  },
                  icon: const Icon(
                    Icons.login_outlined,
                    color: Colors.black,
                  ))
            ],
          ),
          body: controller.user != null
              ? SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: profileBody(context,controller),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }
}
