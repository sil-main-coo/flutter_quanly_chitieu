import 'package:flutter/material.dart';
import 'package:quanly_chitieu/blocs/bloc_detail.dart';
import 'package:quanly_chitieu/blocs/bloc_status.dart';
import 'package:quanly_chitieu/model/response/detail.dart';
import 'package:quanly_chitieu/model/response/user.dart';
class MoneyTab extends StatefulWidget {
  @override
  _MoneyTabState  createState() => _MoneyTabState ();
}

class _MoneyTabState extends State<MoneyTab> with SingleTickerProviderStateMixin {
  double width,height;
  DetailBloc _detailBloc= DetailBloc();
  TabController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller= TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final sttBloc= StatusBloc.of(context);
    sttBloc.getUser();

    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return sttBloc.user==null? _buildError():
    Column(
      children: <Widget>[
        _full_money(sttBloc.user),
        Text("Thống kê chi tiêu"),
        _detail_money(sttBloc.userId)
      ],
    );
  }


  _buildError() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  _buildEmpty() {
    return Center(
      child: Text(""),
    );
  }

  _full_money(UserResponse user) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text("Tài khoản"),
              Row(
                children: <Widget>[
                  Text("Tổng cộng : "),
                  Text("10000"),
                ],
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _type_money("Tài khoản thẻ", user.money_card,Colors.blue),
              _type_money("Tiền mặt", user.money_face,Colors.amberAccent)
            ],
          )
        ],
      ),
    );
  }

  _type_money(String type,String value,Color color) {
    return Padding(
      padding: const EdgeInsets.only(top:8.0),
      child: Container(
        padding: EdgeInsets.all(8),
        width: width/2.2,
        color: color,
        child: Column(
          children: <Widget>[
            Text(value,
            style: TextStyle(fontSize: 20),),
            Text(type,
            style: TextStyle(fontSize: 12),)
          ],
        ),
      ),
    );
  }

  _detail_money(String idUser) {
    return FutureBuilder<List<Detail>>(
        future:  _detailBloc.getListThu(idUser),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return _buildError();
            case ConnectionState.done:
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              List<Detail> thu= snapshot.data;
              return FutureBuilder<List<Detail>>(
                  future:  _detailBloc.getListChi(idUser),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.active:
                    case ConnectionState.waiting:
                      return _buildError();
                    case ConnectionState.done:
                      if (snapshot.hasError)
                        return Text('Error: ${snapshot.error}');
                      List<Detail> chi= snapshot.data;
                  return Expanded(
                    child: ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) =>_money_item(thu, chi),
                        separatorBuilder: (context, index) =>Divider(color: Colors.black26,),
                        itemCount: thu.length+chi.length),
                  );
                }
              );
          }
          return null; // unreachable
        }
    );
  }

  _money_item(Detail data,  List<Detail> thu, List<Detail> chi) {
    return ListTile(
      leading: Icon(Icons.adb),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[

          Text(data.detail,style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
          ),
          Text("Thẻ",style: TextStyle(fontSize: 10),
          ),
          Text("11:22 22/12/2011",style: TextStyle(fontSize: 10,fontStyle: FontStyle.italic),
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(data.money),
          Text(" đ")
        ],
      ),

    );
  }


}
