import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';

import '../constants/app_color.dart';


extension SizedExtension on double {
  addHSpace() {
    return SizedBox(height: this);
  }

  addWSpace() {
    return SizedBox(width: this);
  }
}

extension AppDivider on double {
  Widget appDivider({Color? color}) {
    return Divider(
      thickness: this,
      color: color ?? Colors.white,
    );
  }
}
extension AppValidation on String {
  isValidEmail() {
    return RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(this);
  }
}
hideKeyBoard(BuildContext context) {
  return FocusScope.of(context).unfocus();
}
printData({required dynamic tittle, dynamic val}) {
  debugPrint(tittle + ":-" + val.toString());
}
extension ReadexPro on String {
  Widget regularReadex({
    Color? fontColor,
    double? fontSize,
    TextDecoration? textDecoration,
    TextOverflow? textOverflow,
    TextAlign? textAlign,
  }) {
    return Text(
      this,
      overflow: textOverflow,
      style: TextStyle(
          color: fontColor ?? appColor,
          fontSize: fontSize ?? 16,
          fontWeight: FontWeight.w300,
          decoration: textDecoration ?? TextDecoration.none,
          fontFamily: 'ReadexPro'),
      textAlign: textAlign,
    );
  }

  Widget mediumReadex(
      {Color? fontColor,
        double? fontSize,
        TextDecoration? textDecoration,
        TextOverflow? textOverflow,
        TextAlign? textAlign,
        int? maxLine}) {
    return Text(
      this,
      overflow: textOverflow,
      style: TextStyle(
          color: fontColor ?? appColor,
          fontSize: fontSize ?? 16,
          fontWeight: FontWeight.w400,
          decoration: textDecoration ?? TextDecoration.none,
          fontFamily: 'ReadexPro'),
      textAlign: textAlign,
      maxLines: maxLine,
    );
  }

  Widget semiBoldReadex({
    Color? fontColor,
    double? fontSize,
    TextDecoration? textDecoration,
    TextOverflow? textOverflow,
    TextAlign? textAlign,
  }) {
    return Text(
      this,
      overflow: textOverflow,
      style: TextStyle(
          color: fontColor ?? appColor,
          fontSize: fontSize ?? 16,
          fontWeight: FontWeight.w600,
          decoration: textDecoration ?? TextDecoration.none,
          fontFamily: 'ReadexPro'),
      textAlign: textAlign,
    );
  }

  Widget boldReadex({
    Color? fontColor,
    double? fontSize,
    TextDecoration? textDecoration,
    TextOverflow? textOverflow,
    TextAlign? textAlign,
  }) {
    return Text(
      this,
      overflow: textOverflow,
      style: TextStyle(
          color: fontColor ?? appColor,
          fontSize: fontSize ?? 16,
          fontWeight: FontWeight.w700,
          decoration: textDecoration ?? TextDecoration.none,
          fontFamily: 'ReadexPro'),
      textAlign: textAlign,
    );
  }
}

extension AlegreyaSC on String {
  Widget regularAlegreyaSC({
    Color? fontColor,
    double? fontSize,
    TextDecoration? textDecoration,
    TextOverflow? textOverflow,
    TextAlign? textAlign,
    FontWeight? fontWeight,
  }) {
    return Text(
      this,
      overflow: textOverflow,
      style: TextStyle(
          color: fontColor ?? appColor,
          fontSize: fontSize ?? 16,
          fontWeight: fontWeight ?? FontWeight.w300,
          decoration: textDecoration ?? TextDecoration.none,
          fontFamily: 'AlegreyaSC'),
      textAlign: textAlign,
    );
  }

  Widget mediumAlegreyaSC({
    Color? fontColor,
    double? fontSize,
    TextDecoration? textDecoration,
    TextOverflow? textOverflow,
    TextAlign? textAlign,
  }) {
    return Text(
      this,
      overflow: textOverflow,
      style: TextStyle(
          color: fontColor ?? appColor,
          fontSize: fontSize ?? 16,
          fontWeight: FontWeight.w400,
          decoration: textDecoration ?? TextDecoration.none,
          fontFamily: 'AlegreyaSC'),
      textAlign: textAlign,
    );
  }

