

import 'package:shared_preferences/shared_preferences.dart';

class StorageServices {

  static Future<SharedPreferences> get _prefs async => await SharedPreferences.getInstance();

  static Future<void> setLogin(bool value) async {

    final prefs = await _prefs;
    await prefs.setBool('isLoggedIn', value);
  }

  static Future<bool> getLogin() async{
    final prefs = await _prefs;
    return prefs.getBool('isLoggedIn') ?? false;
  }

  static Future<void>setOnboarding(bool value) async{
    final prefs = await _prefs;
    await prefs.setBool('seenOnboarding', value);
  }

  static Future<bool> getOnboarding() async{
    final prefs = await _prefs;
    return prefs.getBool('seenOnboarding') ?? false;
  }
  static Future<void> logout() async {
    final prefs = await _prefs;
    await prefs.setBool('isLoggedIn', false);
  }

}