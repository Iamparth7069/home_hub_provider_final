import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:home_hub_provider_final/utils/extension.dart';

import 'package:sizer/sizer.dart';

import '../../../../Routes/Routes.dart';
import '../../../../constants/app_color.dart';
import '../../Home/model/OrderResModel.dart';
import '../../RegisterDetails/model/ServicesData.dart';
import '../Controller/income_screen_controller.dart';


class IncomeScreen extends StatefulWidget {
  final RxList<OrderResModel> order;
  Rx<ServicesData> userData;

  IncomeScreen(this.order,this.userData);

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  int totalAmount = 0;
  bool isLoading = false;
  double withdraw = 0.0;
  @override
  void initState() {
    super.initState();
    calculateData(widget.userData);
  }

  final number = TextEditingController();
  final uipId = TextEditingController();
  final globel = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final amount =  widget.userData.value.totalPayment!;
    IncomeController controller = Get.put(IncomeController(widget.order));
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "All orders",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_outlined),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Total Amount ${withdraw}",
              style: TextStyle(
                fontSize: 18,
                color: appColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          )
        ],
      ),
      body: GetBuilder<IncomeController>(
        builder: (controller) {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.order.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      String day = widget.order.value[index].completeDate!.day.toString();
                      String mounth  = widget.order.value[index].completeDate!.month.toString();
                      String year = widget.order.value[index].completeDate!.year.toString();
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 22,
                            backgroundImage: CachedNetworkImageProvider(
                              controller.user[index].profileImage ?? "",
                            ),
                          ),
                          title: Text(
                            "${controller.user[index].firstName} ${controller.user[index].lastName}",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(
                                "${day}/${mounth}/${year}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Status : ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text("${widget.order[index].status}", style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),)
                                ],
                              )
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                "assets/images/rupes.svg",
                                height: 20,
                              ),
                              Text(
                                "${widget.order[index].amount}",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    height: 6.h,
                    color: appColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onPressed: () {
                      // Open bottom sheet on button click
                      openBottomSheet(context, controller);
                    },
                    child: Text(
                      "Withdrawal",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
                2.h.addHSpace(),
              ],
            );
          }
        },
      ),
    );
  }


  Future openBottomSheet(BuildContext context, IncomeController controller) {
    final focusNode = FocusNode();
    return Get.bottomSheet(
      Form(
        key: globel,
        child: Container(
          height: 360,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 5.h, // Specify the height of the IconButton
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Handle IconButton press
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 13),
                  child: Row(
                    children: [
                      Text(
                        "Balance :",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      SvgPicture.asset(
                        "assets/images/rupes.svg",
                        height: 20,
                      ),
                      Text(
                        "${withdraw}",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 13),
                  child: Text("20% Admin " ,style: TextStyle(color: Colors.red),),
                ),
                1.h.addHSpace(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 13),
                  child: Text(
                    "Enter Amount Request:",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                ),
                1.h.addHSpace(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    controller: number,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter the Amount";
                      } else {
                        try {
                          double parsedValue = double.parse(value);
                          if (parsedValue > withdraw) {
                            return 'Please enter a value less than or equal to the total amount';
                          }
                        } catch (e) {
                          return 'Please enter a valid number';
                        }
                      }
                      return null; // Return null if validation passes
                    },
                    decoration: InputDecoration(
                      hintText: "\$100",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 13),
                  child: Text(
                    "Enter Uip Id:",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                ),
                1.h.addHSpace(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    controller: uipId,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter Uip Id Withdraw';
                      }
                      return null; // Return null if validation passes
                    },
                    decoration: InputDecoration(
                      hintText: "abc@oksbi.com",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                1.h.addHSpace(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: MaterialButton(
                    height: 50,
                    color: Colors.red,
                    shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    minWidth: double.infinity,
                    child: const Text("Request"),
                    onPressed: () async {
                      if (globel.currentState!.validate()) {
                        int amount = withdraw.toInt();
                        int total = int.parse(number.text);
                        String upiIndia = uipId.text.toString().trim();
                         bool ischeck = await controller.withdraw(total,upiIndia,amount);
                        if(ischeck){
                          number.clear();
                          uipId.clear();
                          _showAlertDialog(context);
                        }else {
                          print("No Data Return");
                        }
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAlertDialog(BuildContext context) {
    showDialog<String>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title:const Text('Request Send Admin'),
        content: const Text('Your request is send to admin wait for 1 or 2 working days accepted request to show notification!'),
        actions: <Widget>[
          appButton(
              text: "Agree",
              onTap: (){
                Get.offAllNamed(Routes.navbarRoots);
              })
        ],
      ),
    );
  }

  void calculateData(Rx<ServicesData> userData) {
    var discount = userData.value.totalPayment! * 20 / 100;
    withdraw = userData.value.totalPayment! - discount;
    setState(() {

    });
  }
}
