import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:home_hub_provider_final/utils/extension.dart';

import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';

import '../../../../../constants/app_assets.dart';
import '../../../../../constants/app_color.dart';
import '../../../RegisterDetails/model/ServicesData.dart';
import '../controller/profileDataController.dart';



class ProfileData extends StatefulWidget {
  ProfileData({Key? key}) : super(key: key);

  @override
  State<ProfileData> createState() => _ProfileDataState();
}

class _ProfileDataState extends State<ProfileData> {
  ProfileDataController updateController = Get.put(ProfileDataController());
  final _globelkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile Update",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Obx(
              () => updateController.isloading.value ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoadingAnimationWidget.hexagonDots(color: appColor, size: 5.h),
            ],
          ) : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: FutureBuilder(
              future: updateController.loadUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Center(child: Text("No Data Found (404 Error)"));
                } else {
                  List<ServicesData>? servicesData = snapshot.data;
                  updateController.fname.text = servicesData![0].fname;
                  updateController.lname.text = servicesData![0].lname;
                  updateController.address.text = servicesData[0].address;
                  updateController.contact.text = servicesData[0].contectnumber;
                  updateController.contactOpp.text = servicesData[0].contectNumber2;
                  updateController.email.text = servicesData[0].email;

                  return Form(
                    key: _globelkey,
                    child: ListView(
                      children: [
                        Column(
                          children: [
                            Text("Update User Images"),
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
                                            () => updateController.imageFile.value !=
                                            null
                                            ? Container(
                                          child: ClipOval(
                                            child: Image.file(
                                              File(updateController
                                                  .imageFile.value!.path),
                                              width: 130,
                                              height: 130,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )
                                            : ClipOval(
                                            child: CachedNetworkImage(
                                              placeholder: (context, url) {
                                                return LoadingAnimationWidget
                                                    .hexagonDots(
                                                    color: appColor,
                                                    size: 5.h);
                                              },
                                              imageUrl: servicesData![0].Images,
                                              width: 130,
                                              height: 130,
                                              fit: BoxFit.cover,
                                            )),
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
                                          updateController
                                              .updateImages(ImageSource.gallery);
                                        },
                                        icon: Icon(Icons.edit),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            2.h.addHSpace(),
                            SizedBox(
                              width: double.infinity,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child: TextFormField(
                                        controller: updateController.fname,
                                        keyboardType: TextInputType.name,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Enter the First Name";
                                          } else {
                                            return null;
                                          }
                                        },
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          labelText: "First Name",
                                          hintText: "First Name",
                                          floatingLabelBehavior:
                                          FloatingLabelBehavior.auto,
                                        ),
                                      )),
                                  4.w.addWSpace(),
                                  Expanded(
                                      child: TextFormField(
                                        controller: updateController.lname,
                                        keyboardType: TextInputType.name,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Emter the Last Name";
                                          } else {
                                            return null;
                                          }
                                        },
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          labelText: "Last Name",
                                          hintText: "Last Name",
                                          floatingLabelBehavior:
                                          FloatingLabelBehavior.auto,
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            2.h.addHSpace(),
                            TextFormField(
                              controller: updateController.address,
                              maxLines: 3,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                labelText: "Address(Optional)",
                                hintText: 'Address(Optional)',
                                alignLabelWithHint: true,
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                              ),
                            ),
                            2.h.addHSpace(),
                            SizedBox(
                              width: double.infinity,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: updateController.contact,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      validator: (value) {
                                        if (value == null ||
                                            !AppAssets.isvalidmobile(value)) {
                                          return "Enter the Contact";
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(10)),
                                          labelText: "Contact",
                                          hintText: 'Contact',
                                          // errorText: contecterror,
                                          floatingLabelBehavior:
                                          FloatingLabelBehavior.auto,
                                          suffixIcon: Icon(Icons.call)),
                                    ),
                                  ),
                                  4.w.addWSpace(),
                                  Expanded(
                                    child: TextFormField(
                                      controller: updateController.contactOpp,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(10)),
                                          labelText: "Contact(Optional)",
                                          // errorText: contecterror,
                                          floatingLabelBehavior:
                                          FloatingLabelBehavior.auto,
                                          suffixIcon: Icon(Icons.call)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            2.h.addHSpace(),
                            TextFormField(
                              controller: updateController.email,
                              decoration: InputDecoration(
                                  label: Text("email"),
                                  hintText: "email",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  )),
                            ),
                            2.h.addHSpace(),
                            appButton(text: "Updated",onTap: () async {
                              if(_globelkey.currentState!.validate()){
                                String fName = updateController.fname.text.toString();
                                String lName = updateController.lname.text.toString();
                                String imageInternet = servicesData![0].Images;
                                String emails = updateController.email.text.toString();
                                String Contact = updateController.contact.text.toString();
                                String contactopp = updateController.contactOpp.text.toString();
                                String address = updateController.address.text.toString();
                                ServicesData _servicesdata = ServicesData(fname: fName, lname: lName, Images: imageInternet, email: emails, contectnumber: Contact, contectNumber2: contactopp, address: address,useraadharcard: servicesData[0].useraadharcard,password: servicesData[0].password,services: servicesData[0].services,Uid: servicesData[0].Uid);
                                bool check =await  updateController.updateDatainFirebase(_servicesdata);
                                if(check){
                                  Get.back();
                                }else{
                                  Get.snackbar("Update Unsecure", "Error For Updating Database");
                                }
                              }
                            })
                          ],
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
