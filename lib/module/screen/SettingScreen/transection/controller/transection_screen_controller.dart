import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../../LocalStorage/StorageClass.dart';

import '../../Review/model/UserData.dart';
import '../model/transectionModel.dart';

class TransactionController extends GetxController {
  StorageService storageService = StorageService();
  RxBool isLoading = false.obs; // RxBool for reactive isLoading
  RxList<TransectionResModel> allData = <TransectionResModel>[].obs; // RxList for reactive allData
  RxList<UserData?> userData = <UserData?>[].obs; // RxList for reactive userData

  @override
  void onInit() {
    super.onInit();
    loadTransactionData();
  }

  void loadTransactionData() async {
    try {
      isLoading.value = true; // Updating isLoading to true

      String uid = storageService.getUserid();
      CollectionReference collectionReference = FirebaseFirestore.instance.collection("transectionCollection");

      // Using snapshots() directly to get the stream
      collectionReference.where("to", isEqualTo: uid).snapshots().listen((event) async {
        // Clearing lists inside listen() to update UI only once
        allData.clear();
        userData.clear();

        // Using for loop for async operation
        for (var element in event.docs) {
          TransectionResModel transectionResModel = TransectionResModel.fromMap(element.data() as Map<String, dynamic>);
          print("${transectionResModel.from}");
          if (transectionResModel.from == "admin") {
            print("He is The Admin");
            allData.add(transectionResModel);
            userData.add(UserData(
              address: "",
              email: "",
              fcmToken: "",
              firstName: "",
              lastName: "",
              phoneNumber: "",
              profileImage: "",
              uId: '',
            ));
          } else {
            print("he Is the User");
            allData.add(transectionResModel);
            UserData userDatas = await getUserData(id: transectionResModel.from);
            userData.add(userDatas);
          }
        }
        print("lentgh is ${allData.length}");
        isLoading.value = false;
        update();// Updating isLoading to false
      });
    } catch (e) {
      print("Error loading transaction data: $e");
      // Handle error appropriately, e.g., show an error message to the user
    }
  }

  Future<UserData> getUserData({required String id}) async {
    try {
      CollectionReference userCollection = FirebaseFirestore.instance.collection("User");
      print("User id: $id");
      DocumentSnapshot dd = await userCollection.doc(id).get();

      if (dd.exists) {
        print("User data: ${dd.data()}");
        return UserData.fromJson(dd.data() as Map<String, dynamic>);
      } else {
        print("User not found with id: $id");
        throw Exception("User not found with id: $id");
      }
    } catch (e) {
      print("Error getting user data: $e");
      throw e;
    }
  }
}
