import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:quanly_chitieu/blocs/bloc_login.dart';
import 'package:quanly_chitieu/blocs/bloc_status.dart';
import 'package:quanly_chitieu/model/request/account.dart';
import 'package:quanly_chitieu/widgets/dialog.dart';
import 'package:quanly_chitieu/widgets/loader.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  TextEditingController _userCtrl= TextEditingController();
  TextEditingController _pwdCtrl= TextEditingController();
  final _formKey = GlobalKey<FormState>();
  LoginBloc _bloc= LoginBloc();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ĐĂNG NHẬP"),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed:(){
              exit(0);
            }
            ),
      ),
      body: _buildLoginBox(context),
    );
  }

  _buildLoginBox(BuildContext context) {
    return Center(
      child: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _userCtrl,
                    validator: (value) => _bloc.isValidUsername(value),
                    decoration: InputDecoration(
                      labelText: "Tài khoản",
                      labelStyle: TextStyle(color: Colors.black)
                    ),
                  ),
                  TextFormField(
                    controller: _pwdCtrl,
                    obscureText: true,
                    validator: (value) => _bloc.isValidPassword(value),
                    decoration: InputDecoration(
                        labelText: "Mật khẩu",
                        labelStyle: TextStyle(color: Colors.black)
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: FlatButton(
                      color: Colors.blue,
                        onPressed: () => _funcLogin(context),
                        child: Text("Đăng nhập", style: TextStyle(color: Colors.white),)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: RichText(
                      text: TextSpan(
                        text: 'Bạn chưa có tài khoản?  ',
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                              text: "Đăng ký", style:TextStyle(fontWeight:  FontWeight.bold),
                            recognizer: TapGestureRecognizer()..onTap= () => Navigator.pushNamed(context, '/register')
                          )
                        ]
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _funcLogin(BuildContext context) {
    if (_formKey.currentState.validate()) {
      Loader.showLoadingDialog(context);
      String user = _userCtrl.text.trim();
      String pwd = _pwdCtrl.text.trim();
      Account acc = Account(user, pwd);

      _bloc.loginApi(acc).then((onvalue) {
        Loader.hideLoadingDialog(context);
        if (onvalue == null) {
          MyDialog.showMsgDialogErr(context, "LỖI", "Sai tài khoản hoặc mật khẩu !");
        } else {
          final sttBloc= StatusBloc.of(context);
          sttBloc.userId= onvalue.user_name;
          sttBloc.saveUserIDLocal();
          Navigator.pushReplacementNamed(context, '/home',); // đó
        }
      });
    }

  }
}
