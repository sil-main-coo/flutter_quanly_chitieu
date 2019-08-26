
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quanly_chitieu/model/response/detail.dart';
import 'package:quanly_chitieu/url/url.dart';

class DetailAPI {
  Future<List<Detail>> getThu(String idUser) async {
    try {
      var response= await http.get(MyUrl.getThu+"?id_user="+idUser);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      String body= response.body;

      if (body == '0' || body.contains('<!doctype html>'))
        return null;
      List<Detail> details= List();

      var json= jsonDecode(body);
      var thus= json['thu'];
      for(dynamic i in thus){
        details.add(Detail.fromJson(i));
      }
      return details;

    }catch(e) {
      print(e.toString());
      return null;
    }
  }

  Future<bool> removeThu(String idthu) async {
    try {
      var response= await http.post(MyUrl.removeThu, body: {'idthu': idthu});

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      String body= response.body;

      if (body == '0' || body.contains('<!doctype html>'))
        return false;

      return true;

    }catch(e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> addThu(String id_user, Detail detail) async {
    try {
      var response= await http.post(MyUrl.addThu,
          body: {'money': detail.money, 'detail': detail.detail, 'id_user': id_user}
          );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      String body= response.body;

      if (body == '0' || body.contains('<!doctype html>'))
        return false;

      return true;

    }catch(e) {
      print(e.toString());
      return false;
    }
  }

  Future<List<Detail>> getChi(String idUser) async {
    try {
      var response= await http.get(MyUrl.getChi+"?id_user="+idUser);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      String body= response.body;

      if (body == '0' || body.contains('<!doctype html>'))
        return null;
      List<Detail> details= List();

      var json= jsonDecode(body);
      var thus= json['chi'];
      for(dynamic i in thus){
        details.add(Detail.fromJson(i));
      }
      return details;

    }catch(e) {
      print(e.toString());
      return null;
    }
  }

  Future<bool> addChi(String id_user, Detail detail) async {
    try {
      var response= await http.post(MyUrl.addChi,
          body: {'money': detail.money, 'detail': detail.detail, 'id_user': id_user}
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      String body= response.body;

      if (body == '0' || body.contains('<!doctype html>'))
        return false;

      return true;

    }catch(e) {
      print(e.toString());
      return false;
    }
  }


  Future<bool> removeChi(String idchi) async {
    try {
      var response= await http.post(MyUrl.removeChi, body: {'idchi': idchi});

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      String body= response.body;

      if (body == '0' || body.contains('<!doctype html>'))
        return false;

      return true;

    }catch(e) {
      print(e.toString());
      return false;
    }
  }
}