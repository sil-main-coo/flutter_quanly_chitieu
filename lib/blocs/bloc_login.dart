
import 'package:quanly_chitieu/api/user_api.dart';
import 'package:quanly_chitieu/check_id/validation.dart';
import 'package:quanly_chitieu/model/request/account.dart';
import 'package:quanly_chitieu/model/response/login.dart';


class LoginBloc {
  UserAPI _userApi = UserAPI();

  Future<Login> loginApi(Account account) async {
    return _userApi.loginApi(account);
  }

  String isValidUsername(String user){
    if(!ValidationsAccount.isValidUser(user)){
      return "Tài khoản quá ngắn";
    }
    return null;
  }

  String isValidPassword(String pwd){
    if(!ValidationsAccount.isValidPwd(pwd)){
      return "Mật khẩu phải từ 6 ký tự";
    }
    return null;
  }



}