import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagramclon/animations/fade_animation.dart';
import 'package:instagramclon/controllers/sign_in_controller.dart';
import 'package:instagramclon/pages/sign_up_page.dart';

class SignInPage extends StatelessWidget {
  SignInPage({Key? key}) : super(key: key);
  static const String id = "sign_in_page";


  final SignInController controller = Get.put(SignInController());

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
                      controller: controller.emailController,
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
                      controller: controller.passwordController,
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
                        controller.doSingIn();
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
