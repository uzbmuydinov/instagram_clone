import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagramclon/models/user_model.dart' as model;
import 'package:instagramclon/pages/sign_in_page.dart';
import 'package:instagramclon/services/auth_service.dart';
import 'package:instagramclon/services/data_service.dart';
import 'package:instagramclon/services/get_storage.dart';

import '../services/utils.dart';

class SignUpController extends GetxController{
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;


  void doSingUp() async {
    String fullName = nameController.text.trim().toString();
    String confirmPassword = confirmPasswordController.text.trim().toString();
    String email = emailController.text.trim().toString();
    String password = passwordController.text.trim().toString();

    isLoading = true;
    update();

    if (email.isEmpty ||
        password.isEmpty ||
        fullName.isEmpty ||
        confirmPassword.isEmpty) {
      // error msg
      if(!(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email))) {
        Utils.fireToast("This email is not valid.Please check your email");
        return;
      }
      if(confirmPassword != password) {
        Utils.fireToast("Password and confirm does not match");
        return;
      }
      if(!(RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$').hasMatch(password))){
        Utils.fireToast("This password is not valid.Please check your password");
        return;
      }
      return;
    }

    await AuthService.signUpUser(fullName, email, password)
        .then((value) {
      model.User modelUser = model.User(fullName: fullName, email: email, password: password);
      _getFirebaseUser(modelUser,value);
    });
  }

  void _getFirebaseUser(model.User user, Map<String,User?> map) async {
    isLoading = true;
    update();

    if(!map.containsKey("SUCCESS")){
      if(map.containsKey("weak-password")) Utils.fireToast("The password provided is too weak.");
      if(map.containsKey("email-already-in-use")) Utils.fireToast("The account already exists for that email.");
      if(map.containsKey("ERROR")) Utils.fireToast("Check your information");
      return;
    }

    User? fireUser;
    fireUser = map["SUCCESS"];
    update();
    if(fireUser == null) return;

    await GetStorageDB.store(StorageKeys.UID, fireUser.uid);
    user.uid = fireUser.uid;
    update();

    DataService.storeUser(user).then((value) => {
      Get.off(SignInPage()),
    });
  }
}