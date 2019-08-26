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
  int _sel;
  int _type;
  String _id;
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
          _buildTabView(sttBloc.userId, detailBloc)
          //_detail_money(sttBloc.userId)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _isEdit? Colors.blue : Colors.red,
        child: Icon(_isEdit? Icons.create:  Icons.close),
        onPressed: () {
          _isEdit? _createDetailMoney(sttBloc, detailBloc) : _removeDetail(_id);
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
              _type_money("Tài khoản thẻ", user.money_card, Colors.blue),
              _type_money("Tiền mặt", user.money_face, Colors.amberAccent)
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
              return thu == null ? _emptyList() :
              ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) =>
                      _money_item(thu[thu.length -1 - index], index, 1),
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
                      _money_item(chi[chi.length -1 - index], index, 2),
                  separatorBuilder: (context, index) =>
                      Divider(color: Colors.black26,),
                  itemCount: chi.length
              );
          }
          return null; // unreachable
        }
    );
  }


  _money_item(Detail data, int index, int type) {
    return GestureDetector(
      child: ListTile(
        selected: index == _sel? true : false,
        leading: Icon(Icons.adb),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(data.detail,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Text("Thẻ", style: TextStyle(fontSize: 10),
            ),
            Text("11:22 22/12/2011",
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
          _sel= index;
          _id= data.id;
          _isEdit= false;
          _type= type;
        });
      },
      onTap: (){
        setState(() {
          if(_sel!=null ) {
            _sel = null;
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
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                          height: height / 100,
                          width: width / 4,
                          decoration: new BoxDecoration(
                              color: Colors.black,
                              borderRadius: new BorderRadius.all(
                                const Radius.circular(25.0),)
                          )
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
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
                                  _addDetail(sttBloc, detailBloc);
                                },
                                child: Text("Thêm", style: TextStyle(color: Colors
                                    .white),),
                                color: Colors.blue,
                              )

                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )),
          );
        });
  }

  void _addDetail(StatusBloc sttBloc, DetailBloc detailBloc) {
    if(_formKey.currentState.validate()){
      Loader.showLoadingDialog(context);
      _moneyTabBloc.handlingCreateDetail(sttBloc.userId,groupValue, Detail("", _moneyCtrl.text.trim(), _detailCtrl.text.trim()))
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

  _removeDetail(String id) {
    print("remove");
    MyDialog.showMsgDialog(context, "Xóa", "Bạn muốn xóa chứ?", _moneyTabBloc,_type, _id);
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

