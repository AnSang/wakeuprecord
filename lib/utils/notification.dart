import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:wakeuprecord/utils/strings.dart';

import '../models/alarm_info.dart';

class AlarmNotification {
  final plugin = FlutterLocalNotificationsPlugin();

  /// init Notification
  void initNotiSetting() async {
    const initSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettingsIOS = IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    const initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIOS,
    );
    await plugin.initialize( initSettings, onSelectNotification: onSelectNotification );
  }

  /// Set Notification
  Future dailyAtTimeNotification(AlarmInfo alarm) async {
    int hour = int.parse(alarm.time.split(':')[0]);
    int min  = int.parse(alarm.time.split(':')[1]);

    String notiDesc = '$hour시 $min분';
    String notiID = alarm.index.toString();

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /*if (Platform.isIOS) {
      final bool? result = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );

      if (result != null && result) {
        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
            ?.deleteNotificationChannelGroup(notiID);
      }
    }*/

    var android = AndroidNotificationDetails(
        notiID,
        Word.ALARM,
        channelDescription: notiDesc,
        importance: Importance.max,
        playSound: true,
        priority: Priority.max
    );
    const ios = IOSNotificationDetails();
    var detail = NotificationDetails(android: android, iOS: ios);

    await flutterLocalNotificationsPlugin.zonedSchedule(
        alarm.index,
        Word.ALARM,
        notiDesc,
        _setNotiTime(alarm.time),
        detail,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);

    // await flutterLocalNotificationsPlugin.periodicallyShow(  반복 알람
  }

  /// 알람 삭제하기
  Future deleteAlarm(int alarmId) async {
    await plugin.cancel(alarmId);
  }

  /// notification 눌렀을때
  Future onSelectNotification(String? payload) async {
    DateTime now = DateTime.now();
    String date = '${now.year}.${now.month}.${now.day}';
    String time = '${now.hour}:${now.minute}';

    // final FirebaseDataBase dataBase = FirebaseDataBase();
    // dataBase.addRecord(date, time);
  }

  /// 시간지정하기
  tz.TZDateTime _setNotiTime(String time) {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));

    final now = tz.TZDateTime.now(tz.local);
    final alarm = tz.TZDateTime(tz.local, now.year, now.month, now.day, now.hour, now.minute, now.second + 10);
    // final alarm = tz.TZDateTime(tz.local, now.year, now.month, now.day, int.parse(time.split(':')[0]), int.parse(time.split(':')[1]));

    if (now.isBefore(alarm)) {
      return alarm;
    } else {
      return alarm.add(const Duration(days: 1));
    }
  }
}
