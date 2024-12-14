import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

import '../../../../../LocalStorage/StorageClass.dart';
import '../../../Home/model/services.dart';

class ServicesOnController extends GetxController{
  RxBool isLoading = false.obs;
  RxList<String> selectedCategory = <String>[].obs;
  RxBool switchValues = false.obs;
  StorageService storageService = StorageService();
  var category_data = Rx<String?>(null);
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadCategory();
  }

  Future<void> loadCategory() async {
    var getuserId = storageService.getUserid();
    CollectionReference servicesCollection = FirebaseFirestore.instance.collection('Services-Provider(Provider)');
    try {
      QuerySnapshot querySnapshot = await servicesCollection.where("userId",isEqualTo: getuserId).where("serviceStatus",isEqualTo: "denied").get();
      querySnapshot.docs.forEach((doc) {
        selectedCategory.add(doc["service_name"]);
      });
    } catch (e) {
      print("The Error Is $e");
    }
  }

  void setSelectedService(String? service) {
    category_data.value = service;
    update();
  }


  Future<bool> startServices() async {
    try{
      var getuserId = storageService.getUserid();
      if(switchValues.value){
        isLoading.value = true;
        CollectionReference servicesCollection = FirebaseFirestore.instance.collection('Services-Provider(Provider)');
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("Services-Provider(Provider)").where("service_name", isEqualTo: category_data.value) .where("userId",isEqualTo: getuserId).get();
        if(querySnapshot.docs.isNotEmpty){
          final QueryDocumentSnapshot documentSnapshot = querySnapshot.docs[0];
          Map<String, dynamic> data = documentSnapshot.data() as Map<String,dynamic>;
          ServiceResponseModel serviceResponseModel = ServiceResponseModel.fromMap(data);
          serviceResponseModel.serviceStatus = "available";
          var documentId = documentSnapshot.id;
          await FirebaseFirestore.instance.collection("Services-Provider(Provider)").doc(documentId).update(serviceResponseModel.toMap());

        }
        isLoading.value = false;
        return true;
      }else{
        return false;
      }
    }catch(e){
      return false;
    }
  }



  void updateToggleValues(bool values){
    switchValues.value = values;
    update();
  }
}