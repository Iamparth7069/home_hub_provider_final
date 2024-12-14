

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:home_hub_provider_final/utils/extension.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';

import '../../../../LocalStorage/StorageClass.dart';
import '../../../../Routes/Routes.dart';
import '../../../../constants/app_assets.dart';
import '../../../../constants/app_color.dart';
import '../controller/RegisterDetailsUserController.dart';


class RegisterDetails extends StatefulWidget {
  RegisterDetails({super.key});

  @override
  State<RegisterDetails> createState() => _RegisterDetailsState();
}

class _RegisterDetailsState extends State<RegisterDetails> {
  RegisterDetailsController _registerDetailsController = Get.put(RegisterDetailsController());

  final _globalKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 7),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(
                      Icons.arrow_back_outlined,
                      size: 4.h,
                    ),
                  ),
                ),
              ),
              3.h.addHSpace(),
              Center(
                  child: "Services Provide Details"
                      .mediumReadex(fontColor: Colors.black, fontSize: 30)),
              3.h.addHSpace(),
              Center(child: "Pick Images".mediumReadex()),
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
                            _registerDetailsController.imageFile.value;
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
                    Positioned(
                      bottom: 2,
                      right: 5,
                      child: CircleAvatar(
                        radius: 20,
                        child: IconButton(
                          onPressed: () async {
                            await _registerDetailsController.pickImage();
                          },
                          icon: Icon(Icons.add),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              3.h.addHSpace(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Form(
                  key: _globalKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: TextFormField(
                                  controller: _registerDetailsController.fName,
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
                                  controller: _registerDetailsController.lName,
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
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _registerDetailsController.contact,
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
                                controller: _registerDetailsController.contactOptional,
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
                        controller: _registerDetailsController.address,
                        keyboardType: TextInputType.multiline,
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
                      Obx(
                            () => _registerDetailsController.selectedServices == null
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
                            value: _registerDetailsController
                                .selectedServices.value,
                            hint: const Text('Selected Services'),
                            onChanged: (String? newValue) {
                              _registerDetailsController
                                  .setSelectedService(newValue);
                            },
                            items: _registerDetailsController
                                .selectServices.value
                                .map((String service) {
                              print(service);
                              return DropdownMenuItem<String>(
                                value: service,
                                child: Text(service),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              2.h.addHSpace(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: appColor, // Set your preferred border color
                      width: 2.0, // Set your preferred border width
                    ),
                    borderRadius: BorderRadius.circular(
                        8.0), // Set your preferred border radius
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Obx(
                                () => _registerDetailsController.aadharCard.value == null ? Text(
                              "Pick Aadhar Card Images",
                              style: TextStyle(fontSize: 20),
                            ) : Text("Selected",  style: TextStyle(fontSize: 20)),
                          ),
                        ),
                      ),
                      Container(
                        height: 45,
                        width: 2,
                        color: Colors.black,
                      ),
                      1.w.addWSpace(),
                      Obx(
                            () =>
                        _registerDetailsController.aadharCard.value == null
                            ? CustomRoundedIcons(
                          iconData: Icons.add,
                          onPress: () {
                            _registerDetailsController.pickAadharCard();
                          },
                        )
                            : CustomRoundedIcons(
                          iconData: Icons.remove,
                          onPress: () {
                            // _registerDetailsController
                            _registerDetailsController.aadharCard.value = null;
                          },
                        ),
                      ),
                      2.w.addWSpace(),
                    ],
                  ),
                ),
              ),
              2.h.addHSpace(),
              Obx(
                    () => _registerDetailsController.isLoading.value
                    ? LoadingAnimationWidget.hexagonDots(
                    color: appColor, size: 5.h)
                    : Center(
                  child: appButton(
                      onTap: () async {
                        if (_globalKey.currentState!.validate()) {
                          if(_registerDetailsController.aadharCard.value == null){
                            Get.snackbar("Image Error","Selected Images");
                          }else{
                            StorageService().setProfileDataStatus(true);
                            bool check = await _registerDetailsController.addDataInFirebase();
                            if(check){
                              _showCustomDialog(context);
                            }else{
                              print("False");
                            }

                          }
                        } else {
                          print("Enter Form Filed");
                        }
                      },
                      text: "Register"),
                ),
              ),
              3.h.addHSpace(),
            ],
          ),
        ),
      ),
    );
  }

  void _showCustomDialog(BuildContext context) {
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
                Get.offAllNamed(Routes.loginScreen);
              })
        ],
      ),
    );
  }
}
