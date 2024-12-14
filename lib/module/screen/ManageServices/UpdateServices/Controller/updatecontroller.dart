import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path/path.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../Home/model/services.dart';

class UpdateController extends GetxController {
  RxBool showContent = true.obs;
  RxString userid = RxString('');
  RxBool LoadingServices = false.obs;
  RxBool UpdateLoading = true.obs;
  Rx<File?> imageFile = Rx<File?>(null);
  final RxList<File> _images = <File>[].obs;

  List<File> get imagesPick => _images;
  List<ServiceResponseModel> services = <ServiceResponseModel>[];

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getCurrentUser();
    loadCategory();
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

  var category_data = Rx<String?>(null);
  var services_data = Rx<String?>(null);

  void setSelectedService(String? service) {
    category_data.value = service;
    update();
  }

  void setSelectedCategory(String? service) {
    services_data.value = service;
    update();
  }

  RxList<String> selectServices = <String>[].obs;
  RxList<String> selectedCategory = <String>[].obs;

  Future<void> loadCategory() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection("servicesInfo").get();
    CollectionReference servicesCollection =
        FirebaseFirestore.instance.collection('Services-Provider(Provider)');

    try {
      QuerySnapshot querySnapshot = await servicesCollection.where("userId",isEqualTo: userid.value).get();
      querySnapshot.docs.forEach((doc) {
        selectedCategory.add(doc["service_name"]);
      });
    } catch (e) {
      print("The Error Is $e");
    }
    for (QueryDocumentSnapshot<Map<String, dynamic>> document
        in snapshot.docs) {
      String fieldValue = document['ServiceName'];

      if (fieldValue != null) {
        selectServices.add(fieldValue);
      }
    }
  }

// Get The Data From Firebase FIrestore
  Future<List<ServiceResponseModel>> getData() async {
    LoadingServices.value = true;
    Query<Map<String, dynamic>> query = FirebaseFirestore.instance
        .collection('Services-Provider(Provider)');

    if (category_data.value != null && services_data.value != null) {
      // Ensure 'CategoryName' is the correct field name in your Firestore documents
      print(userid.value);
      print(category_data.value);
      print(services_data.value);
      query = query
          .where("category_name", isEqualTo: category_data.value)
        .where("service_name", isEqualTo: services_data.value)
        .where("userId",isEqualTo: userid.value);
      var check = await query.get();
      for (var element in check.docs) {
        services.add(ServiceResponseModel.fromMap(element.data()));
      }
      LoadingServices.value = false;
      return services;
    }else{
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

  Future<void> pickPosterImages() async {
    List<XFile>? pickedImages =
        await ImagePicker().pickMultiImage(imageQuality: 50);

    if (pickedImages != null) {
      imagesPick.addAll(pickedImages.map((image) => File(image.path)));
    }
  }



  Future<List<String>> updateImagesData() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    List<String> downloadUrls = [];
    for (var image in imagesPick) {
      String extentions = extension(image.path);
      String fileName =
          DateTime.now().millisecondsSinceEpoch.toString() + extentions;
      Reference ref = storage.ref().child('Images').child(fileName);
      await ref.putFile(image);
      String downloadUrl = await ref.getDownloadURL();
      downloadUrls.add(downloadUrl);
    }
    return downloadUrls;
  }

  updatedData({required List<String> listOfImages, required int price, required String desc, required String sname, required String serviceId}) async {
    try{
      UpdateLoading.value = false;
      List<String>? images;
      if(imagesPick.isEmpty){
        images = listOfImages;
      }else{
        images =await updateImagesData();
      }
      DocumentReference servicesUpdate = await FirebaseFirestore.instance
          .collection("Services-Provider(Provider)").doc(serviceId);

      await servicesUpdate.update({
        "service_name": sname,
          "images" : images,
          "price" : price,
          "description" : desc,
      });
      return true;
    }catch(e){
      print(e.toString());
      return false;
    }

  }
}
