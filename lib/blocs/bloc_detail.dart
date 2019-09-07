import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:quanly_chitieu/api/detail.dart';
import 'package:quanly_chitieu/model/response/detail.dart';

class DetailBloc with ChangeNotifier{

  static DetailBloc of(BuildContext context){
    return Provider.of<DetailBloc>(context);
  }

  DetailAPI api= DetailAPI();
  AsyncMemoizer<List<Detail>> _cacheThu= AsyncMemoizer();
    AsyncMemoizer<bool> _cacheRemoveThu= AsyncMemoizer();
  AsyncMemoizer<List<Detail>> _cacheChi= AsyncMemoizer();
  AsyncMemoizer<bool> _cacheRemoveChi= AsyncMemoizer();

  refresh(){
    _cacheThu= AsyncMemoizer();
    _cacheChi= AsyncMemoizer();
    notifyListeners();
  }

  Future<List<Detail>>getListThu(String user_name){
    return _cacheThu.runOnce((){
      return api.getThu(user_name);
    });
  }

  Future<bool>removeThu(Detail detail, String user_name){
    return _cacheRemoveThu.runOnce(() {
      return api.removeThu(detail, user_name);
    });
  }

  Future<List<Detail>>getListChi(String user_name){
    return _cacheChi.runOnce((){
      return api.getChi(user_name);
    });
  }

  Future<bool>removeChi(Detail detail, String user_name){
    return _cacheRemoveChi.runOnce(() {
      return api.removeChi(detail, user_name);
    });
  }

}