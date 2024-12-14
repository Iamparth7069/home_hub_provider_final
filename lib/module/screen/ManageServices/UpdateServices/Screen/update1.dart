import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:home_hub_provider_final/utils/extension.dart';

import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';

import '../../../../../Routes/Routes.dart';
import '../../../../../constants/app_color.dart';
import '../../../Home/model/services.dart';
import '../Controller/updatecontroller.dart';


class UpdateData1 extends StatefulWidget {

  ServiceResponseModel service;

  UpdateData1(this.service);

  @override
  State<UpdateData1> createState() => _UpdateData1State(service);
}

class _UpdateData1State extends State<UpdateData1> {


  ServiceResponseModel service;

  _UpdateData1State(this.service);

  TextEditingController servicesName = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController price = TextEditingController();
  final update = Get.put(UpdateController());
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    description.text = service.description;
    servicesName.text = service.serviceName;
    price.text = service.price.toString();
  }

  final _globelkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Data"),
      ),
      body: Obx(
        () => update.UpdateLoading.value ? Form(
          key: _globelkey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal:17),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text("Select Images",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500)),
                  ),
                  1.h.addHSpace(),
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey,
                              width: 2.0,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 100,
                            backgroundColor: Colors.transparent,
                            child: Obx(
                                  () => update.imageFile.value != null ? Container(
                                child: ClipOval(
                                  child: Image.file(
                                    File(update.imageFile.value!.path),
                                    width: 130,
                                    height: 130,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ) :ClipOval(
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) {
                                      return LoadingAnimationWidget.hexagonDots(
                                          color: appColor, size: 5.h);
                                    },
                                    imageUrl: service.images[0],
                                    width: 130,
                                    height: 130,
                                    fit: BoxFit.cover,
                                  )
                              ),

                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 2,
                          right: 5,
                          child: CircleAvatar(
                            radius: 20,
                            child: IconButton(
                              onPressed: () async {
                                // _controller.remove();
                                update.updateImages(ImageSource.gallery);
                              },
                              icon: Icon(Icons.edit),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  1.h.addHSpace(),
                  Text("Update Services Name",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20),),
                  TextFormField(
                    controller: servicesName,
                    validator: (value) {
                      if(value == null || value.isEmpty){
                        return "Enter Services";
                      }else{
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  1.h.addHSpace(),
                  Text("Update Description",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20),),
                  TextFormField(
                    controller: description,
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    validator: (value) {
                      if(value == null || value.isEmpty){
                        return "Enter the Description";
                      }else{
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      labelText: "Description Of Services",

                      alignLabelWithHint: true,
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                    ),
                  ),
                  1.h.addHSpace(),
                  Text("Update Images",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20),),
                  1.h.addHSpace(),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Obx(
                              () =>  update.imagesPick.length == 0 ?  Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                            ),
                            child: GridView.builder(
                              shrinkWrap: true,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 8.0,
                                mainAxisSpacing: 8.0,
                              ),
                              itemCount: service.images.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: CachedNetworkImage(
                                    imageUrl: service.images[index],
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                            ),
                          ): Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                color: Colors.grey,
                                width: 2.0,
                              ),
                            ),
                            child:  GridView.builder(
                              shrinkWrap: true,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 8.0,
                                mainAxisSpacing: 10.0,
                              ),
                              itemCount: update.imagesPick.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Image.file(
                                  File(update.imagesPick[index].path),
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                update.pickPosterImages();
                              },
                              child: Icon(Icons.update),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'Update Image',
                              style: TextStyle(fontSize: 16.0),
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                  1.h.addHSpace(),
                  Text("Update Price",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20),),
                  TextFormField(
                    validator: (value) {
                      if(value == null || value.isEmpty){
                        return "Enter the Price";
                      }else{
                        return null;
                      }
                    },
                    controller: price,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)
                        )
                    ),
                  ),
                  2.h.addHSpace(),
                  appButton(text: "Updated Data",onTap: () async {
                    if(_globelkey.currentState!.validate()){
                      String descriptions = description.text.toString();
                      String servicesNames = servicesName.text.toString();
                      int updatePrice = int.parse(price.text);
                      bool updateCheckError =await update.updatedData(listOfImages: service.images,price: updatePrice,desc: descriptions,sname: servicesNames,serviceId: service.serviceIds!);
                      if(updateCheckError){
                        Get.offAllNamed(Routes.navbarRoots);
                      }else{
                        Get.snackbar("Network Error", "Check Your Connection",snackPosition: SnackPosition.BOTTOM,backgroundColor: appColor);
                      }
                    }else{
                      Get.snackbar("Error", "Please Fill The Data",snackPosition: SnackPosition.BOTTOM,backgroundColor: appColor);
                    }
                  }),
                  2.h.addHSpace(),

                ],
              ),
            ),
          ),
        ):LoadingAnimationWidget.hexagonDots(color: appColor, size: 5.h),
      ),
    );
  }
}
