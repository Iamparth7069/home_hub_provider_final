import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:path/path.dart';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../Home/model/services.dart';


class AddServicesController extends GetxController {
  final serviceName = TextEditingController();
  final description = TextEditingController();
  final price = TextEditingController();
  RxString userid = RxString('');
  Rx<File?> imageFile = Rx<File?>(null);
  var categoryServices = Rx<String?>(null);
  RxBool showContent = false.obs;
  RxBool IsLoadding = false.obs;
  final RxList<File> _PosterImages = <File>[].obs;

  List<File> get pickedImages => _PosterImages;
  final RxList<File> _images = <File>[].obs;

  List<File> get imagesPick => _images;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getCurrentUser();
    loadCategoryList();
  }

  void setSelectedService(String? service) {
    categoryServices.value = service;
  }

  RxList<String> selectServices = <String>[].obs;
  String? names;
  String? Contectnumber;
  String? address;

  Future<void> loadCategoryList() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection("servicesInfo").get();
    QuerySnapshot<Map<String, dynamic>> userProviderData =
        await FirebaseFirestore.instance
            .collection("service_providers")
            .where("Uid", isEqualTo: userid.value)
            .limit(1)
            .get();
    try {
      if (userProviderData.docs.isNotEmpty) {
        Map<String, dynamic> userData = userProviderData.docs.first.data();
        String name = userData['fname'] + " " + userData['lname'];
        String number = userData['contact'];
        String addresses = userData["address"];
        names = name;
        Contectnumber = number;
        address = addresses;
      }

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

  Future<void> pickImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
    }
  }

  void remove() {
    imageFile.value = null;
    update();
  }

  void toggleContent() {
    showContent.value = !showContent.value;
    update();
  }

  Future<void> pickPosterImages() async {
    List<XFile>? pickedImages =
        await ImagePicker().pickMultiImage(imageQuality: 30);

    if (pickedImages != null) {
      _PosterImages.addAll(pickedImages.map((image) => File(image.path)));
    }
  }

  void Dispose() {
    serviceName.clear();
    imageFile.value = null;
  }

  Future<bool> uploadDataInFirebase() async {
    try {
      IsLoadding.value = true;
      List<String> images = await _uploadImagesToStorage();
      _updateDatabase(images);
      clearingData();
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    } finally {
      IsLoadding.value = false;
    }
  }

  Future<List<String>> _uploadImagesToStorage() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    List<String> downloadUrls = [];

    for (var imageFile in _PosterImages) {
      String extentions = extension(imageFile.path);
      String fileName =
          DateTime.now().millisecondsSinceEpoch.toString() + extentions;
      Reference ref = storage.ref().child('Images').child(fileName);
      // Upload image to Firebase Storage
      await ref.putFile(imageFile);
      // Get download URL for the uploaded image
      String downloadUrl = await ref.getDownloadURL();
      downloadUrls.add(downloadUrl);
    }
    return downloadUrls;
  }

  void getCurrentUser() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      userid.value = user.uid;
    } else {
      // User is not logged in
      print("Error ");
    }
  }

  _updateDatabase(List<String> images) async {
    String userId = userid.value;
    var now = DateTime.now();
    ServiceResponseModel service = ServiceResponseModel(
      serviceStatus: "available",
        createdAt: DateTime.now(),
        userName: names!,
        categoryName: categoryServices.value!,
        images: images,
        address: address!,
        price: int.parse(price.text.toString()),
        serviceName: serviceName.text.toString(),
        description: description.text.toString(),
        averageRating: 0.0,
        totalRating: 0,
        userId: userId,
        savedBy: [],
        serviceIds: '');

    final collection = FirebaseFirestore.instance.collection("Services-Provider(Provider)");
    Map<String, dynamic> data = service.toMap();
    DocumentReference documentReference = await collection.add(data);
    String documentId = documentReference.id;
    service.serviceIds = documentId;
    await collection.doc(documentId).update(service.toMap());

  }

  void clearingData() {
    imageFile.value = null;
    categoryServices.value = null;
    description.clear();
    _PosterImages.clear();
    showContent.value = false;
    serviceName.clear();
  }
}
