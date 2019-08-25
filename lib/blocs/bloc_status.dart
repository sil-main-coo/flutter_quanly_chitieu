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

  String _userId;
  UserResponse _user;

  UserResponse get user => _user;
  String get userId => _userId;

  set userId(String value){
    this._userId= value;
    notifyListeners();
  }

  saveUserIDLocal() async {
    LocalStorage.saveAccount(this._userId);
  }

  getUserFromLocal() async {
    _cacheID.runOnce(() async {
      String id = await LocalStorage.getAccount();
      if (id != null) {
        print(id);
        this._userId = id;
        notifyListeners();
      }
    });
  }

  Future<void> getUser() async {
    _cacheUser.runOnce(() async {
      UserResponse data=  await  _userApi.getUser(this._userId);
      print(data.money_card.toString());
      if (data!=null) {
        this._user= data;
        notifyListeners();
      }
    });
  }

}