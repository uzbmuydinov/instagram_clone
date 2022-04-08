import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagramclon/controllers/like_controller.dart';
import 'package:instagramclon/views/like_views.dart';

class LikePage extends StatefulWidget {
  const LikePage({Key? key}) : super(key: key);

  @override
  _LikePageState createState() => _LikePageState();
}

class _LikePageState extends State<LikePage> {

  @override
  void initState() {
    // TODO: implement initState
    Get.find<LikeController>().apiLoadLikes();
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
          "Likes",
          style: TextStyle(
              fontFamily: "Billabong", fontSize: 25, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: GetBuilder(
        builder: (LikeController controller) => !controller.isLoading?Container(
          child: ListView.builder(
            itemCount: controller.postList.length,
            itemBuilder: (context, index) {
              return itemOfPost(context,index,controller);
            },
          ),
        ):const Center(
          child: CircularProgressIndicator(),
        ),
      )
    );
  }
}
