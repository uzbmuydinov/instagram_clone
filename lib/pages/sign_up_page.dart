import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagramclon/controllers/sign_up_controller.dart';
import 'package:instagramclon/pages/sign_in_page.dart';
import '../animations/fade_animation.dart';


class SignUpPage extends StatelessWidget {
  SignUpPage({Key? key}) : super(key: key);
  static const String id = "sign_up_page";

 final SignUpController controller = Get.put(SignUpController());


  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
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
                        controller: controller.nameController,
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
                        controller: controller.emailController,
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
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white38,
                      ),
                      height: 48,
                      child: TextFormField(
                        controller: controller.confirmPasswordController,
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
                          controller.doSingUp();
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
