import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {

  showSuccessToast(String text) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      fontSize: 16,
      textColor: Colors.white,
      backgroundColor: Colors.green,
      timeInSecForIosWeb: 2);
  }

  showFailToast(String text) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      fontSize: 16,
      textColor: Colors.white,
      backgroundColor: Colors.red,
      timeInSecForIosWeb: 2);
  }

  showWarningToast(String text) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      fontSize: 16,
      textColor: Colors.white,
      backgroundColor: Color.fromARGB(255, 230, 133, 37),
      timeInSecForIosWeb: 2);
  }

}
