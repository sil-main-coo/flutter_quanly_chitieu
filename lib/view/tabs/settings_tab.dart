import 'package:flutter/material.dart';
import 'package:quanly_chitieu/widgets/dialog.dart';
import 'package:toast/toast.dart';
class SettingTab extends StatefulWidget {
  @override
  _SettingTabState createState() => _SettingTabState();
}

class _SettingTabState extends State<SettingTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      alignment: Alignment.center,
      child: Card(
        elevation: 5,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Hero(
              tag: 'tag_infor',
              child: ListTile(
                leading: Icon(Icons.person, color: Colors.blue,),
                title: Text('Thông tin tài khoản'),
                onTap: (){
                  MyDialog.showMsgDialogInforUser(context);
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.lock, color: Colors.blue,),
              title: Text('Đổi mật khẩu'),
              onTap: (){
                Toast.show('Tính năng đang được phát triển', context, duration: Toast.LENGTH_LONG);
              },
            ),
            ListTile(
              leading: Icon(Icons.add_to_home_screen, color: Colors.blue,),
              title: Text('Đăng xuất'),
              onTap: (){
                MyDialog.showLogOutDialog(context);
              },
            )
          ],
        ),
      ),
    );
  }

}
