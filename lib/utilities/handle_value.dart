import 'package:flutter/material.dart';

import '../enum/enum.dart';
import '../extensions/localization.dart';

class UtilHandleValue {
  static String getLanguage(Locale language, BuildContext context) {
    if (language.toString() == "vi_VN") {
      return context.loc.vietnamese;
    } else if (language.toString() == "en_US") {
      return context.loc.english;
    } else {
      return "";
    }
  }

  static String getFullLocale(Locale locale) {
    return "${locale.languageCode}_${locale.countryCode}";
  }

  static String setStatusMessageText(
      String messageStatus, BuildContext context) {
    if (messageStatus.toLowerCase() == MessageStatus.sent.name.toLowerCase()) {
      return context.loc.sent;
    } else if (messageStatus.toLowerCase() ==
        MessageStatus.viewed.name.toLowerCase()) {
      return context.loc.viewed;
    } else {
      return context.loc.not_sent;
    }
  }

  static bool isDarkMode(ThemeMode themeMode) {
    return themeMode == ThemeMode.dark ? true : false;
  }
  static String getFileExtension(String fileName) {
      return ".${fileName.split('.').last}";
  }
}
