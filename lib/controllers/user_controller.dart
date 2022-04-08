import 'dart:io';

import 'package:get/get.dart';
import 'package:instagramclon/models/post_model.dart';
import 'package:instagramclon/models/user_model.dart';
import 'package:instagramclon/services/data_service.dart';

class UserController extends GetxController{
  List<Post> postList = [];
  bool isLoading = false;
  File? file;
  User? user;

  void apiLoadPosts(uid) {
    isLoading = true;
    update();
    DataService.loadUserPosts(uid).then((value) => {
      resLoadPosts(value),
    });
  }

  void resLoadPosts(List<Post> list) {
    isLoading = false;
    update();
    postList = list;
    update();
  }

  void apiLoadUser(uid) async {
    isLoading = true;
    update();
    DataService.loadPostUser(uid).then((value) => showUserInfo(value));
  }

  void showUserInfo(User user) {
    this.user = user;
    update();
    isLoading = false;
    update();
  }
}