import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:instagramclon/animations/fade_animation.dart';
import 'package:instagramclon/pages/home_page.dart';
import 'package:instagramclon/pages/sign_up_page.dart';
import 'package:instagramclon/services/utils.dart';
import '../services/auth_service.dart';
import '../services/hive_service.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);
  static const String id = "sign_in_page";

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  String error = "";

  void  _doSingIn() async{
    String email = emailController.text.trim().toString();
    String password = passwordController.text.trim().toString();

    setState(() {
      isLoading = true;
    });

    if(email.isNotEmpty || password.isNotEmpty) {
      await AuthService.signInUser(email, password).then((user) => {
        _getFirebaseUser(user),
      });
    }

    setState(() {
      isLoading = false;
      error = "Please enter email or password";
    });
    return;
  }

  void _getFirebaseUser(Map<String, User?> map)async{
    setState(() {
      isLoading = false;
    });

    if(!map.containsKey("SUCCESS")) {
      if(map.containsKey("user-not-found")) Utils.fireToast("No user found for that email.");
      if(map.containsKey("wrong-password")) Utils.fireToast("Wrong password provided for that user.");
      if(map.containsKey("ERROR")) Utils.fireToast("Check Your Information.");
      return;
    }

    User? user = map["SUCCESS"];
    if(user == null) return;

    await HiveDB.storeIdUser(user.uid);
    Navigator.of(context).pushReplacementNamed(HomePage.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(131, 58, 180, 1),
              Color.fromRGBO(193, 53, 143, 1),
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
                      controller: emailController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
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
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white38,
                    ),
                    height: 48,
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
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.white38)),
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      height: 48,
                      onPressed: () {
                        _doSingIn();
                      },
                      child: const Text(
                        "Sign In",
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
                    text: 'Don\'t have an account?',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    children: <TextSpan>[
                      TextSpan(text: ' Sign up', style: const TextStyle(color: Colors.white, fontSize: 16,fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).pushReplacementNamed(SignUpPage.id);
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
    );
  }
}
