import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../LocalStorage/StorageClass.dart';
import '../../../../Routes/Routes.dart';
import '../../Home/screen/authservices.dart';
import '../../RegisterDetails/model/ServicesData.dart';


class SettingsControllers extends GetxController {
  final AuthService _authService = Get.put(AuthService());
  StorageService _storageService = StorageService();
  var isLoading = false.obs;
  Rx<ServicesData?> servicesData = Rx<ServicesData?>(null);

  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadUserData();
  }

  void loadUserData() async {
    try{
      isLoading.value = true;
      String? uid = _auth.currentUser!.uid;
      FirebaseFirestore
          .instance
          .collection('service_providers')
          .where('Uid', isEqualTo: uid)
          .limit(1).snapshots().listen((QuerySnapshot<Map<String, dynamic>> snapshot) {
        if(snapshot.docs.isNotEmpty){
          servicesData.value  = ServicesData.formMap(snapshot.docs.first.data());
        }
      });
      isLoading.value = false;
    }catch(e){
      isLoading.value = false;
    }
  }
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _storageService.loginStatusCheck(false);
      Get.offAllNamed(Routes.loginScreen);// Replace '/login' with your login route
    } catch (e) {
      print('Error signing out: $e');
    }
  }

}
