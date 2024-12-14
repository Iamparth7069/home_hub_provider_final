import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../LocalStorage/StorageClass.dart';
import '../../../../../Routes/Routes.dart';
import '../../../RegisterDetails/model/ServicesData.dart';


class UpdatePasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController currentPasswordController =
  TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    confirmPasswordController.dispose();
    newPasswordController.dispose();
    currentPasswordController.dispose();
  }
  StorageService storageService = StorageService();
  User? UserID = FirebaseAuth.instance.currentUser;

  RxBool isLoading = false.obs;

  void handelPasswordError(ServicesData myDataObject, BuildContext context) {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      Future.delayed(Duration(seconds: 5), () async {
        isLoading.value = false;
        // service_providers
        String uid = storageService.getUserid();
        final DocumentReference documentReference =
        FirebaseFirestore.instance.collection('service_providers').doc(uid);
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: myDataObject.email, password: myDataObject.password!);
        if (userCredential != null) {
          await userCredential.user!.updatePassword(confirmPasswordController.text.toString().trim());
          myDataObject.password = confirmPasswordController.text.toString();
          await documentReference.update(myDataObject.tomap());
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password changed successfully!'),));
          storageService.loginStatusCheck(false);
          Get.offAllNamed(Routes.loginScreen);
          print("Password Changes");
        } else {
          print("User Not Found");
        }
      });
    }
  }
}
