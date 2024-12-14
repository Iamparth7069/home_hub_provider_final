import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:home_hub_provider_final/utils/extension.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';
import '../../../LocalStorage/StorageClass.dart';
import '../../../Routes/Routes.dart';
import '../../../constants/app_assets.dart';
import '../../../constants/app_color.dart';
import '../../../constants/app_string.dart';
import 'RegisterController.dart';

class Register extends StatelessWidget {
  Register({super.key});

  final RegisterController _registerController = Get.put(RegisterController());
  final _globel = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(
                      Icons.arrow_back_outlined,
                      size: 4.h,
                    ),
                  ),
                ),
              ),
              1.w.addHSpace(),
              Center(
                child: AspectRatio(
                    aspectRatio: 19 / 12,
                    child: assetLottieAnimation(
                        path: AppAssets.reistrationAnimation)),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Form(
                  key: _globel,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppString.registerString.mediumAlegreyaSC(
                        fontColor: Colors.black,
                        fontSize: 35,
                      ),
                      3.h.addHSpace(),
                      appTextFormField(
                        validator: (value) {
                          if (value == null || !AppAssets.isvalidemail(value)) {
                            return "Enter the Valid Email";
                          } else {
                            return null;
                          }
                        },
                        controller: _registerController.emailController,
                        labelText: "Email",
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Colors.black,
                        ),
                      ),
                      2.h.addHSpace(),
                      Obx(
                            () {
                          return appTextFormField(
                            obscureText:
                            _registerController.isPasswordVisible.value,
                            controller: _registerController.passwordController,
                            validator: (value) {
                              if (value == null ||
                                  !AppAssets.isvalidpassword(value)) {
                                return "Enter the validPassword";
                              } else {
                                return null;
                              }
                            },
                            labelText: "Password",
                            prefixIcon: Image.asset(
                              "assets/images/padlock.png",
                              width: 10,
                              height: 10,
                              scale: 3,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _registerController.isPasswordVisible.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                _registerController.togglePasswordVisibility();
                              },
                            ),
                          );
                        },
                      ),
                      5.h.addHSpace(),
                      Obx(() => _registerController.isLoading.value ? LoadingAnimationWidget.hexagonDots(
                          color: appColor, size: 5.h) : appButton(
                            onTap: () async {
                              if (_globel.currentState!.validate()) {
                              var user =await  _registerController.createAccount();
                              if(user is UserCredential){
                                StorageService().setRegisterStatus(true);
                                Get.offAllNamed(Routes.registerDetails,arguments: {"email" : _registerController.emailController.text.toString(),
                                "password" : _registerController.passwordController.text.toString()

                                });
                              }else if(user is String){
                                print("Not Valid Password");
                              }
                              } else {
                                print("Not Success");
                              }
                            },
                            text: "Next"),
                      ),
                      4.h.addHSpace(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          "Already have an account?".mediumRoboto(
                              fontSize: 14, fontColor: Colors.grey),
                          SizedBox(
                            width: 1.w,
                          ),
                          InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: "Sign in".boldRoboto(
                                  fontColor: lightBlue, fontSize: 15))
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
