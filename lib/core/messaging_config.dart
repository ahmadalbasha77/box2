import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_hms_gms_availability/flutter_hms_gms_availability.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:huawei_push/huawei_push.dart' as hms_push;
import 'package:permission_handler/permission_handler.dart';

import 'my_shared_preferences.dart';
Future<void> requestNotificationPermissions() async {
  final status = await Permission.notification.status;
  if (status.isDenied) {
    final result = await Permission.notification.request();
    if (result.isDenied || result.isPermanentlyDenied) {
      await openAppSettings();
    }
  } else if (status.isPermanentlyDenied) {
    await openAppSettings();
  }
}

class MessagingConfig {
  static String clickAction = '';
  static AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.', // description
    importance: Importance.max,
  );
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    await Firebase.initializeApp();
    if (Platform.isIOS) {
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );
    }
    if (Platform.isAndroid) {
      mySharedPreferences.isGMS = await FlutterHmsGmsAvailability.isGmsAvailable;
    } else {
      mySharedPreferences.isGMS = true;
    }
    log('isGMS : ${mySharedPreferences.isGMS}');
    if (mySharedPreferences.isGMS) {
      await FirebaseMessagingConfig.init();
    } else {
      await HuaweiMessagingConfig.init();
    }
    log('Device token : ${mySharedPreferences.deviceToken}');
  }
}

class FirebaseMessagingConfig {
  static Future<void> init() async {
    mySharedPreferences.deviceToken = await FirebaseMessaging.instance.getToken() ?? '';
    if (await FlutterAppBadger.isAppBadgeSupported()) {
      FlutterAppBadger.removeBadge();
    }
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    await MessagingConfig.flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(MessagingConfig.channel);
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    var initialNotification = await FirebaseMessaging.instance.getInitialMessage();
    if (initialNotification != null) {
      MessagingConfig.clickAction = initialNotification.data['click_action'] ?? '';
    }
    onMessage();
  }

  static void onMessage() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      MessagingConfig.clickAction = message.data['click_action'] ?? '';
      // Handle notification tap
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        MessagingConfig.flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              MessagingConfig.channel.id,
              MessagingConfig.channel.name,
              channelDescription: MessagingConfig.channel.description,
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );
      }
    });
  }

  static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // Background message handler
  }
}

class HuaweiMessagingConfig {
  static Future<void> init() async {
    await hms_push.Push.setAutoInitEnabled(true);
    hms_push.Push.getToken('');
    hms_push.Push.getTokenStream.listen(
          (event) {
        mySharedPreferences.deviceToken = event;
      },
      onError: (value) {
        log('Device token error : ${value.toString()}');
      },
    );
    if (await FlutterAppBadger.isAppBadgeSupported()) {
      FlutterAppBadger.removeBadge();
    }
    await hms_push.Push.registerBackgroundMessageHandler(hmsMessagingBackgroundHandler);
    onMessage();
  }

  static void onMessage() {
    hms_push.Push.onMessageReceivedStream.listen(onMessageReceived, onError: onMessageReceiveError);
    hms_push.Push.onNotificationOpenedApp.listen(_onNotificationOpenedApp);
  }

  static void _onNotificationOpenedApp(dynamic initialNotification) {
    // Handle notification tap
  }

  static void onMessageReceived(hms_push.RemoteMessage remoteMessage) {
    var notification = remoteMessage.notification;
    if (notification != null) {
      MessagingConfig.flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            MessagingConfig.channel.id,
            MessagingConfig.channel.name,
            channelDescription: MessagingConfig.channel.description,
            icon: '@mipmap/ic_launcher',
          ),
        ),
      );
    }
  }

  static void onMessageReceiveError(Object error) {
    log('Message receive error: $error');
  }

  static Future<void> hmsMessagingBackgroundHandler(hms_push.RemoteMessage message) async {
    var notification = message.notification;
    if (notification != null) {
      MessagingConfig.flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            MessagingConfig.channel.id,
            MessagingConfig.channel.name,
            channelDescription: MessagingConfig.channel.description,
            icon: '@mipmap/ic_launcher',
          ),
        ),
      );
    }
  }
}
