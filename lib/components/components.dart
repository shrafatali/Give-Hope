import 'package:flutter/material.dart';
import 'package:give_hope/components/constants.dart';

class Components {
  static void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: AppColor.whiteColor),
      ),
      backgroundColor: AppColor.blackColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static showAppLogo(BuildContext context) {
    return Image.asset(
      'assets/images/app_logo.png',
      height: MediaQuery.of(context).size.height * 0.15,
    );
  }

  static showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Center(
        child: CircularProgressIndicator(
          color: AppColor.primaryColor,
          strokeWidth: 5,
        ),
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class AppButton {
  static showButton(BuildContext context, String text, Color color) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(30)),
      alignment: Alignment.center,
      child: Text(
        text.toString(),
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
