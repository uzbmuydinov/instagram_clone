import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagramclon/controllers/upload_controller.dart';
import 'package:instagramclon/views/upload_views.dart';

class UploadPage extends StatelessWidget {
  PageController? pageController;

  UploadPage({Key? key, this.pageController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: UploadController(),
      builder: (UploadController controller) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text(
            "Upload",
            style: TextStyle(
                fontFamily: "Billabong", fontSize: 25, color: Colors.black),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.add_photo_alternate_outlined,
                color: Colors.purple,
              ),
              onPressed: () {
                controller.uploadNewPost();
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: imageUploadArea(context,controller),
            ),
            controller.isLoading ? LinearProgressIndicator(color: Colors.blue,) : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
