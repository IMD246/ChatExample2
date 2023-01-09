import 'package:flutter/material.dart';
import 'package:flutter_basic_utilities/flutter_basic_utilities.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'handle_app.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = getDeviceSize(context: context);
    return ScreenUtilInit(
      designSize: size,
      splitScreenMode: true,
      minTextAdapt: true,
      builder: (context, child) {
        return const HandleApp();
      },
    );
  }
}
