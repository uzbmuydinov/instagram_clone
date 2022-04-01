import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:instagramclon/models/user_model.dart' as model;
import 'package:instagramclon/pages/sign_in_page.dart';
import 'package:instagramclon/services/data_service.dart';
import '../animations/fade_animation.dart';
import '../services/auth_service.dart';
import '../services/hive_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/utils.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);
  static const String id = "sign_up_page";

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;
  void _doSingUp() async {
    String fullName = nameController.text.trim().toString();
    String confirmPassword = confirmPasswordController.text.trim().toString();
    String email = emailController.text.trim().toString();
    String password = passwordController.text.trim().toString();

    setState(() {
      isLoading = true;
    });

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
    setState(() {
      isLoading = true;
    });

    if(!map.containsKey("SUCCESS")){
      if(map.containsKey("weak-password")) Utils.fireToast("The password provided is too weak.");
      if(map.containsKey("email-already-in-use")) Utils.fireToast("The account already exists for that email.");
      if(map.containsKey("ERROR")) Utils.fireToast("Check your information");
      return;
    }

    User? fireUser;
    fireUser = map["SUCCESS"];
    if(fireUser == null) return;

    await HiveDB.storeIdUser(fireUser.uid);
    user.uid = fireUser.uid;

    DataService.storeUser(user).then((value) => {
      Navigator.of(context).pushReplacementNamed(SignInPage.id)
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(193, 53, 143, 1),
                Color.fromRGBO(131, 58, 180, 1),
              ],
            ),
          ),
          child: FadeAnimation(2, Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Instagram",
                      style: TextStyle(
                          fontFamily: "Billabong",
                          color: Colors.white,
                          fontSize: 45),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 48,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white38,
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        controller: nameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          hintText: "Fullname",
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 48,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white38,
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        controller: emailController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          hintText: "Email",
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 48,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white38,
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        controller: passwordController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          hintText: "Password",
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white38,
                      ),
                      height: 48,
                      child: TextFormField(
                        controller: confirmPasswordController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          hintText: "Confirm Password",
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.white38)),
                      child: MaterialButton(
                        minWidth: MediaQuery.of(context).size.width,
                        height: 48,
                        onPressed: () {
                          _doSingUp();
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(color: Colors.white60, fontSize: 25,fontFamily: "BIllabong"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: RichText(
                  text: TextSpan(
                      text: 'Already have an account?',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      children: <TextSpan>[
                        TextSpan(text: ' Sign in', style: const TextStyle(color: Colors.white, fontSize: 16,fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context).pushReplacementNamed(SignInPage.id);
                              }
                        )
                      ]
                  ),
                ),
              ),
              const SizedBox(height: 20,),
            ],
          ),),
        ),
      ),
    );
  }
}
