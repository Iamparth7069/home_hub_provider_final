import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_hub_provider_final/utils/extension.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';

import '../../../../../constants/app_color.dart';
import '../Controller/servicesOnController.dart';

class ServicesOn extends StatefulWidget {
   ServicesOn({super.key});

  @override
  State<ServicesOn> createState() => _ServicesOnState();
}

class _ServicesOnState extends State<ServicesOn> {

  ServicesOnController servicesOnController = Get.put(ServicesOnController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Services On",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),

      ),
      body: Obx(
        () =>  servicesOnController.isLoading.value ? Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoadingAnimationWidget.hexagonDots(color: appColor, size: 5.h),
          ],
        ),) : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Selected Services",style: TextStyle(fontSize: 19,color: Colors.black,fontWeight: FontWeight.bold),),
              1.h.addHSpace(),
              Obx(
                    () => servicesOnController.category_data == null
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
                    value: servicesOnController.category_data.value,
                    hint: const Text('Selected Services'),
                    onChanged: (String? newValue) {
                      servicesOnController.setSelectedService(newValue);
                    },
                    items: servicesOnController
                        .selectedCategory.value
                        .map((String service) {
                      return DropdownMenuItem<String>(
                        value: service,
                        child: Text(service),
                      );
                    }).toList(),
                  ),
                ),
              ),

              2.h.addHSpace(),
              Obx(() {
                return  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Service Start",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                    Text("=>",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                    Switch(
                      value: servicesOnController.switchValues.value,
                      onChanged: (newValue) {
                        servicesOnController.updateToggleValues(newValue);
                      },
                    ),
                  ],
                );
              }),
              Expanded(child: Container()),
              appButton(text: "Enable",onTap: ()async{
                bool check = await servicesOnController.startServices();
                if(check){
                  Get.back();
                }else{
                  Get.snackbar("Service Error","Please Start The Toggle button");
                }
              }),
              1.h.addHSpace(),
            ],
          ),
        ),
      ),
    );
  }
}
