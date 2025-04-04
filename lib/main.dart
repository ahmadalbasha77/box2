import 'dart:developer';

import 'package:box_app/core/binding.dart';
import 'package:box_app/core/my_shared_preferences.dart';
import 'package:box_app/core/theme_app.dart';
import 'package:box_app/view/ui/splash.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import 'core/messaging_config.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await mySharedPreferences.init();
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    } else {}
  });

  try {
    await Firebase.initializeApp();
    String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
    if (apnsToken == null) {
    } else {
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      mySharedPreferences.deviceToken = fcmToken ?? "";
    }
  } catch (e) {
    log('$e');
  }
  MessagingConfig.init();
  FirebaseMessagingConfig.onMessage();

  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: themeApp,
      initialBinding: InitialBinding(),
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar'),
      home: const Splash(),
    );
  }
}
