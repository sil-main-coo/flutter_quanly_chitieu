import 'package:shared_preferences/shared_preferences.dart';

class SharedPfs{
  static Future<void> saveData(String key, var value) async {
    final prefs = await SharedPreferences.getInstance();
    if(value is int)
      return prefs.setInt(key, value);
    else if(value is double)
      return prefs.setDouble(key, value);
    else if(value is String)
      return prefs.setString(key, value);
    else if(value is bool)
      return prefs.setBool(key, value);
    else
      return prefs.setStringList(key, value); // list String
  }

  static Future<dynamic> getData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.get(key);
  }

  static Future<void> deleteDataWithKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  static Future<bool> clearData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }

}