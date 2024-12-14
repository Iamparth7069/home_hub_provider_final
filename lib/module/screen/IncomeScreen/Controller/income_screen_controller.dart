import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../LocalStorage/StorageClass.dart';
import '../../Home/model/OrderResModel.dart';
import '../../SettingScreen/Review/model/UserData.dart';

class IncomeController extends GetxController{

  RxList<OrderResModel> order;
  final StorageService _storageService = StorageService();

  IncomeController(this.order);
  RxList<UserData> user = <UserData>[].obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadUserData(order);
  }

  RxBool isLoading =false.obs;

  Future<void> loadUserData(RxList<OrderResModel> order) async {
    isLoading.value = true;
    CollectionReference serviceProviderUserCollection = FirebaseFirestore.instance.collection("User");
    for(var DataOrder in order){
      OrderResModel order = DataOrder;
      QuerySnapshot userData = await serviceProviderUserCollection.where("uId", isEqualTo: DataOrder.userId).get();
      if(userData.docs.isNotEmpty){
        UserData userDatas = UserData.fromJson(userData.docs.first.data() as Map<String, dynamic>);
        user.add(userDatas);
      }
    }
    isLoading.value = false;
    update();
  }

  Future<bool> withdraw(int amount,String upiId, int totalAmount) async {
    try{

      String userUid = _storageService.getUserid();

      DateTime dateTime = DateTime.now();

      var time = Timestamp.fromDate(dateTime);

      int calculate = totalAmount - amount;

      print("The Amount is $amount");
      print("The Total Amount is $totalAmount");
      await FirebaseFirestore.instance.collection("service_providers").doc(userUid).update({
        "total-payment" : calculate,
      });

      await FirebaseFirestore.instance.collection("Payment_request").add({
        "date" : time,
        "uipIndia" : upiId,
        "ProviderId" : userUid,
        "amount" : amount,
        "type" : "withdraw"
      });
      return true;
    }catch(e){
      print(e.toString());
      return false;
    }
  }
}