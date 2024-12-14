import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';
import '../../../../../constants/app_color.dart';
import '../../../RegisterDetails/model/ServicesData.dart';
import '../Conntroller/update_password_controller.dart';

class updatePassword  extends StatelessWidget {
  UpdatePasswordController updatePasswordController = Get.put(UpdatePasswordController());
  var myDataObject = Get.arguments as ServicesData;
  @override
  Widget build(BuildContext context) {
    String passwords = myDataObject.password!;
    print("Old Password is ${passwords}");
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Change Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: updatePasswordController.formKey,
          child: Column(
            children: [
              TextFormField(
                controller: updatePasswordController.currentPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    labelText: 'Current Password'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your current password.';
                  }else if(!value.contains(passwords)){
                    return "Not Match Old Password";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: updatePasswordController.newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {

                      },
                      icon: Icon(Icons.remove_red_eye),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    labelText: 'New Password'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a new password.';
                  }
                  // Implement your password validation logic here
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: updatePasswordController.confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Confirm New Password',
                    suffixIcon: IconButton(
                      onPressed: () {

                      },
                      icon: Icon(Icons.visibility_off),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    )),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please confirm your new password.';
                  }
                  if (value != updatePasswordController.newPasswordController.text) {
                    return 'Passwords do not match.';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(onPressed: () {
                updatePasswordController.isLoading.value ? null : updatePasswordController.handelPasswordError(myDataObject,context);
              }, child: Obx(
                    () => updatePasswordController.isLoading.value ?  LoadingAnimationWidget.hexagonDots(color: appColor, size: 3.h)  : Text('Save Password') ,
              ),),
            ],
          ),
        ),
      ),
    );
  }
}
