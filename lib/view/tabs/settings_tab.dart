import 'package:flutter/material.dart';
class SettingTab extends StatefulWidget {
  @override
  _SettingTabState createState() => _SettingTabState();
}

class _SettingTabState extends State<SettingTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        FlatButton(
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16,right: 8),
                  child: Icon(Icons.person),
                ),
                Text("Thông tin tài khoản",style: TextStyle(fontSize: 12),),
              ],
            ),
          onPressed: (){

          },
        ),
        FlatButton(
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: Icon(Icons.person),
                ),
                Text("Thông tin liên hệ",style: TextStyle(fontSize: 12),),
              ],
            ),
          onPressed: (){

          },
        ),
      ],
    );
  }
}