  Widget boldAlegreyaSC({
    Color? fontColor,
    double? fontSize,
    TextDecoration? textDecoration,
    TextOverflow? textOverflow,
    TextAlign? textAlign,
  }) {
    return Text(
      this,
      overflow: textOverflow,
      style: TextStyle(
          color: fontColor ?? appColor,
          fontSize: fontSize ?? 16,
          fontWeight: FontWeight.w700,
          decoration: textDecoration ?? TextDecoration.none,
          fontFamily: 'AlegreyaSC'),
      textAlign: textAlign,
    );
  }
}

extension Roboto on String {
  Widget regularRoboto({
    Color? fontColor,
    double? fontSize,
    TextDecoration? textDecoration,
    TextOverflow? textOverflow,
    TextAlign? textAlign,
  }) {
    return Text(
      this,
      overflow: textOverflow,
      style: TextStyle(
        color: fontColor ?? appColor,
        fontSize: fontSize ?? 16,
        fontWeight: FontWeight.w300,
        decoration: textDecoration ?? TextDecoration.none,
      ),
      textAlign: textAlign,
    );
  }

  Widget mediumRoboto({
    Color? fontColor,
    double? fontSize,
    TextDecoration? textDecoration,
    TextOverflow? textOverflow,
    TextAlign? textAlign,
  }) {
    return Text(
      this,
      overflow: textOverflow,
      maxLines: 1,
      style: TextStyle(
        color: fontColor ?? appColor,
        fontSize: fontSize ?? 16,
        fontWeight: FontWeight.w400,

        decoration: textDecoration ?? TextDecoration.none,
      ),
      textAlign: textAlign,
    );
  }

  Widget boldRoboto({
    Color? fontColor,
    double? fontSize,
    TextDecoration? textDecoration,
    TextOverflow? textOverflow,
    TextAlign? textAlign,
  }) {
    return Text(
      this,
      overflow: textOverflow,
      style: TextStyle(
        color: fontColor ?? appColor,
        fontSize: fontSize ?? 16,
        fontWeight: FontWeight.w700,
        decoration: textDecoration ?? TextDecoration.none,
      ),
      textAlign: textAlign,
    );
  }
}


enum LoginType {
  Google,
  Facebook,
  App,
}

Widget createLoginButton(
    LoginType type, {
      required Function()? onPressed,
      required String text,
      required IconData icon,
      Color? color,
      required Color borderColor,
    }) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: borderColor, // Set the color of the border
          width: 2, // Set the width of the border
        ),
      ),
      height: 40,
      padding: EdgeInsets.all(10),
      color: Colors.white,
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: 30,
          ),
          10.00.addWSpace(), // Adjust spacing as needed
          Text(text),
        ],
      ),
    ),
  );
}



Widget appTextFormField({TextEditingController? controller,String? labelText,Widget? prefixIcon,Widget? suffixIcon ,bool? obscureText,void Function(String?)? onChanged,String? Function(String?)? validator}){
  return TextFormField(
    onChanged:onChanged ?? (value) {

    },
    validator:validator ?? (value) {

    },
    controller:controller ,
    cursorColor: appColor,
    textAlignVertical: TextAlignVertical.center,
    style: TextStyle(color: Colors.black,fontSize: 15.sp,letterSpacing: 1),
    obscureText:obscureText ?? false ,
    decoration: InputDecoration(
      labelText: labelText ?? "",
      labelStyle: TextStyle(color: Colors.black.withOpacity(0.8),fontSize: 14.sp,letterSpacing: 1),
      filled: true,
      fillColor:Colors.grey[100],
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15),borderSide: const BorderSide(color: Colors.transparent),),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15),borderSide: const BorderSide(color: Colors.transparent),),
    ),
  );
}

Widget appButton(
    {double? height,
      double? width,
      required var onTap,
      Color? color,
      String? text,
      double? fontSize,
      Color? bordorColor,
      double? borderRadius,
      Color? fontColor}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: height ?? 6.5.h,
      width: width ?? 90.w,
      decoration: BoxDecoration(
          border: Border.all(color: bordorColor ?? Colors.transparent),
          color: color ?? appColor,
          borderRadius: BorderRadius.circular(borderRadius ?? 50)),
      child: Center(
          child: (text ?? "").semiOpenSans(
              fontColor: fontColor ?? whiteColor, fontSize: fontSize ?? 14.sp)),
    ),
  );
}

