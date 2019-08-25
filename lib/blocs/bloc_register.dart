

import 'package:quanly_chitieu/api/user_api.dart';
import 'package:quanly_chitieu/check_id/validation.dart';
import 'package:quanly_chitieu/model/request/user.dart';


class RegisterBloc {
  UserAPI _userApi = UserAPI();

  Future<String> RegisterApi(UserRequest user) async {
    return _userApi.registerApi(user);
  }

  String isValidUsername(String user){
    if(!ValidationsAccount.isValidUser(user)){
      return "Tài khoản quá ngắn";
    }
    return null;
  }

  String isValidName(String name){
    if(!ValidationsAccount.isValidFullname(name)){
      return "Tên không đúng";
    }
    return null;
  }

  String isValidPassword(String pwd){
    if(!ValidationsAccount.isValidPwd(pwd)){
      return "Mật khẩu phải lớn hơn 6 ký tự";
    }
    return null;
  }


  String isValidYear(String year){
    if(!ValidationsAccount.isValidYear(year)){
      return "Năm sinh không đúng";
    }
    return null;
  }

  String isValidNumberCard(String card){
    if(!ValidationsAccount.isValidCardNumber(card)){
      return "Số tài khoản không đúng";
    }
    return null;
  }


  String isValidNotEmpty(String s){
    if(!ValidationsAccount.isValidNotEmpty(s)){
      return "Bạn chưa nhập thông tin";
    }
    return null;
  }

}