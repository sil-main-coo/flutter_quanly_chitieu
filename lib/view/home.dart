import 'dart:io';
import 'package:flutter/material.dart';
import 'package:quanly_chitieu/blocs/bloc_status.dart';
import 'package:quanly_chitieu/view/tabs/money_tab.dart';
import 'package:quanly_chitieu/view/tabs/settings_tab.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sttBloc= StatusBloc.of(context);
    return sttBloc.user_name==null?
    _buildError():
     DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Icon(Icons.adb),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: (){
              exit(0);
            },
          ),
        ),
      body: TabBarView(
          children: [
            MoneyTab(),
            SettingTab()
          ],
      ),
      bottomNavigationBar: TabBar(
          labelColor: Colors.green,
          unselectedLabelColor: Colors.black,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(
              color: Colors.green,
              width: 1
            ),
            insets: EdgeInsets.fromLTRB(10, 0, 10, 40),
          ),
          tabs: <Widget>[
            Tab(
              icon: Icon(Icons.attach_money),
            ),
            Tab(
              icon: Icon(Icons.settings),
            )
          ],
            ),
      ),
    );
  }

  _buildError() {
    return Center(
      child: Text("Đã xảy ra lỗi !"),
    );
  }
}
