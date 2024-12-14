import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../LocalStorage/StorageClass.dart';
import '../../../constants/app_color.dart';


class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final collection = FirebaseFirestore.instance.collection("service_providers");
  final StorageService _storageService = StorageService();
  Rx<User?> user = Rx<User?>(null);
  String? get userId => user.value?.uid;
  RxBool isLoading = false.obs;
  final userCheck = FirebaseFirestore.instance.collection("service_providers");
  RxBool checkEmail = false.obs;

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  @override
  void onInit() {
    super.onInit();
    user.bindStream(_auth.authStateChanges());
  }
  var isPasswordVisible = true.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
  Future<dynamic> signInWithEmailAndPassword() async {
    try {
      isLoading(true);
      QuerySnapshot querySnapshot  = await userCheck.where("email",isEqualTo: emailController.text.toString().trim()).get();
      checkEmail.value = querySnapshot.docs.isNotEmpty;
      if(checkEmail.value){
        print("Check Uset is ${querySnapshot.docs[0].data()}");
        print("Is a Valid User");
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        // Get.offAllNamed(Routes.homeScreen);
        _storageService.loginStatusCheck(true);
        isLoading(false);
        // NotificationService _notification = NotificationService();
        // String tocken =await _notification.getFCMToken();
        // if(userCredential != null){
        //    DocumentReference documentReference =  collection.doc(userCredential.user!.uid);
        //    DocumentSnapshot snapshot = await documentReference.get();
        //    // ServicesData serviceResponseModel = ServicesData.formMap(snapshot.data() as Map<String,dynamic>);
        //    // serviceResponseModel.fcmToken = tocken;
        //    // documentReference.set(serviceResponseModel.tomap());
        // }
        return userCredential;
      }
      else{
        isLoading(false);
        Get.snackbar(
          'Email Not Verified',
          'Please try again with a different email.',
          backgroundColor: appColor,
          colorText: Colors.white,
        );
      }
    } on FirebaseAuthException catch (e) {
      isLoading(false);
      if (e.code == 'user-not-found') {
        Get.snackbar(
          backgroundColor: appColor,
          colorText: Colors.white,
          'Login Error',
          'No user found for that email',
          snackPosition: SnackPosition.BOTTOM,
        );
        return e.code;
      } else if (e.code == 'wrong-password') {
        Get.snackbar(
          backgroundColor: appColor,
          colorText: Colors.white,
          'Login Error',
          'Wrong password provided for that user',
          snackPosition: SnackPosition.BOTTOM,
        );
        return e.code;
      } else if (e.code == 'invalid-email') {
        Get.snackbar(
          backgroundColor: appColor,
          colorText: Colors.white,
          'Login Error',
          'Invalid email address',
          snackPosition: SnackPosition.BOTTOM,
        );
        return e.code;
      } else {
        Get.snackbar(
          backgroundColor: appColor,
          colorText: Colors.white,
          'Login Error',
          'Error: Invalid email address And Password',
          snackPosition: SnackPosition.BOTTOM,
        );
        return e.code;
      }
    } catch (e) {
      // Catch other exceptions
      Get.snackbar(
        backgroundColor: appColor,
        colorText: Colors.white,
        'Login Error',
        'Failed to sign in: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return e.toString();
    }
  }


}
