import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../LocalStorage/StorageClass.dart';

class RegisterController extends GetxController{
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Rx<User?> user = Rx<User?>(null);
  String? get userId => user.value?.uid;
  RxBool isLoading = false.obs;
  var isPasswordVisible = true.obs;
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
  StorageService storageService = new StorageService();

  @override
  void onClose() {

    super.onClose();
  }
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  void onInit() {
    super.onInit();
    user.bindStream(_auth.authStateChanges());
  }


  Future<dynamic> createAccount() async {
    isLoading.value = true;
    update();
    try{
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.toString().trim(),
        password: passwordController.text.toString().trim(),
      );
      isLoading.value = false;
      storageService.setPassword(passwordController.text.toString().trim());
      storageService.setEmail(emailController.text.toString().trim());
      update();
      return userCredential;
    }on FirebaseAuthException catch (e){
      if (e.code == 'weak-password') {
        isLoading.value = false;
        update();
        return "The password provided is too weak.";
      } else if (e.code == 'email-already-in-use') {
        isLoading.value = false;
        update();
        return "The account already exists for that email.";
      }
    }catch(e){
      print('Error occurred: $e');
    }
  }

}