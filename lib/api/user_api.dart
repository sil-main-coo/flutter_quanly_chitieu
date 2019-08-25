
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quanly_chitieu/blocs/bloc_local_storage.dart';
import 'package:quanly_chitieu/model/request/account.dart';
import 'package:quanly_chitieu/model/response/login.dart';
import 'package:quanly_chitieu/model/response/user.dart';
import 'package:quanly_chitieu/model/request/user.dart';
import 'package:quanly_chitieu/url/url.dart';

class UserAPI {
  Future<Login> loginApi(Account account) async {
    try {
      var response= await http.post(MyUrl.login, body: {'user_name': account.user, 'password': account.password});

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      String body= response.body;

      if (body == '0' || body.contains('<!doctype html>'))
        return null;

      var json= jsonDecode(body);
      var user= json['user'];
      var data= user[0];
      return Login.fromJson(data);

    }catch(e) {
      print(e.toString());
      return null;
    }
  }

  Future<UserResponse> getUser(String id) async {
    try {
      var response= await http.get(MyUrl.getUser+"?id_user="+id);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      String body= response.body;

      if (body == '0' || body.contains('<!doctype html>'))
        return null;

      var json= jsonDecode(body);
      var user= json['user'];
      var data= user[0];
      return UserResponse.fromJson(data);

    }catch(e) {
      print(e.toString());
      return null;
    }
  }

  Future<String> registerApi(UserRequest user) async {
    try {
      var response= await http.post(MyUrl.register,
          body: {
            'id': user.name,
            'year': user.year,
            'user_name': user.user_name,
            'password': user.password,
            'card': user.card,
            'money_card': user.money_card,
            'money_face': user.money_face
      }
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      return response.body;

    }catch(e) {
      print(e.toString());
      return '0';
    }
  }
}