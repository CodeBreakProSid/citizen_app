// ignore_for_file: file_names, avoid_print
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../home/controllers/home_controller.dart';
import '../home/views/widgets/notification_main_view.dart';

Future<void> _firebaseMessagingBackgroundHandler(
  RemoteMessage message,
) async {
  print(message);
  await Firebase.initializeApp();
}

Future<void> _firebaseMessageingForegroundHandler(RemoteMessage message) async {
  if (message.notification != null) {
    await Firebase.initializeApp();
  }
}

class ForgroundLocalNotification {
  static final FlutterLocalNotificationsPlugin _notiPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    const InitializationSettings initialSettings = InitializationSettings(
      android: AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      ),
    );
    _notiPlugin.initialize(
      initialSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        Get.put(HomeController());
        Get.to(const NotificationMainView());
      },
    );
  }

  static Future<String?> getFcmToken() async {
    final String? fcmKey = await FirebaseMessaging.instance.getToken();
    // print('Firebase FCM token :  $fcmKey');

    return fcmKey;
  }

  static void showNotification(RemoteMessage message) {
    const NotificationDetails notDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'org.citizen.janamaithri',
        'push_notification',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );
    _notiPlugin.show(
      DateTime.now().microsecond,
      message.notification!.title,
      message.notification!.body,
      notDetails,
      payload: message.data.toString(),
    );
  }

  static Future<void> handleBackGroundMessage() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> handleForeGroundMessage() async {
    FirebaseMessaging.onMessage.listen(_firebaseMessageingForegroundHandler);
  }
}
