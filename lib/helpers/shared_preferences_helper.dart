import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static final SharedPreferencesHelper _singleton = SharedPreferencesHelper._();
  static SharedPreferencesHelper get instance => _singleton;
  SharedPreferencesHelper._();

  //! isList Operations
  final String _isListKey = "isList_key";

  Future<bool> setIsList(bool v) async {
    return (await SharedPreferences.getInstance()).setBool(_isListKey, v);
  }

  Future<bool> getIsList() async {
    return (await SharedPreferences.getInstance()).getBool(_isListKey) ?? true;
  }
}
