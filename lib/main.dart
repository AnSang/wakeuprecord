import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() {
  runApp(Screen());
}

class Screen extends StatefulWidget {
  Screen({Key? key}) : super(key: key);

  @override _ScreenState createState() => _ScreenState();
}
class _ScreenState extends State<Screen> {
  Notification noti = Notification();
  String text = '';
  Color color = Colors.white;

  @override
  void initState() {
    noti.initNotiSetting();
    for (int i = 0; i < 1; i++) {
      noti.dailyAtTimeNotification(i);
      text += '$i 번째 알람 실행\n';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}



class Notification {
  final plugin = FlutterLocalNotificationsPlugin();

  /// init Notification
  void initNotiSetting() async {
    const initSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettingsIOS = IOSInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true
    );
    const initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIOS,
    );
    await plugin.initialize( initSettings, onSelectNotification: onSelectNotification );
  }

  Future dailyAtTimeNotification(int index) async {
    if (Platform.isIOS) {
      final bool? result = await plugin
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );

      if (result != null && result) {
        await plugin
            .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
            ?.deleteNotificationChannelGroup(index.toString());
      }
    }

    var android = AndroidNotificationDetails(
      index.toString(),
      'title',
      channelDescription: 'description',
      importance: Importance.max,
      playSound: true,
      sound: const RawResourceAndroidNotificationSound('sound'),
      priority: Priority.max,

    );
    const ios = IOSNotificationDetails(
        sound: 'sound.wav'
    );
    var detail = NotificationDetails(android: android, iOS: ios);

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
    final now = tz.TZDateTime.now(tz.local);
    final alarm = tz.TZDateTime(tz.local, now.year, now.month, now.day, now.hour, now.minute, now.second + 5);

    await plugin.zonedSchedule(
        index,
        '',
        'notiDesc',
        alarm,
        detail,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime
    );
  }


  Future onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) async {
    print('눌러짐');
  }

  /// notification 눌렀을때
  Future onSelectNotification(String? payload) async {
    print('눌러짐');
  }
}