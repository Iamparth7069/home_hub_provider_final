
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_hub_provider_final/utils/extension.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';

import '../../../../../constants/app_color.dart';
import '../Controller/AddservicesController.dart';

class AddServices extends StatelessWidget {
  AddServicesController _controller = Get.put(AddServicesController());

  final _globalKey = GlobalKey<FormState>();

  final _SecondKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Services",style: TextStyle(fontSize: 25,fontWeight:FontWeight.bold),),

      ),
      body: Obx(() => _controller.showContent.value ? Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _SecondKey,
          child: Obx(
            () => _controller.IsLoadding.value ?  LoadingAnimationWidget.hexagonDots(color: appColor, size: 5.h) : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Service Description",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                  TextFormField(
                    controller: _controller.description,
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
                  2.h.addHSpace(),
                  Text("Select Images",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w500)),
                  1.h.addHSpace(),
                  Container(
                    height: 150,
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Obx(
                                () =>  _controller.pickedImages.length == 0 ? Container(
                              child: Center(child: const Text("No Image Selected")),
                            ) :Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                              ),
                              child:  GridView.builder(
                                shrinkWrap: true,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 8.0,
                                  mainAxisSpacing: 8.0,
                                ),
                                itemCount: _controller.pickedImages.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Image.file(
                                    File(_controller.pickedImages[index].path),
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
                                  _controller.pickPosterImages();
                                },
                                child: Icon(Icons.add),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                'Add Image',
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  1.5.h.addHSpace(),
                  const Text("Price Of Services",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                  1.5.h.addHSpace(),
                  TextFormField(
                    validator: (value) {
                      if(value == null || value.isEmpty){
                        return "Enter the Price";
                      }else{
                        return null;
                      }
                    },
                    keyboardType: TextInputType.number,
                    controller: _controller.price,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                      )
                    ),
                  ),
                  2.h.addHSpace(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: appButton(onTap: (){
                        _controller.toggleContent();
                      },
                          text: "Back",
                          color: Colors.grey,fontColor: Colors.black)),
                      2.w.addWSpace(),
                      Expanded(child: appButton(onTap: () async {
                        if(_SecondKey.currentState!.validate()){
                         var check =  await  _controller.uploadDataInFirebase();
                         if(check){
                           Get.back();
                         }else{
                           print("Error");
                         }
                        }
                      },
                        text: "Add Services",
                      ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ) : SingleChildScrollView(
        child: Form(
          key: _globalKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 10.h,
              ),
              "Services Image Pick".mediumReadex(fontSize: 20,fontColor: appColor),
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
                      child: Obx(() {
                        final imageFile =
                            _controller.imageFile.value;
                        return imageFile != null
                            ? CircleAvatar(
                          radius: 100,
                          backgroundColor: Colors.transparent,
                          child: ClipOval(
                            child: Image.file(
                              imageFile,
                              width: 130,
                              height: 130,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                            : Icon(
                          Icons.person,
                          size: 100,
                          color: Colors.grey,
                        );
                      }),
                    ),
                    Obx(
                          () => _controller.imageFile.value != null ? Positioned(
                        bottom: 2,
                        right: 5,
                        child: CircleAvatar(
                          radius: 20,
                          child: IconButton(
                            onPressed: () async {
                              _controller.remove();
                            },
                            icon: Icon(Icons.remove),
                          ),
                        ),
                      ) : Positioned(
                        bottom: 2,
                        right: 5,
                        child: CircleAvatar(
                          radius: 20,
                          child: IconButton(
                            onPressed: () async {
                              await _controller.pickImage();
                            },
                            icon: Icon(Icons.add),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              3.h.addHSpace(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _controller.serviceName,
                  validator: (value) {
                    if(value == null || value.isEmpty){
                      return "Enter Category Name ";
                    }else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: "Category Name",
                  ),
                ),
              ),
              1.h.addHSpace(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Obx(
                      () => _controller.categoryServices == null
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
                      value: _controller
                          .categoryServices.value,
                      hint: const Text('Selected Services'),
                      onChanged: (String? newValue) {
                        _controller.setSelectedService(newValue);
                      },
                      items: _controller
                          // ignore: invalid_use_of_protected_member
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
              ),
              3.h.addHSpace(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: appButton(onTap: (){
                      _controller.Dispose();
                      Get.back();

                    },
                        text: "Cancel",
                        color: Colors.grey,fontColor: Colors.black)),
                    2.w.addWSpace(),

                    Expanded(child: appButton(onTap: (){
                     if(_globalKey.currentState!.validate()){
                        _controller.toggleContent();
                      // _controller.Dispose();
                     }else{
                       print("Form Details Submit");
                     }
                    },
                      text: "Next",
                    ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),)
    );
  }
}
