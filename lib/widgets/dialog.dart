import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quanly_chitieu/blocs/bloc_detail.dart';
import 'package:quanly_chitieu/blocs/bloc_money_tab.dart';
import 'package:quanly_chitieu/blocs/bloc_status.dart';
import 'package:quanly_chitieu/model/response/detail.dart';
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

  static void showMsgDialogRegisterSuccess(BuildContext context, String title, String msg) {
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
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }

  static void showLogOutDialog(BuildContext context){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        title: Text('Đăng xuất'),
        content: Text('Bạn sẽ đăng xuất ? ', style: TextStyle(color: Colors.black),),
        actions: [
          new FlatButton(
            child: Text("Đồng ý",style: TextStyle(color: Colors.blue),),
            onPressed: () {
              _handlingLogOut(context);
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

  static void showMsgDialog(BuildContext context, String title, String msg, MoneyTabBloc moneyTabBloc, int type, Detail detail,) {
    print(type);
    print(detail.id);
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
              _remove(context, moneyTabBloc, type, detail);
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

  static void showMsgDialogInforUser(BuildContext context) {
    final _sttBloc= StatusBloc.of(context);

    showDialog(
      context: context,
      builder: (context) => Hero(
        tag: 'tag_infor',
        child: AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
          title: Text('HỒ SƠ NGƯỜI DÙNG'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: <Widget>[
                 Text('Họ và tên: '),
                 Text(_sttBloc.user.name, style: TextStyle(fontWeight: FontWeight.bold),)
               ],
             ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Năm sinh: '),
                  Text(_sttBloc.user.year, style: TextStyle(fontWeight: FontWeight.bold),)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Số tài khoản: '),
                  Text(_sttBloc.user.card, style: TextStyle(fontWeight: FontWeight.bold),)
                ],
              ),
            ],
          ),
          actions: [
            new FlatButton(
              child: Text("OK",style: TextStyle(color: Colors.blue),),
              onPressed: () {
                Navigator.of(context).pop(MyDialog);
              },
            ),
          ],
        ),
      ),
    );
  }
}

void _handlingLogOut(BuildContext context) {
  Loader.showLoadingDialog(context);
  final _sttBloc= StatusBloc.of(context);
  _sttBloc.clearDataUser().then((onValue){
    Loader.hideLoadingDialog(context);
    Navigator.pushNamedAndRemoveUntil(context, '/login',
        ModalRoute.withName(
            '/')); // đóng ngăn xếp của màn hình
    print("log out !");
  });
}

void _remove(BuildContext context, MoneyTabBloc moneyTabBloc, int type, Detail detail) async{
  final sttBloc= StatusBloc.of(context);
  Loader.showLoadingDialog(context);
  moneyTabBloc.handlingRemoveDetail(type, detail, sttBloc.user_name).then((value){
    Loader.hideLoadingDialog(context);
    if(value){
      Navigator.of(context).pop(MyDialog);
      MyDialog.showMsgDialogSuccess(context, 'Thành công', 'Xóa thành công !');
      final detailBloc= Provider.of<DetailBloc>(context);
      sttBloc.refreshGetUser();
      detailBloc.refresh();
    }else
      MyDialog.showMsgDialogErr(context, "Lỗi", "Đã xảy ra lỗi !");
      Navigator.of(context).pop(MyDialog);
  });
}