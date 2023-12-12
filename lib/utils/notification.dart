import 'package:expirationdate_reminder/ctrls/SettingController.dart';
import 'package:expirationdate_reminder/utils/data_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class Notification {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  late BuildContext context;

  SettingController _settingController = Get.put(SettingController());

  init(BuildContext context) async {
    _init();
    Future.delayed(const Duration(seconds: 3), _requestNotificationPermission());

    List<PendingNotificationRequest> list = await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    for (int i = 0; i < list.length; i++) {
      print("#@@@@@@@@@@@@@ list[$i] : ${list[i].id} ${list[i].title} ${list[i].body}");
    }

    this.context = context;
  }

  _init() async {
    AndroidInitializationSettings androidInitializationSettings = const AndroidInitializationSettings('mipmap/ic_launcher');

    DarwinInitializationSettings iosInitializationSettings = DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) async {
    print("@@@@ [$id] [$title] [$body] [$payload]");
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title!),
        content: Text(body!),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
            },
          )
        ],
      ),
    );
  }

  _requestNotificationPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  NotificationDetails _getNotificationDetails() {
    AndroidNotificationDetails androidNotificationDetails = const AndroidNotificationDetails(
      'reminder',
      'reminder_android',
      importance: Importance.max,
      priority: Priority.max,
      showWhen: false,
    );

    return NotificationDetails(
      android: androidNotificationDetails,
      iOS: const DarwinNotificationDetails(badgeNumber: 1),
    );
  }

  Future<void> showNotification() async {
    // await flutterLocalNotificationsPlugin.show(0, 'test', 'test body', _getNotificationDetails());
  }

  _getTimeZones(int expiration) {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
    tz.TZDateTime date = tz.TZDateTime.fromMillisecondsSinceEpoch(tz.local, expiration);
    tz.TZDateTime time = tz.TZDateTime(tz.local, date.year, date.month, date.day,
        _settingController.alertTime.value!.hour, _settingController.alertTime.value!.minute);

    print("#### ${time.year}.${time.month}.${time.day} ${time.hour}시${time.minute}분");
    print("");

    return time;
  }

  Future<void> zonedNotification(Food food) async {
    if (!_settingController.alertUse.value) return;

    String title = '유통기한 임박';
    String body = '[${food.name}] 유통기한이 오늘까지 입니다.';

    print("#### _zonedNotification ####");
    print("#### [$title] $body");

    await removeNotification(food.id!);

    tz.TZDateTime time = _getTimeZones(food.expiration);
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    if (time.isAfter(now)) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        food.id!,
        title,
        body,
        time,
        _getNotificationDetails(),
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
      );
    }
  }

  Future<void> removeNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> removeNotifications(List ids) async {
    for (int i = 0; i < ids.length; i++) {
      await flutterLocalNotificationsPlugin.cancel(ids[i]);
    }
  }

  Future<void> removeNotificationAll() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
