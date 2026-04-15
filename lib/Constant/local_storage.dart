import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static SharedPreferences? _prefs;

  Future<bool> init() async {
    bool result = false;
    await SharedPreferences.getInstance().then((value){
      _prefs = value;
      result = true;
      debugPrint("Preferences Started Successfully");
    });
    return result;
  }

  static putString(String key, String value) {
    if (_prefs != null) _prefs!.setString(key, value);
  }

  static String getString(String key) {
    return _prefs == null ? "" : _prefs!.getString(key) ?? "";
  }
  static putBool(String key, bool value) {
    if (_prefs != null) _prefs!.setBool(key, value);
  }

  static bool getBool(String key) {
    return _prefs == null ? false : _prefs!.getBool(key) ?? false;
  }
  static clearAll()async{
    await _prefs!.clear();
    // Get.offAndToNamed(Routes.splashScreen);
  }
}