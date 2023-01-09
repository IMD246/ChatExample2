import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/constant.dart';

class LanguageProvider extends ChangeNotifier {
  late Locale locale;
  final SharedPreferences sharedPref;

  LanguageProvider(this.sharedPref) {
    getInitLocale();
  }

  Future<void> changeLocale(
      {required String language, required String userID}) async {
    final value = await sharedPref.setString(Constants.languageKey, language);
    if (value) {
      setLocale(language: language);
    }
  }

  getInitLocale() {
    final language = sharedPref.getString(Constants.languageKey);
    if (language == null || language == "") {
      locale = const Locale("vi","VN");
    } else {
      final splitLanguage = language.split("_");
      locale = Locale(
        splitLanguage[0],
        splitLanguage[1],
      );
    }
    notifyListeners();
  }

  void setLocale({required String language}) {
    final splitLanguage = language.split("_");
    locale = Locale(
      splitLanguage[0],
      splitLanguage[1],
    );
    notifyListeners();
  }
}
