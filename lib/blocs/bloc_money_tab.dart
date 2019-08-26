import 'package:quanly_chitieu/api/detail.dart';
import 'package:quanly_chitieu/check_id/validation.dart';
import 'package:quanly_chitieu/model/response/detail.dart';

class MoneyTabBloc{
  DetailAPI _detailAPI= DetailAPI();

  String isValidNotEmpty(String s){
    if(!ValidationsAccount.isValidNotEmpty(s)){
      return "Bạn chưa nhập dữ liệu";
    }
    return null;
  }

  Future<bool> handlingRemoveDetail(int type, String id) async{
    switch(type){
      case 1:
      /// call thu
        return _detailAPI.removeThu(id);
      case 2:
      /// call chi
        return _detailAPI.removeChi(id);
    }
    return null;
  }

  Future<bool> handlingCreateDetail(String id_user, int type, Detail detail){
    switch(type){
      case 1:
        /// call thu
        return _detailAPI.addThu(id_user, detail);
      case 2:
        /// call chi
      return _detailAPI.addChi(id_user, detail);
    }
    return null;
  }

}