import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quanly_chitieu/blocs/bloc_detail.dart';
import 'package:quanly_chitieu/blocs/bloc_money_tab.dart';
import 'package:quanly_chitieu/blocs/bloc_status.dart';
import 'package:quanly_chitieu/model/response/detail.dart';
import 'package:quanly_chitieu/model/response/user.dart';
import 'package:quanly_chitieu/widgets/dialog.dart';
import 'package:quanly_chitieu/widgets/loader.dart';
import 'package:toast/toast.dart';
class MoneyTab extends StatefulWidget {
  @override
  _MoneyTabState  createState() => _MoneyTabState ();
}

class _MoneyTabState extends State<MoneyTab> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  double width, height;
  TabController _controller;
  int groupValue = 1;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _moneyCtrl= TextEditingController();
  TextEditingController _detailCtrl= TextEditingController();
  int _selChi, _selThu;
  int _type;
  Detail _detail;
  bool _isEdit= true;
  MoneyTabBloc _moneyTabBloc= MoneyTabBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }


  @override
  Widget build(BuildContext context) {
    print("Build tab");
    final detailBloc= DetailBloc.of(context);
    final sttBloc = StatusBloc.of(context);
    sttBloc.getUser();

    width = MediaQuery
        .of(context)
        .size
        .width;
    height = MediaQuery
        .of(context)
        .size
        .height;

    return sttBloc.user == null ? _buildLoading(width / 10, width / 10) :
    Scaffold(
      body: Column(
        children: <Widget>[
          _full_money(sttBloc.user),
          Text("Thống kê chi tiêu"),
          _buildTabbar(),
          _buildTabView(sttBloc.user_name, detailBloc)
          //_detail_money(sttBloc.userId)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _isEdit? Colors.blue : Colors.red,
        child: Icon(_isEdit? Icons.create:  Icons.delete),
        onPressed: () {
          _isEdit? _createDetailMoney(sttBloc, detailBloc) : _removeDetail();
        },
      ),
    );
  }


  _buildLoading(double width, double height) {
    return Center(
      child: SizedBox(
          width: width,
          height: height,
          child: CircularProgressIndicator()),
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
              Text("Số tài khoản: "+user.card),
              Row(
                children: <Widget>[
                  Text("Tổng cộng : "),
                  Text(_formatNumber((int.parse(user.money_card)+int.parse(user.money_face)).toString())),
                ],
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _type_money("Tài khoản thẻ", _formatNumber(user.money_card), Colors.blue),
              _type_money("Tiền mặt", _formatNumber(user.money_face), Colors.amberAccent)
            ],
          )
        ],
      ),
    );
  }

  _type_money(String type, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        padding: EdgeInsets.all(8),
        width: width / 2.2,
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

  _buildTabbar() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16),
      child: TabBar(
          controller: _controller,
          unselectedLabelColor: Colors.black,
          labelColor: Colors.blue,
          tabs: [
            Tab(text: "Thu",),
            Tab(text: "Chi",)
          ]
      ),
    );
  }

  _buildTabView(String idUser, DetailBloc detailBloc) {
    return Expanded(
      child: TabBarView(
        controller: _controller,
        children: <Widget>[
          _detail_money_thu(idUser, detailBloc,),
          _detail_money_chi(idUser, detailBloc)
        ],
      ),
    );
  }

  _detail_money_thu(String idUser, DetailBloc _detailBloc) {
    return FutureBuilder<List<Detail>>(
        future: _detailBloc.getListThu(idUser),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return _buildLoading(width / 12, width / 12);
            case ConnectionState.done:
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              List<Detail> thu = snapshot.data;
              return thu.length == 0 ? _emptyList() :
              ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) =>
                      _money_item_thu(thu[thu.length -1 - index], index),
                  separatorBuilder: (context, index) =>
                      Divider(color: Colors.black26,),
                  itemCount: thu.length
              );
          }
          return null; // unreachable
        }
    );
  }

  _detail_money_chi(String idUser, DetailBloc detailBloc) {
    return FutureBuilder<List<Detail>>(
        future: detailBloc.getListChi(idUser),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return _buildLoading(width / 12, width / 12);
            case ConnectionState.done:
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              List<Detail> chi = snapshot.data;
              print(chi.length);
              return chi.length == 0 ? _emptyList() :
              ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) =>
                      _money_item_chi(chi[chi.length -1 - index], index),
                  separatorBuilder: (context, index) =>
                      Divider(color: Colors.black26,),
                  itemCount: chi.length
              );
          }
          return null; // unreachable
        }
    );
  }


  _money_item_thu(Detail data, int index) {
    return GestureDetector(
      child: ListTile(
        selected: index == _selThu? true : false,
        leading:  data.type_money=='the'? Icon(Icons.credit_card, color: Colors.blue,)
            : Icon(Icons.monetization_on, color: Colors.amber,),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(data.detail,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Text(data.type_money=='the'? 'Thẻ' : 'Tiền mặt', style: TextStyle(fontSize: 10),
            ),
            Text(data.time,
              style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(_formatNumber(data.money)),
            Text(" đ")
          ],
        ),

      ),
      onLongPress: (){
        setState(() {
          _selThu= index;
          _detail= data;
          _isEdit= false;
          _type= 1;
        });
      },
      onTap: (){
        setState(() {
          if(_selThu!=null ) {
            _selThu = null;
            _isEdit= true;
            _type= null;
          }
        });
      },
    );
  }

  _money_item_chi(Detail data, int index) {
    return GestureDetector(
      child: ListTile(
        selected: index == _selChi? true : false,
        leading:  data.type_money=='the'? Icon(Icons.credit_card, color: Colors.blue,)
            : Icon(Icons.monetization_on, color: Colors.amber,),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(data.detail,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Text(data.type_money=='the'? 'Thẻ' : 'Tiền mặt', style: TextStyle(fontSize: 10),
            ),
            Text(data.time,
              style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic),
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

      ),
      onLongPress: (){
        setState(() {
          _selChi= index;
          _detail= data;
          _isEdit= false;
          _type= 2;
        });
      },
      onTap: (){
        setState(() {
          if(_selChi!=null ) {
            _selChi = null;
            _isEdit= true;
            _type= null;
          }
        });
      },
    );
  }


  _emptyList() {
    return Center(
      child:
      Text("Chưa có dữ liệu..."),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  void _createDetailMoney(StatusBloc sttBloc, DetailBloc detailBloc) {
    showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                backgroundColor: Colors.white,
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(icon: Icon(
                          Icons.credit_card, size: 30, color: Colors.blue,),
                            onPressed: () => _showBottomSheet(sttBloc, detailBloc, 'the')
                        ),
                        Text("Tiền thẻ"),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(icon: Icon(
                          Icons.monetization_on, size: 30, color: Colors.blue,),
                            onPressed: () => _showBottomSheet(sttBloc, detailBloc, 'mat')
                        ),
                        Text('Tiền mặt'),
                      ],
                    ),
                  ],
                )
            )
    );


  }

  _showBottomSheet(StatusBloc sttBloc, DetailBloc detailBloc, String type){
    print(type);
        showModalBottomSheet(
        context: context,
        builder: (context) {
          return new Container(
            height: height / 1.4,
            color: Color(0xFF737373), //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: new Container(
                padding: EdgeInsets.all(16),
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(25.0),
                        topRight: const Radius.circular(25.0))),
                child:
                    SingleChildScrollView(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Form(
                          key: _formKey,
                          child: Column(
                              children: <Widget>[
                                SizedBox(height: height / 20,),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                                  child: TextFormField(
                                    controller: _moneyCtrl,
                                    validator: (value) => _moneyTabBloc.isValidNotEmpty(value),
                                    keyboardType: TextInputType.number,
                                    decoration: new InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.greenAccent, width: 1.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 1.0),
                                      ),
                                      hintText: 'Số tiền',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                                  child: TextFormField(
                                    controller: _detailCtrl,
                                    validator: (value) => _moneyTabBloc.isValidNotEmpty(value),
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 2,
                                    decoration: new InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.greenAccent, width: 1.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 1.0),
                                      ),
                                      hintText: 'Chi tiết',
                                    ),
                                  ),
                                ),
                                BottomSheetSwitch(
                                  groupValue: groupValue,
                                  valueChanged: (value) {
                                    groupValue = value;
                                  },
                                ),

                                FlatButton(
                                  onPressed: () {
                                    _addDetail(sttBloc, detailBloc, type);
                                  },
                                  child: Text("Thêm", style: TextStyle(color: Colors
                                      .white),),
                                  color: Colors.blue,
                                )

                              ],
                            ),
                        ),
                      ),
                )),
          );
        });
  }

  void _addDetail(StatusBloc sttBloc, DetailBloc detailBloc, String type_money) {
    if(_formKey.currentState.validate()){
      int money= int.parse(_moneyCtrl.text.trim());

      if(groupValue==2){
        //chi > số tiền ? -> không chi đc
        if(type_money=='the'){
          // so sánh thẻ
          int money_card=  int.parse(sttBloc.user.money_card);
          if(money>money_card) {
            Toast.show('Số tiền trong thẻ không đủ !', context,
                duration: Toast.LENGTH_LONG);
            return;
          }
        }else{
          // so sánh tiền mặt
          // so sánh thẻ
          int money_face=  int.parse(sttBloc.user.money_face);
          if(money>money_face) {
            Toast.show('Số tiền mặt hiện có không đủ !', context,
                duration: Toast.LENGTH_LONG);
            return;
          }
        }
      }

      Loader.showLoadingDialog(context);
      DateTime now = DateTime.now();
      print(now.toIso8601String());
      _moneyTabBloc.handlingCreateDetail(sttBloc.user_name,groupValue,
          Detail("", money.toString(), _detailCtrl.text.trim(), type_money, now.toIso8601String()))
      .then((value){
        Loader.hideLoadingDialog(context);
        if(value==null)
          MyDialog.showMsgDialogErr(context, "Lỗi", "Đã có lỗi !");
        else{
          if(value) {
            MyDialog.showMsgDialogSuccess(
                context, "Thành công", "Thêm thành công !");
            setState(() {
              sttBloc.refreshGetUser();
              detailBloc.refresh();
            });
          }else
            MyDialog.showMsgDialogErr(context, "Lỗi", "Đã có lỗi !");
        }
      });
    }
  }

  _removeDetail() {
    print("remove");
    MyDialog.showMsgDialog(context, "Xóa", "Bạn muốn xóa chứ?", _moneyTabBloc,_type, _detail);
    if(_selThu!=null || _selChi!=null) {
      _selChi= null;
      _selThu = null;
      _isEdit= true;
      _type= null;
    }
  }

  String _formatNumber(String number){
    String res='';
    int length= number.length;

    for (int i= length-1; i>= 0; i--) {
      if ((i != 0) && (length - i)%3==0)
       res =','+number[i]+res;
      else
      res= number[i]+res;
    }
    if (res[0]==',')
      res.replaceFirst(',', "");
    print(res);
    return res;
  }
}

