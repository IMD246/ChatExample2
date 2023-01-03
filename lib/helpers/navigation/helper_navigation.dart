import 'package:flutter/material.dart';

class HelperNavigation {
  // static HelperNavigation? instance = HelperNavigation.getInstance();

  // HelperNavigation._();

  // factory HelperNavigation.getInstance() {
  //   if (instance == null) {
  //     instance = HelperNavigation._();
  //   }
  //   return instance!;
  // }

  static Future<dynamic> push({
    required BuildContext context,
    required Widget widget,
    RouteSettings? routeSettings,
  }) async {
    return await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context1) {
          return widget;
        },
        settings: routeSettings,
      ),
    );
  }
}
