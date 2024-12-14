import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

import '../../../../LocalStorage/StorageClass.dart';
import '../../Home/model/OrderResModel.dart';
import '../../SettingScreen/Review/model/UserData.dart';


class SeduleScreen extends GetxController {
  List<OrderResModel> pending = [];
  List<OrderResModel> completed = [];
  List<OrderResModel> canceled = [];
  List<UserData> userdatas = [];
  final StorageService _storageService = StorageService();
  bool load = false;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadSeduleScreen();
  }

  void loadSeduleScreen() {
    load = true;
    String uid = _storageService.getUserid();
    Stream<QuerySnapshot> allData = FirebaseFirestore.instance.collection("Orders").where("serviceProviderId", isEqualTo: uid).snapshots();
    allData.listen((event) {
      pending.clear();
      completed.clear();
      canceled.clear();
      event.docs.forEach((element) async {
        Map<String, dynamic> data = element.data() as Map<String, dynamic>;
        OrderResModel orderResModel = OrderResModel.fromJson(data);
        UserData userData = await GetUserData(orderResModel.userId);
        userdatas.add(userData);
        if(orderResModel.status == "Pending"){
          pending.add(orderResModel);
          update();
        }else if(orderResModel.status == "Accepted"){
          completed.add(orderResModel);
          update();
        }else if(orderResModel.status == "Completed"){
          completed.add(orderResModel);
          update();
        }else{
          canceled.add(orderResModel);
        }
      });
      update();
    });
    load = false;
  }
  GetUserData(String? userId) async {
    CollectionReference serviceProviderUserCollection = FirebaseFirestore.instance.collection("User");
    QuerySnapshot userData = await serviceProviderUserCollection.where("uId", isEqualTo: userId).get();
    if (userData.docs.isNotEmpty) {
      return UserData.fromJson(userData.docs.first.data() as Map<String, dynamic>);
    }
  }


  Future<void> cancel(OrderResModel order) async {
    order.status = "Cancel";
    await FirebaseFirestore.instance.collection("Orders").doc(order.orderId).update(order.toJson());
  }


  Future<void> reConform(OrderResModel order) async{
    order.status = "Pending";
    await FirebaseFirestore.instance.collection("Orders").doc(order.orderId).update(order.toJson());
  }



  Future<void> deleteOrder(String orderId) async {
    try {
      await FirebaseFirestore.instance.collection("Orders").doc(orderId).delete();
      print("remove");
    } catch (e) {
      print("Error deleting order: $e");
    }
  }


  Future<void> actupted(OrderResModel order, UserData userdata)
  async {
    String name = _storageService.getName();
    order.status = "Accepted";
    print("User Name ${userdata.firstName}");
    await FirebaseFirestore.instance.collection("Orders").doc(order.orderId).update(order.toJson());
  }

  Future<void> comp(OrderResModel order) async {
    try {
       await updateAmount(order.amount!);
       order.status = "Completed";
      await FirebaseFirestore.instance
          .collection("Orders")
          .doc(order.orderId)
          .update(order.toJson());
    } catch (e) {
      print('${e.toString()}');
    }
  }

  Future<void> updateAmount(int amount) async {
    String userid = _storageService.getUserid();
    print("User Id ${userid}");
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("service_providers")
        .doc(userid)
        .get();

    int total = 0;
    if (snapshot.exists) {
      // Access the specific field you need
      var datas = snapshot.data() as Map<String,dynamic>;
      total = datas["total-payment"];
    } else {
      print("Document does not exist");
    }
    total = total + amount!;
    await FirebaseFirestore.instance
        .collection("service_providers")
        .doc(userid)
        .update({
      "total-payment": total,
    });
  }
}
