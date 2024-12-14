import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_clippers/custom_clippers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:home_hub_provider_final/utils/extension.dart';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/get_rx.dart';

import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';
import '../../../../LocalStorage/StorageClass.dart';
import '../../../../constants/app_color.dart';
import '../../Home/model/services.dart';
import '../../SettingScreen/Review/model/UserData.dart';

import '../Model/ChatRoomResModel.dart';
import '../controller/MessageScreenController.dart';


class ChatScreen extends StatefulWidget {
  ChatRoomResModel chatroom;
  UserData userData;
  String roomId;
  ChatScreen(this.chatroom,this.userData,this.roomId);
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override

  late ScrollController _scrollController;

  final List<String> _messages = List.generate(50, (index) => 'Message $index');


  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();

    loadData();
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose the controller to prevent memory leaks
    super.dispose();
  }

  RxList<ServiceResponseModel> servsiceData = <ServiceResponseModel>[].obs;
  MessegeController _messegeController = Get.put(MessegeController());
  final StorageService _storageService = StorageService();
  final datasend = TextEditingController();

  final description = TextEditingController();
  DateTime date = DateTime.now();

  final price = TextEditingController();
  final _globel = GlobalKey<FormState>();
  void sendMesseges() async {
    try {
      if (datasend.text.trim().isNotEmpty && widget.chatroom.docId != null && widget.userData.fcmToken != null) {
        Map<String, dynamic> messege = {
          "sendBy": _storageService.getUserid(),
          "msg": datasend.text.toString().trim(),
          "msgType": "text",
          "createdAt": DateTime.now(),
        };
        await FirebaseFirestore.instance
            .collection('chatRoom')
            .doc(widget.chatroom.docId!)
            .collection('messages')
            .add(messege);
        DateTime dateTime = DateTime.now();
        // String name = _storageService.getName();

        CollectionReference chatRoomCollection = FirebaseFirestore.instance.collection("chatRoom");
        await chatRoomCollection.doc(widget.roomId).update({
          "LastChatTime": dateTime, "LastChat": datasend.text.toString().trim(), "lastMsgType": "text"
        });
        datasend.clear();
      } else {
        print("Enter some text or invalid chat room or user data");
      }
    } catch (e) {
      print("Error sending message: $e");
    }
  }


  Future<void> loadData() async {
    String uid = _storageService.getUserid();
    print("User id ${uid}");
    CollectionReference servicesCollection = FirebaseFirestore.instance.collection('Services-Provider(Provider)');
    QuerySnapshot datas = await servicesCollection.where("userId", isEqualTo: uid).get();
    datas.docs.forEach((doc) async {
      ServiceResponseModel serviceResponseModel = ServiceResponseModel.fromMap(doc.data() as Map<String, dynamic>);
      // Store the document with the model data
      servsiceData.add(serviceResponseModel);
    });
  }

  var category_data = Rx<String?>(null);

  void setSelectedService(String? service) {
    category_data.value = service;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          backgroundColor: Color(0xFF7165D6),
          leadingWidth: 30,
          title: Padding(
            padding: EdgeInsets.only(top: 8),
            child: Row(
              children: [
                Container(
                  height: 50,
                  width: 50, // Adjusted width to make it a perfect circle
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, // Changed to BoxShape.circle
                  ),
                  child: ClipOval(
                    child: widget.userData.profileImage.isEmpty
                        ? Image.asset(
                      "assets/images/profile_image.jpg",
                      fit: BoxFit.cover,
                    )
                        : CachedNetworkImage(
                      placeholder: (context, url) {
                        return LoadingAnimationWidget.hexagonDots(
                            color: appColor, size: 3.h);
                      },
                      fit: BoxFit.cover,
                      imageUrl: widget.userData.profileImage,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.01,
                  ),
                  child: Text(
                    "${widget.userData.firstName} ${widget.userData.lastName}",
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
              ],
            ),
          ),

            actions: [
            Padding(
              padding: EdgeInsets.only(top: 8, right: 20),
              child: IconButton(
                onPressed: () async {
                  // await FlutterPhoneDirectCaller.callNumber(widget.userData.phoneNumber);
                },
                icon: Icon( Icons.call,
                  color: Colors.white,
                  size: 26,),

              ),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("chatRoom")
                  .doc(widget.chatroom.docId)
                  .collection("messages")
                  .orderBy('createdAt', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LoadingAnimationWidget.hexagonDots(
                            color: appColor, size: 5.h),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Data Get Error"),
                      ],
                    ),
                  );
                } else {
                  return ListView.builder(
                    controller: _scrollController,
                      itemCount: snapshot.data!.docs.length,
                      padding: EdgeInsets.only(
                          top: 20, left: 15, right: 15, bottom: 80),
                      itemBuilder: (context, index) {
                        Map<String, dynamic>? map = snapshot.data!.docs[index]
                            .data() as Map<String, dynamic>;
                        return messeges(map);
                      });
                }
              },
            ),
          ),
          Container(
            height: 65,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: IconButton(
                      onPressed: () async {
                         await showModelSheet(context);
                      },
                      icon: Icon(
                        Icons.add,
                        size: 30,
                      )),
                ),
                // Padding(padding: EdgeInsets.only(left: 5),child: Icon(Icons.emoji_emotions_outlined,color: Colors.amber,size: 30,),),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Container(
                    alignment: Alignment.centerRight,
                    width: 240,
                    child: TextFormField(
                      controller: datasend,
                      decoration: InputDecoration(
                        hintText: "Type Something",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.only(right: 6),
                  child: IconButton(
                    onPressed: () async {
                      sendMesseges();
                      _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: 300.milliseconds, curve: Curves.bounceInOut);
                    },
                    icon: Icon(Icons.send),
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget messeges(Map maps) {
    if (maps["msgType"] == "offers") {
      print(maps["status"]);
      Timestamp timestamps = maps["daysToWork"];
      DateTime dateTime = timestamps.toDate();
      final day = dateTime.day;
      final month = dateTime.month;
      final year = dateTime.year;
      return Padding(
        padding:  maps["sendBy"] == _storageService.getUserid()  ?  EdgeInsets.only(left: 80,top: 20) : EdgeInsets.only(top: 20,right: 80),
        child: Container(
          alignment: maps["sendBy"] == _storageService.getUserid() ?  Alignment.centerRight : Alignment.centerLeft,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade200,
          ),
          child:Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  Text('${maps["description"]}',style: TextStyle(fontWeight: FontWeight.w500),),
                Text("Phone Number And Email"),
                Row(
                  children: [
                    SvgPicture.asset("assets/images/rupes.svg",height: 22,),
                    2.w.addWSpace(),
                    Row(
                      children: [
                        Text("Price : ${maps["price"]}"),
                      ],
                    ),
                  ],
                ),
                0.6.h.addHSpace(),
                Row(
                  children: [
                    Icon(Icons.timer),
                    2.w.addWSpace(),
                    Text("Completed At : ${day}-${month}-${year}"),
                  ],
                ),
                0.6.h.addHSpace(),
                Row(
                  children: [
                    Icon(Icons.sync),
                    Flexible(child: Text(" Services : ${maps["service_name"]}",overflow: TextOverflow.ellipsis,)),
                  ],
                ),
                1.h.addHSpace(),
                1.w.appDivider(),
                MaterialButton(
                  color: maps["status"] == "Confirmed" ? Colors.grey : appColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Adjust radius as needed
                  ),
                  child: Center(child:   Text(  maps["status"] == "Confirmed" ? "Offer Accepted" : "Offer expired",style: TextStyle(color: Colors.white),)),
                  onPressed: () async {
                    // print(maps[""]);
                    String MesegeId = maps["messageId"];
                     await _messegeController.deletedOffer(MesegeId);
                },),
                1.h.addHSpace(),
              ],
            ),
          ),
        ),
      );
    } else {
      return maps['sendBy'] == _storageService.getUserid() ? Container(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 80),
          child: ClipPath(
            clipper: LowerNipMessageClipper(MessageType.send),
            child: Container(
              padding:
              EdgeInsets.only(left: 5.w, top: 10, bottom: 25, right: 5.w),
              decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color(0xff9b56ff),
                    Color(0xff7413ff),
                  ])),
              child: Text(
                maps["msg"],
                style: TextStyle(
                  fontSize: 13.5.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ) : Container(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(right: 80, top: 10),
          child: ClipPath(
            clipper: UpperNipMessageClipper(MessageType.receive),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFE1E1E2),
              ),
              child: Text(
                maps["msg"],
                style: TextStyle(
                  fontSize: 13.5.sp,
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  showModelSheet(BuildContext context) async {
    final focusNode = FocusNode();
    return Get.bottomSheet(
      SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15)),
            ),
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _globel,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    1.h.addHSpace(),
                    Text("Apply Offers",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold)),
                    1.h.addHSpace(),
                    TextFormField(
                      controller: description,
                      focusNode: focusNode,
                      validator: (value) {
                        if(value == null || value.isEmpty){
                          return "Enter the description";
                        }else{
                          return null;
                        }
                      },
                      maxLines: 3,
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        labelText: 'Description',
                        hintText: "Description",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Select Services",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                          IconButton(onPressed: () {

                          }, icon: Icon(Icons.more_vert))
                        ],
                      ),
                    ),
                    Obx(
                          () => category_data == null
                          ? Container()
                          : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          borderRadius: BorderRadius.circular(10),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a Category'; // Validation message
                            }
                            return null; // Return null if validation succeeds
                          },
                          value: category_data.value,
                          hint: const Text('Selected Category'),
                          onChanged: (String? newValue) {
                            setSelectedService(newValue);
                          },
                          items: servsiceData.map((ServiceResponseModel services) {
                            return DropdownMenuItem<String>(
                              value: services.serviceIds,
                              child: Text(services.serviceName),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    1.h.addHSpace(),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Single Payment",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                          Text("Change",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.greenAccent,
                                  fontSize: 20)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          "Total price".semiBoldReadex(fontSize: 20),
                          Row(
                            children: [
                              Text("Rs : "),
                              SizedBox(
                                height: 70,
                                width: 70,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter Price'; // Validation message
                                    }
                                    else{
                                      return null;
                                    }
                                  },
                                  controller: price,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12))),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          "Delivery Time".semiBoldReadex(fontSize: 20),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8,
                              right: 8,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                _messegeController.select(context);
                              },
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Icon(
                                      Icons.calendar_today,
                                      color: Color(0xFF3A5160),
                                      size: 18,
                                    ),
                                  ),
                                  Obx(() => Text(
                                        '${DateFormat('d MMMM').format(_messegeController.selectedDate.value)}',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontFamily: "Roboto",
                                          fontWeight: FontWeight.normal,
                                          fontSize: 18,
                                          letterSpacing: -0.2,
                                          color: Color(0xFF17262A),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    appButton( text: "Send Offers" , onTap: () async {
                      if(_globel.currentState!.validate()){
                        print("Call");
                        String? servicesName = getServicesName(category_data.value);
                        bool checkCondition =await _messegeController.sendTheOffers(date,price.text.toString().trim(),description.text.toString().trim(),widget.chatroom.docId,category_data.value!,widget.userData.fcmToken!,servicesName!);
                        if(checkCondition){
                          price.text = "";
                          description.text = "";
                          _messegeController.cleanDateTime();
                          category_data.value = null;
                          Get.back();
                        }
                      }else{
                        print("Data Insert");
                      }
                    }),
                    1.h.addHSpace(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? getServicesName(String? id) {
      for(var data in servsiceData){
        if(data.serviceIds == id){
          return data.serviceName;
        }
      }
      return null;
  }
}
