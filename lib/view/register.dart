
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:quanly_chitieu/blocs/bloc_register.dart';
import 'package:quanly_chitieu/model/request/user.dart';
class RegisterPage extends StatelessWidget {
  TextEditingController _userNameCtrl= TextEditingController();
  TextEditingController _pwdCtrl= TextEditingController();
  TextEditingController _nameCtrl= TextEditingController();
  TextEditingController _cardCtrl= TextEditingController();
  TextEditingController _moneyCardCtrl= TextEditingController();
  TextEditingController _moneyFaceCtrl= TextEditingController();
  TextEditingController _yearCtrl= TextEditingController();

  final _formKey = GlobalKey<FormState>();
  RegisterBloc _bloc= RegisterBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ĐĂNG KÝ"),
        centerTitle: true,
      ),
      body: _buildRegisterBox(context),

    );
  }

  _buildRegisterBox(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 25.0, right: 25),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: _nameCtrl,
                  validator: (value)=> _bloc.isValidName(value),
                  decoration: InputDecoration(
                      labelText: "Họ và tên",
                      labelStyle: TextStyle(color: Colors.black)
                  ),
                ),
                TextFormField(
                  controller: _yearCtrl,
                  validator: (value)=> _bloc.isValidYear(value),
                  decoration: InputDecoration(
                      labelText: "Năm sinh",
                      labelStyle: TextStyle(color: Colors.black)
                  ),
                ),
                TextFormField(
                  controller: _userNameCtrl,
                  validator: (value)=> _bloc.isValidUsername(value),
                  decoration: InputDecoration(
                      labelText: "Tên đăng nhập",
                      labelStyle: TextStyle(color: Colors.black)
                  ),
                ),
                TextFormField(
                  controller: _pwdCtrl,
                  obscureText: true,
                  validator: (value)=> _bloc.isValidPassword(value),
                  decoration: InputDecoration(
                      labelText: "Mật khẩu",
                      labelStyle: TextStyle(color: Colors.black)
                  ),
                ),
                TextFormField(
                  controller: _cardCtrl,
                  validator: (value)=> _bloc.isValidNumberCard(value),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Số tài khoản",
                      labelStyle: TextStyle(color: Colors.black)
                  ),
                ),
                TextFormField(
                  controller: _moneyCardCtrl,
                  keyboardType: TextInputType.number,
                  validator: (value)=> _bloc.isValidNotEmpty(value),
                  decoration: InputDecoration(
                      labelText: "Tiền tài khoản",
                      labelStyle: TextStyle(color: Colors.black)
                  ),
                ),
                TextFormField(
                  controller: _moneyFaceCtrl,
                  keyboardType: TextInputType.number,
                  validator: (value)=> _bloc.isValidNotEmpty(value),
                  decoration: InputDecoration(
                      labelText: "Tiền mặt",
                      labelStyle: TextStyle(color: Colors.black)
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: FlatButton(
                      color: Colors.blue,
                      onPressed: ()=> funcRegister(context),
                      child: Text("Đăng ký", style: TextStyle(color: Colors.white),)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 16),
                  child: RichText(
                    text: TextSpan(
                        text: 'Bạn đã có tài khoản?  ',
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                              text: "Đăng nhập", style:TextStyle(fontWeight:  FontWeight.bold),
                              recognizer: TapGestureRecognizer()..onTap= () => Navigator.pushNamed(context, '/login')
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
    );
  }

  funcRegister(BuildContext context) {
    if (_formKey.currentState.validate()) {
      String userName = _userNameCtrl.text.trim();
      String pwd = _pwdCtrl.text.trim();
      String name = _nameCtrl.text.trim();
      String year = _yearCtrl.text.trim();
      String card = _cardCtrl.text.trim();
      String money_card = _moneyCardCtrl.text.trim();
      String money_face = _moneyFaceCtrl.text.trim();

      UserRequest user = UserRequest(
          name,
          userName,
          year,
          card,
          money_card,
          money_face,
          pwd);

      RegisterBloc bloc = RegisterBloc();
      bloc.RegisterApi(user).then((onvalue) {
        if (onvalue == '0' || onvalue.contains('<!doctype html>')) {
          print('that bai');
        } else {
          print('thanh cong' + onvalue);
          Navigator.pushNamed(context, '/login');
        }
      });
    }
  }
}