Widget CustomRoundedIcons({
  required IconData iconData,
  required VoidCallback onPress,
}){
  return SizedBox(
    height: 40,
    width: 40,
    child: MaterialButton(
      onPressed: onPress,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      padding: EdgeInsets.zero,
      color: Colors.white,
      child: Icon(
        iconData,
        color: Colors.black45,
      ),
    ),
  );
}


Widget circularImages({
  required String? imageUrl,
}){
  return  ClipOval(
    child: CachedNetworkImage(
      imageUrl: imageUrl!,
      fit: BoxFit.cover,

      progressIndicatorBuilder: (context, url, downloadProgress) =>
          LoadingAnimationWidget.hexagonDots(color: appColor, size: 3.h),
    ),
  );
}




extension OpenSans on String {
  Widget regularOpenSans({
    Color? fontColor,
    double? fontSize,
    TextDecoration? textDecoration,
    TextOverflow? textOverflow,
    TextAlign? textAlign,
  }) {
    return Text(
      this,
      overflow: textOverflow,
      style: TextStyle(
          color: fontColor ?? appColor,
          fontSize: fontSize ?? 16,
          fontWeight: FontWeight.w300,
          decoration: textDecoration ?? TextDecoration.none,
          fontFamily: 'OpenSans'),
      textAlign: textAlign,
    );
  }

  Widget mediumOpenSans(
      {Color? fontColor,
        double? fontSize,
        TextDecoration? textDecoration,
        TextOverflow? textOverflow,
        TextAlign? textAlign,
        int? maxLine}) {
    return Text(
      this,
      overflow: textOverflow,
      style: TextStyle(
          color: fontColor ?? appColor,
          fontSize: fontSize ?? 16,
          fontWeight: FontWeight.w400,
          decoration: textDecoration ?? TextDecoration.none,
          fontFamily: 'OpenSans'),
      textAlign: textAlign,
      maxLines: maxLine,
    );
  }

  Widget semiOpenSans(
      {Color? fontColor,
        double? fontSize,
        TextDecoration? textDecoration,
        TextOverflow? textOverflow,
        TextAlign? textAlign,
        int? maxLines}) {
    return Text(
      this,
      overflow: textOverflow,
      maxLines: maxLines ?? 1,
      style: TextStyle(
          color: fontColor ?? appColor,
          fontSize: fontSize ?? 16,
          fontWeight: FontWeight.w600,
          decoration: textDecoration ?? TextDecoration.none,
          fontFamily: 'OpenSans'),
      textAlign: textAlign,
    );
  }
  Widget boldOpenSans({
    int? line,
    Color? fontColor,
    double? fontSize,
    TextDecoration? textDecoration,
    TextOverflow? textOverflow,
    TextAlign? textAlign,
  }) {
    return Text(
      maxLines: line ?? 1,
      this,
      overflow: textOverflow,
      style: TextStyle(
          color: fontColor ?? appColor,
          fontSize: fontSize ?? 16,
          fontWeight: FontWeight.w700,
          decoration: textDecoration ?? TextDecoration.none,
          fontFamily: 'OpenSans'),
      textAlign: textAlign,
    );
  }

  Widget extraBoldOpenSans({
    Color? fontColor,
    double? fontSize,
    TextDecoration? textDecoration,
    TextOverflow? textOverflow,
    TextAlign? textAlign,
  }) {
    return Text(
      this,
      overflow: textOverflow,
      style: TextStyle(
          color: fontColor ?? appColor,
          fontSize: fontSize ?? 16,
          fontWeight: FontWeight.w700,
          decoration: textDecoration ?? TextDecoration.none,
          fontFamily: 'OpenSans'),
      textAlign: textAlign,
    );
  }
}


Widget roundCornurButton(
    {double? height,
      double? width,
      Color? color,
      BorderRadiusGeometry? radiusGeometry,
      void Function()? onTap,
      String? text,
      Color? textColor}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: height ?? 7.h,
      width: width ?? 100.w,
      decoration: BoxDecoration(
        color: color ?? appColor,
        borderRadius: radiusGeometry ?? BorderRadius.circular(70),
      ),
      child: Center(
          child:
          (text ?? "").semiOpenSans(fontSize: 11.sp, fontColor: textColor)),
    ),
  );
}
void showMessege({String? title, String? messege}) {
  Get.snackbar(title ?? "", messege ?? "", backgroundColor: lightPurple);
}


