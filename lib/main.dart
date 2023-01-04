import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'StateManager/provider/get_list_provider.dart';
import 'firebase_options.dart';
import 'home_app.dart';
import 'services/notification/notification.dart';
import 'utilities/handle_file.dart';

late NotificationService noti;
late SharedPreferences sharedPref;
late String? deviceToken;
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  noti = NotificationService();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await noti.initNotification();
  tz.initializeTimeZones();

  await Hive.initFlutter();

  sharedPref = await SharedPreferences.getInstance();

  deviceToken = await FirebaseMessaging.instance.getToken();

  FirebaseMessaging.onBackgroundMessage(
    _firebaseMessagingBackgroundHandler,
  );

  runApp(
    MyApp(
      deviceToken: deviceToken,
      sharedPref: sharedPref,
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
    this.deviceToken,
    required this.sharedPref,
  });
  final String? deviceToken;
  final SharedPreferences sharedPref;
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
      providers: getListRepositoryProvider(),
      child: const HomeApp(),
    );
  }
}
