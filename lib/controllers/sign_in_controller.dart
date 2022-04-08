import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagramclon/pages/home_page.dart';
import 'package:instagramclon/services/auth_service.dart';
import 'package:instagramclon/services/utils.dart';

import '../services/get_storage.dart';

class SignInController extends GetxController{
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  String error = "";

  void  doSingIn() async{
    String email = emailController.text.trim().toString();
    String password = passwordController.text.trim().toString();

    isLoading = true;
    update();

    if(email.isNotEmpty || password.isNotEmpty) {
      await AuthService.signInUser(email, password).then((user) => {
        _getFirebaseUser(user),
      });
    }

    isLoading = false;
    error = "Please enter email or password";
    update();
    return;
  }

  void _getFirebaseUser(Map<String, User?> map)async{
    isLoading = false;
    update();

    if(!map.containsKey("SUCCESS")) {
      if(map.containsKey("user-not-found")) Utils.fireToast("No user found for that email.");
      if(map.containsKey("wrong-password")) Utils.fireToast("Wrong password provided for that user.");
      if(map.containsKey("ERROR")) Utils.fireToast("Check Your Information.");
      return;
    }

    User? user = map["SUCCESS"];
    update();
    if(user == null) return;

    await GetStorageDB.store(StorageKeys.UID, user.uid);
    Get.off(HomePage());
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    emailController.dispose();
    passwordController.dispose();
  }
}