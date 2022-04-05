import 'package:get/get.dart';
import 'package:wakeuprecord/models/alarm_info.dart';
import 'package:wakeuprecord/utils/notification.dart';

class MainController extends GetxController {
  AlarmNotification noti = AlarmNotification();

  @override
  void onInit() async {
    AlarmInfo info = AlarmInfo(index: 0, time: '23:12', day: [true,true,true,true,true,true,true], isRun: true);

    noti.initNotiSetting();
    noti.dailyAtTimeNotification(info);
    update();
    super.onInit();
  }
}

/*
import 'package:get/get.dart';
import 'package:wakeup/ui/screen_clock.dart';
import 'package:wakeup/ui/screen_info.dart';
import 'package:wakeup/ui/screen_record.dart';
import 'package:wakeup/utils/firebase_database.dart';
import 'package:wakeup/utils/notification.dart';

import '../models/alarm_info.dart';
import '../ui/screen_alarm.dart';

class MainController extends GetxController {
  static const key = 'Main';
  List screens = [ ScreenClock(), ScreenAlarm(), ScreenRecord(), ScreenInfo() ]; // Screen List

  final FirebaseDataBase dataBase = FirebaseDataBase();
  final AlarmNotification noti = AlarmNotification();

  var showScreenIndex = 0;            // Screen List, Menu List   Index
  bool isShowProgress = false;

  @override
  void onInit() async {
    noti.initNotiSetting();
    dataBase.getAlarmList().then((value) {
      for (AlarmInfo row in dataBase.alarmList) {
        if (row.isRun) {
          // if (row.isRun && row.day[DateTime.now().weekday - 1]) {    /// 실행하기로 되어있는지 체크
          noti.dailyAtTimeNotification(row);
        }
      }
    });
    dataBase.getRecordList(); // 기록 data 가져오기
    dataBase.getInfo();       // UserInfoLocal
    dataBase.downloadFile();
    update();
    super.onInit();
  }

  void setScreen(int index) {
    showScreenIndex = index;
    update();
  }

  /// progress Indicator ON & OFF
  void setShowProgress(bool show) {
    isShowProgress = show;
    update();
  }
}*/
