import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  //Login function
  Future<Null> loginUser(String _email, String _password) async {
    //getting instance
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', _email);
    prefs.setString('password', _password);
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    prefs.setInt("timestamp", timestamp);
  }

  // logout function
  Future<Null> removeStringDataFromKey(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  Future<String?> getStringDataFromKey(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(key);
    return data;
  }

  Future<Null> setStringToKey(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  Future<int?> getIntFromKey(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? data = prefs.getInt(key);
    return data;
  }
}
