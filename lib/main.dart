import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'firebase_options.dart';
import 'services/notification/notification.dart';
import 'utilities/handle_file.dart';
// import 'home_app.dart';
// import 'presentation/services/notification/notification.dart';
// import 'presentation/services/provider/config_app_provider.dart';
// import 'presentation/services/provider/internet_provider.dart';
// import 'presentation/services/provider/language_provider.dart';
// import 'presentation/services/provider/theme_provider.dart';
// import 'presentation/utilities/handle_file.dart';
// import 'presentation/utilities/handle_internet.dart';

late NotificationService noti;
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage event) async {}

void _handleMessage(
  RemoteMessage message,
) async {
  final image = await UtilsDownloadFile.downloadFile(
      message.notification?.android?.imageUrl ?? "", "largeIcon");
  await noti.showNotification(
    id: 1,
    title: message.notification?.title ?? "",
    body: message.notification?.body ?? "",
    urlImage: image ?? "",
    payload: jsonEncode(message.data),
  );
}

Future<void> setupInteractedMessage() async {
  final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    log("initMes");
    noti.onNotificationClick.add(initialMessage.data);
  }
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    log("onMessOpened");
    noti.onNotificationClick.add(event.data);
  });
  FirebaseMessaging.onMessage.listen((event) {
    log("onMessage");
    _handleMessage(event);
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  noti = NotificationService();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await noti.initNotification();
  final deviceToken = await FirebaseMessaging.instance.getToken();
  tz.initializeTimeZones();

  await Hive.initFlutter();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(
    MyApp(deviceToken: deviceToken),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
    this.deviceToken,
  });
  final String? deviceToken;
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    setupInteractedMessage();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<ConnectivityResult>(
          create: (context) => Connectivity().onConnectivityChanged,
          initialData: ConnectivityResult.none,
        ),
        // ChangeNotifierProvider<ConfigAppProvider>(
        //   create: (context) => ConfigAppProvider(
        //     sharedPref: widget.sharedPref,
        //     env: env,
        //     noti: noti,
        //     navigatorKey: GlobalKey<NavigatorState>(),
        //     deviceToken: widget.deviceToken,
        //   ),
        // ),
        // ChangeNotifierProvider<ThemeProvider>(
        //   create: (context) => ThemeProvider(
        //     sharedPref: widget.sharedPref,
        //   ),
        // ),
        // ChangeNotifierProvider<LanguageProvider>(
        //   create: (context) => LanguageProvider(widget.sharedPref),
        // ),
      ],
      builder: (context, child) {
        return Container();
        // return Consumer<ConnectivityResult>(
        //   builder: (context, value, child) {
        //     return FutureBuilder<bool>(
        //       future: UtilHandlerInternet.checkInternet(result: value),
        //       builder: (context, snapshot) {
        //         bool isHaveInternet = snapshot.data ?? false;
        //         return HomeApp(isHaveInternet: isHaveInternet);
        //       },
        //     );
        //   },
        // );
      },
    );
  }
}
