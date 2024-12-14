import 'dart:io';
import 'package:path/path.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../LocalStorage/StorageClass.dart';
import '../model/ServicesData.dart';

class RegisterDetailsController extends GetxController {


  Rx<User?> user = Rx<User?>(FirebaseAuth.instance.currentUser);
  CollectionReference ServiceProfile = FirebaseFirestore.instance.collection('service_provider_requests');
  final TextEditingController fName = TextEditingController();
  final TextEditingController lName = TextEditingController();
  final Reference _storageRef = FirebaseStorage.instance.ref();
  late final List<TextEditingController> controllers;

  final TextEditingController contact = TextEditingController();
  final StorageService _storageService = StorageService();
  final TextEditingController contactOptional = TextEditingController();
  final TextEditingController address = TextEditingController();
  RxBool isLoading = false.obs;
  RxBool loadAddData = false.obs;
  var selectedServices = Rx<String?>(null);

  String email = "";
  String password = "";

  // ************************ Image user And Aadhaar Pick ************************

  Rx<File?> imageFile = Rx<File?>(null);
  Rx<File?> aadharCard = Rx<File?>(null);
  Future<void> pickImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
    }
  }

  Future<void> pickAadharCard() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      aadharCard.value = File(pickedFile.path);
    }
    update();
  }


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    email = _storageService.getEmail() ; // Handle null case
    password = _storageService.getPassword();
    loadCategoryList();
  }
  @override
  void onClose() {
    fName.dispose();
    lName.dispose();
    address.dispose();
    contact.dispose();
    contactOptional.dispose();
    super.onClose();
  }


  void setSelectedService(String? service) {
    selectedServices.value = service;
  }
  RxList<String> selectServices = <String>[].obs;
  Future<void> loadCategoryList() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection("servicesInfo").get();

    try {
      for (QueryDocumentSnapshot<Map<String, dynamic>> document
      in snapshot.docs) {
        // Change "fieldName" to the actual field name you want to extract
        String fieldValue = document['ServiceName'];

        // Add the field value to the list
        if (fieldValue != null) {
          selectServices.add(fieldValue);
        }
      }

    } catch (e) {
      print('Error loading category list: $e');
      // Handle the error if necessary
    }
  }



  Future<bool> addDataInFirebase() async {
    try{
      isLoading.value = true;
      update();
      var image = await uploadServicesUserImages(imageFile.value!);
      var userAdhareCard = await UploadAddhareCardUser(aadharCard.value!,email,aadharCard.value);
      ServicesData service = ServicesData(Uid: user.value!.uid, Images: image, email: user.value!.email!, contectnumber: contact.text, contectNumber2: contactOptional != null ? contactOptional.text : "", address: address.text.toString().trim(), services: selectedServices.value!,password: password,fname: fName.text.toString().trim(),lname: lName.text.toString().trim(),useraadharcard: userAdhareCard,status: "Pending",clicks: 0,totalPayment: 0);
      String Names = "${fName.text.toString().trim()} ${lName.text.toString().trim()}";
      user.value!.updateDisplayName(Names);
      DocumentReference documentReference = await ServiceProfile.add(service.tomap());
      String docId = documentReference.id;
      service.Did=docId;
      await ServiceProfile.doc(docId).update(service.tomap());
      isLoading.value = false;

      return true;
    }catch(exception){
      isLoading.value = false;
      print("Error Is $exception");
      return false;
    }
  }

  uploadServicesUserImages(File file) async {
    String url = "";
    String tempFile = basename(imageFile.value!.path);
    var ex = extension(tempFile);
    String filename = tempFile;
    try{
      var image = await _storageRef.child("ServiceProfile").child(filename).putFile(imageFile.value!);
      if(image != null){
        url = await _storageRef.child("ServiceProfile").child(filename).getDownloadURL();
      }
    }on FirebaseException catch(e){
      print("Error Is e");
    }
    return url;
  }

  UploadAddhareCardUser(File file, email, File? value) async {
    String url = "";
    String tempFile = basename(imageFile.value!.path);
    String filename = email;
    var ex = extension(tempFile);
    var filenames = "$filename$ex";
    try{
      var image = await _storageRef.child("aadhar_card").child(filenames).putFile(file);
      if(image != null){
        url = await _storageRef.child("aadhar_card").child(filenames).getDownloadURL();
      }
    }on FirebaseException catch(e){
      print("Error Is e");
    }
    return url;
  }


}