class BottomSheetSwitch extends StatefulWidget {
  BottomSheetSwitch({@required this.groupValue, @required this.valueChanged});

  final int groupValue;
  final ValueChanged valueChanged;

  @override
  _BottomSheetSwitch createState() => _BottomSheetSwitch();
}

class _BottomSheetSwitch extends State<BottomSheetSwitch> {
  int groupValue;

  @override
  void initState() {
    groupValue = widget.groupValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Row(
          children: <Widget>[
            new Radio(
              value: 1,
              activeColor: Colors.blue,
              groupValue: groupValue,
              onChanged: (value){
                if(value==1) {
                  setState(() {
                    groupValue = value;
                    widget.valueChanged(value);
                  });
                }
              },
            ),
            Text("Thu", style: TextStyle(fontWeight: FontWeight.bold),)
          ],
        ),
        Row(
          children: <Widget>[
            new Radio(
              value: 2,
              activeColor: Colors.blue,
              groupValue: groupValue,
              onChanged: (value){
                print(value.toString());
                if(value==2) {
                  setState(() {
                    groupValue = value;
                    widget.valueChanged(value);
                  });
                }
              },
            ),
            Text("Chi", style: TextStyle(fontWeight: FontWeight.bold),)
          ],
        ),
      ],
    );
  }
}

