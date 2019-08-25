import 'package:flutter/material.dart';

class Loader{
  static void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child:  SizedBox(
            height: 25,
            width: 25,
            child: CircularProgressIndicator()
        ),
      ),
    );
  }

  static hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop(Loader);
  }
}