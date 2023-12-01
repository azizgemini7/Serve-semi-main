import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLanguage with ChangeNotifier {
  String language = 'ar';

  Future<void> changeLanguage(String newLanguage) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('lang', newLanguage);
    language = newLanguage;
    notifyListeners();
  }

  Future<void> getStoredLanguage() async => await _getStoredLanguage();

  Future<void> _getStoredLanguage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('lang')) {
      language = prefs.getString('lang');
    }
    notifyListeners();
  }
}
