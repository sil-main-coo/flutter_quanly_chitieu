import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quanly_chitieu/blocs/bloc_detail.dart';
import 'package:quanly_chitieu/blocs/bloc_money_tab.dart';
import 'package:quanly_chitieu/widgets/loader.dart';

class MyDialog{
  static void showMsgDialogErr(BuildContext context, String title, String msg) {
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

  static void showMsgDialogSuccess(BuildContext context, String title, String msg) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        title: Text(title),
        content: Text(msg, style: TextStyle(color: Colors.green),),
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

  static void showMsgDialog(BuildContext context, String title, String msg, MoneyTabBloc moneyTabBloc, int type, String id,) {
    print(type);
    print(id);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        title: Text(title),
        content: Text(msg, style: TextStyle(color: Colors.black),),
        actions: [
          new FlatButton(
            child: Text("Xóa",style: TextStyle(color: Colors.blue),),
            onPressed: () {
              _remove(context, moneyTabBloc, type, id);
            },
          ),
          new FlatButton(
            child: Text("Hủy",style: TextStyle(color: Colors.blue),),
            onPressed: () {
              Navigator.of(context).pop(MyDialog);
            },
          ),
        ],
      ),
    );
  }
}

void _remove(BuildContext context, MoneyTabBloc moneyTabBloc, int type, String id) async{
  Loader.showLoadingDialog(context);
  moneyTabBloc.handlingRemoveDetail(type, id).then((value){
    if(value){
      Navigator.of(context).pop(MyDialog);
      MyDialog.showMsgDialogSuccess(context, 'Thành công', 'Xóa thành công !');
      final detailBloc= Provider.of<DetailBloc>(context);
      detailBloc.refresh();
    }else
      MyDialog.showMsgDialogErr(context, "Lỗi", "Đã xảy ra lỗi !");
    Navigator.of(context).pop(MyDialog);
    Loader.hideLoadingDialog(context);

  });
}