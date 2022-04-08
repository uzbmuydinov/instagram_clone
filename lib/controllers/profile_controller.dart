import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramclon/models/post_model.dart';
import 'package:instagramclon/models/user_model.dart';
import 'package:instagramclon/services/auth_service.dart';
import 'package:instagramclon/services/data_service.dart';
import 'package:instagramclon/services/file_service.dart';
import 'package:instagramclon/services/utils.dart';

class ProfileController extends GetxController{
  List<Post> postList = [];
  bool isLoading = false;
  File? file;
  User? user;

  void apiLoadPosts() {
    isLoading = true;
    update();
    DataService.loadPosts().then((value) => {
      resLoadPosts(value),
    });
  }

  void resLoadPosts(List<Post> list) {
    isLoading = false;
    update();
    postList = list;
    update();
  }

  Future getImageOfGalary() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      file = File(image.path);
      update();
    } else {
      if (kDebugMode) {
        print('No image selected.');
      }
    }

    apiChangePhoto();
  }

  // for load user
  void apiLoadUser() async {
    isLoading = true;
    update();
    DataService.loadUser().then((value) => showUserInfo(value));
  }

  void showUserInfo(User user) {
    this.user = user;
    update();
    isLoading = false;
    update();
  }

  // for edit user
  void apiChangePhoto() {
    if (file == null) return;

    isLoading = true;
    update();

    FileService.uploadImage(file!, FileService.folderUserImg)
        .then((value) => apiUpdateUser(value));
  }

  void apiUpdateUser(String imgUrl) async {
    isLoading = false;
    update();
    user?.imageUrl = imgUrl;
    update();

    await DataService.updateUser(user!);
  }

  Future getImageOfCamera() async {
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

    apiChangePhoto();
  }

  actionLogOut(BuildContext context) async {
    var result = await Utils.dialogCommon(
        context, "Do you want to log out", "Instagram clone", false);
    if (result) {
      AuthService.signOutUser(context);
    }
  }

  void actionRemovePost(BuildContext context,Post post)async{
    var result = await Utils.dialogCommon(context, "Do you want to remove this post", "Instagram clone", false);
    if(result){
      DataService.removePost(post).then((value) => {
        apiLoadPosts(),
      });
    }
  }
}