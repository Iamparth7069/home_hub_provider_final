import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:home_hub_provider_final/utils/extension.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';

import '../../../../../constants/app_color.dart';
import '../Controller/deletedServicescontroller.dart';

class ServicesOff extends StatefulWidget {
   ServicesOff({super.key});

  @override
  State<ServicesOff> createState() => _ServicesOffState();
}

class _ServicesOffState extends State<ServicesOff> {
   final deleteController = Get.put(servicesOffController());

   final _globalKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("Denied Services",style: TextStyle(fontSize: 25,fontWeight:FontWeight.bold),),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Form(
          key: _globalKey,
          child: Obx(
            () => deleteController.isLoading.value ? LoadingAnimationWidget.hexagonDots(color: appColor, size: 5.h) :  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                1.h.addHSpace(),
                Text("Selected Services",style: TextStyle(fontSize: 19,color: Colors.black,fontWeight: FontWeight.w400),),
                1.h.addHSpace(),
                Obx(
                      () => deleteController.category_data == null
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
                      value: deleteController.category_data.value,
                      hint: const Text('Selected Services'),
                      onChanged: (String? newValue) {
                        deleteController.setSelectedService(newValue);
                      },
                      items: deleteController
                          .selectServices.value
                          .map((String service) {
                        return DropdownMenuItem<String>(
                          value: service,
                          child: Text(service),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                1.h.addHSpace(),
                Text("Selected Category",style: TextStyle(fontSize: 19,color: Colors.black,fontWeight: FontWeight.w400),),
                1.h.addHSpace(),
                Obx(
                      () => deleteController.services_data == null
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
                      value: deleteController.services_data.value,
                      hint: const Text('Selected Category'),
                      onChanged: (String? newValue) {
                        deleteController.setSelectedCategory(newValue);
                      },
                      items: deleteController
                          .selectedCategory
                          .map((String service) {
                        return DropdownMenuItem<String>(
                          value: service,
                          child: Text(service),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                1.h.addHSpace(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 12),
                  child: appButton(text: "Denied Services",onTap: () async {
                    var checkData =  await deleteController.deleteDocumentAndSubcollections("Services-Provider(Provider)");
                    if(checkData){
                      Get.back();
                    }else{
                      print("Error");
                    }
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
