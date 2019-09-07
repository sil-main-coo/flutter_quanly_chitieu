
import 'package:quanly_chitieu/api/shared_preferences.dart';

class LocalStorage{

  static Future<void> saveAccount(String user) async {
    SharedPfs.saveData('user', user);
  }

  static Future<String> getAccount() async {
    final body=  await SharedPfs.getData('user');
    return body;
  }

  static Future<bool> clearData() async {
    return await SharedPfs.clearData();
  }
}