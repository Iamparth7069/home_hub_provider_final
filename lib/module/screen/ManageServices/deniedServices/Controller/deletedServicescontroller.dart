import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


import '../../../../../LocalStorage/StorageClass.dart';
import '../../../Home/model/services.dart';

class servicesOffController extends GetxController {
  StorageService storageService = StorageService();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getCurrentUser();
    loadCategory();
  }

  @override
  void dispose() {
    // Clean up tasks such as closing streams, canceling subscriptions, etc.
    category_data.close();
    services_data.close();
    super.dispose();
  }

  RxList<ServiceResponseModel> services = <ServiceResponseModel>[].obs;

  var category_data = Rx<String?>(null);
  var services_data = Rx<String?>(null);
  RxString userid = RxString('');
  RxBool isLoading = false.obs;
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

  void getCurrentUser() {
    var getuserId = storageService.getUserid();
    if (getuserId.isNotEmpty) {
      userid.value = getuserId;
    } else {

      print("Error ");
    }
  }

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
      // Change "fieldName" to the actual field name you want to extract
      String fieldValue = document['ServiceName'];

      if (fieldValue != null) {
        selectServices.add(fieldValue);
      }
    }
    update();
  }
  Future<bool> deleteDocumentAndSubcollections(String collectionPath) async {
    try {
      isLoading.value = true;
      final QuerySnapshot parentSnapshot  = await FirebaseFirestore.instance
          .collection("Services-Provider(Provider)")
          .where("category_name", isEqualTo: category_data.value)
          .where("service_name", isEqualTo: services_data.value)
          .where("userId",isEqualTo: userid.value)
          .get();

      if(parentSnapshot.docs.isNotEmpty) {
        final QueryDocumentSnapshot documentSnapshot = parentSnapshot.docs[0];
        Map<String, dynamic> data = documentSnapshot.data() as Map<String,dynamic>;
        ServiceResponseModel serviceResponseModel = ServiceResponseModel.fromMap(data);
        print("document id ${documentSnapshot.id}");
        serviceResponseModel.serviceStatus = "denied";
        var documentId = documentSnapshot.id;
        await FirebaseFirestore.instance.collection("Services-Provider(Provider)").doc(documentId).update(serviceResponseModel.toMap());
      }
      isLoading.value = false;
      return true;
    } catch (e) {
      isLoading.value = false;
      return false;
    }
  }

}
