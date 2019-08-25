import 'package:flutter/material.dart';

class MyDialog{
  static void showMsgDialogLogin(BuildContext context, String title, String msg) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        title: Text(title),
        content: Text(msg, style: TextStyle(color: Colors.redAccent),),
        actions: [
          new FlatButton(
            child: Text("OK",style: TextStyle(color: Colors.blue),),
            onPressed: () {
              Navigator.of(context).pop(MyDialog);
            },
          ),
        ],
      ),
    );
  }
}