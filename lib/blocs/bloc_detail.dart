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

  Future<List<Detail>>getListThu(String idUser){
    return _cacheThu.runOnce((){
      return api.getThu(idUser);
    });
  }

  Future<bool>removeThu(String id){
    return _cacheRemoveThu.runOnce(() {
      return api.removeThu(id);
    });
  }

  Future<List<Detail>>getListChi(String idUser){
    return _cacheChi.runOnce((){
      return api.getChi(idUser);
    });
  }

  Future<bool>removeChi(String id){
    return _cacheRemoveChi.runOnce(() {
      return api.removeChi(id);
    });
  }

}