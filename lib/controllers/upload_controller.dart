import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramclon/models/post_model.dart';
import 'package:instagramclon/pages/home_page.dart';
import 'package:instagramclon/services/data_service.dart';
import 'package:instagramclon/services/file_service.dart';

class UploadController extends GetxController {
  final captionController = TextEditingController();
  File? file;
  bool isLoading = false;

  Future getImageOfGalary() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    update();

    if (image != null) {
      file = File(image.path);
      update();
    } else {
      if (kDebugMode) {
        print('No image selected.');
      }
    }
  }

  Future getImageOfCamere() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    update();

    if (image != null) {
      file = File(image.path);
      update();
    } else {
      if (kDebugMode) {
        print('No image selected.');
      }
    }
  }

  void uploadNewPost() {
    String caption = captionController.text.trim().toString();
    if (caption.isEmpty) return;
    if (file == null) return;

    apiPostImage();
  }

  void apiPostImage() {
    isLoading = true;
    update();

    FileService.uploadImage(file!, FileService.folderPostImg).then((value) => {
          resPostImage(value),
        });
  }

  void resPostImage(String downloadUrl) {
    String caption = captionController.text.toString().trim();
    Post post = Post(img_post: downloadUrl, caption: caption);
    apiStorePost(post);
  }

  void apiStorePost(Post post) async {
    Post posted = await DataService.storePost(post);
    await DataService.storeFeed(posted).then((value) => {
          Get.off(const HomePage()),
          file = null,
          update(),
          captionController.clear(),
          update(),
          isLoading = false,
          update(),
        });
  }
}
