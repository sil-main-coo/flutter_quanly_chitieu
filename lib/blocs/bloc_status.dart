import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:quanly_chitieu/api/user_api.dart';
import 'package:quanly_chitieu/model/response/user.dart';
import 'package:async/async.dart';
import 'bloc_local_storage.dart';

class StatusBloc extends ChangeNotifier{
  static StatusBloc of(BuildContext context){
    return Provider.of(context);
  }

  AsyncMemoizer _cacheID= AsyncMemoizer();
  AsyncMemoizer _cacheUser= AsyncMemoizer();


  UserAPI _userApi = UserAPI();

  String _user_name;
  UserResponse _user;

  UserResponse get user => _user;
  String get user_name => _user_name;

  refreshGetUser(){
    _cacheUser= AsyncMemoizer();
  }

  set userId(String value){
    this._user_name= value;
    notifyListeners();
  }

  saveUserIDLocal() async {
    LocalStorage.saveAccount(this._user_name);
  }

  getUserFromLocal() async {
    _cacheID.runOnce(() async {
      String user_name = await LocalStorage.getAccount();
      if (user_name != null) {
        print(user_name);
        this._user_name = user_name;
        notifyListeners();
      }
    });
  }

  Future<bool> clearDataUser() async {
    return LocalStorage.clearData();
  }

  Future<void> getUser() async {
    _cacheUser.runOnce(() async {
      UserResponse data=  await  _userApi.getUser(this._user_name);
      print(data.money_card.toString());
      if (data!=null) {
        this._user= data;
        notifyListeners();
      }
    });
  }

}