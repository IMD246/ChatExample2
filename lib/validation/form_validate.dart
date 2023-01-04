import 'package:flutter/cupertino.dart';

import '../extensions/localization.dart';

class UtilValidation {
  static String handleEmptyText(String value) {
    if (value.isEmpty) {
      return "Không được để trống";
    }
    return "";
  }

  static String handleLengthText({
    required String value,
    int length = 2,
    required BuildContext context,
  }) {
    if (value.length < length) {
      return context.loc.error_length_text(length);
    }
    return "";
  }

  static String handleLengthTextWithoutContext({
    required String value,
    int length = 2,
  }) {
    if (value.length < length) {
      return "Không được nhỏ hơn $length";
    }
    return "";
  }

  static bool checkLengthTextIsValid({
    required String value,
    int length = 2,
  }) {
    if (value.length <= length) {
      return false;
    }
    return true;
  }
}
