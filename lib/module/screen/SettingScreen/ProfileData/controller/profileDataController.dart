import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import '../../../Home/screen/authservices.dart';
import '../../../RegisterDetails/model/ServicesData.dart';

class ProfileDataController extends GetxController{
  Rx<File?> imageFile = Rx<File?>(null);
  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController contactOpp = TextEditingController();
  TextEditingController email = TextEditingController();
  RxBool isloading = false.obs;
  final AuthService _authService = Get.put(AuthService());
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadUserData();
  }
  Future<List<ServicesData>> loadUserData() async {
    List<ServicesData> data = [];
    User? user = FirebaseAuth.instance.currentUser;
    CollectionReference collectionReference = FirebaseFirestore.instance.collection("service_providers");
    QuerySnapshot querySnapshot = await collectionReference.where("Uid",isEqualTo: user!.uid).get();
    try{
      if(querySnapshot.docs.isNotEmpty){
          querySnapshot.docs.forEach((element) {
            Map<String, dynamic> datas = element.data() as Map<String, dynamic>;
            data.add(ServicesData.formMap(datas));
          });
        return data;
      }else{
        print("Data Error");
        return [];
      }
    } catch(e){
      return [];
    }
  }

  updateImages(ImageSource source) async {
    await _pickTheImages(source);
    update();
  }
  Future<void> _pickTheImages(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      imageFile.value = File(pickedImage.path);
      update();
    }
  }


  updateDatainFirebase(ServicesData servicesData) async {
    isloading.value = true;
    String img = "";
    String userUid =_authService.user.value!.uid;

    if(userUid.isNotEmpty){
      if(imageFile.value == null){
          img = servicesData.Images;
        }else{
          img = await pickimages();
        }
      try{
        CollectionReference users = FirebaseFirestore.instance.collection('service_providers');
        servicesData.Images = img;
        await users.doc(userUid).update(servicesData.tomap());
        isloading.value = false;
        return true;
      }catch(e){
        print(e.toString());
        return false;
      }
    }
  }

  pickimages() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    String downloadUrl = "";
    String extentions = extension(imageFile.value!.path);
    String fileName = DateTime.now().millisecondsSinceEpoch.toString() + extentions;
    Reference ref = storage.ref().child('ServiceProfile').child(fileName);
    File file = imageFile!.value!;
    await ref.putFile(file);
    downloadUrl = await ref.getDownloadURL();
    return downloadUrl;
  }
}