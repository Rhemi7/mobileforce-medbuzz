import 'package:MedBuzz/ui/views/notification_tone/notification_tone_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:MedBuzz/main.dart';
import 'package:MedBuzz/ui/views/fitness_reminders/all_fitness_reminders_screen.dart';
import 'package:provider/provider.dart';

class FitnessNotificationManager {
  var flutterLocalNotificationsPlugin;

  BuildContext context;

  FitnessNotificationManager() {
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    initNotifications();
  }

//  BuildContext get context => context;

  getNotificationInstance() {
    return flutterLocalNotificationsPlugin;
  }

  void initNotifications() {
    // initialise the plugin.
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  void showFitnessNotificationDaily(
      {int id, String title, String body, DateTime dateTime}) async {
    var time = new Time(dateTime.hour, dateTime.minute, 0);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        id, title, body, time, getPlatformChannelSpecfics(id));
    print(
        'Notification Succesfully Scheduled at ${dateTime.toString()} with id of $id');
  }

  Day nf = Day(1);

  void showFitnessNotificationWeekly({
    int id,
    String title,
    String body,
//    int dy,
    Day dy,
    DateTime dateTime,
  }) async {
    var time = Time(dateTime.hour, dateTime.minute, 0);
    // the value passed as an argument in Day is an example for monday
    await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
        id, title, body, dy, time, getPlatformChannelSpecfics(id));
    print(
        'Notification Succesfully scheduled weekly on ${dy.toString()}s at ${dateTime.toString()} with id of $id');
  }

  void showFitnessNotificationOnce(
      {int id, String title, String body, DateTime datetime}) async {
    var time = Time(datetime.hour, datetime.minute, 0);

    await flutterLocalNotificationsPlugin.schedule(
        id, title, body, time, getPlatformChannelSpecfics(id));
    print(
        'Notification Succesfully Scheduled at ${time.toString()} with id of $id');
  }

  getPlatformChannelSpecfics(int id) {
//    var model = Provider.of<NotificationToneModel>(context);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        '$id', 'your channel name', 'your channel description',
//        sound: RawResourceAndroidNotificationSound(
//            Provider.of<NotificationToneModel>(context).reminderSound()),
        importance: Importance.Max,
        priority: Priority.High,
        ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    return platformChannelSpecifics;
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    return Future.value(1);
  }

  Future onSelectNotification(String payload) async {
    print('Notification clicked');
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    await Navigator.push(
      MyApp.navigatorKey.currentState.context,
      MaterialPageRoute(
          builder: (context) => FitnessSchedulesScreen(payload: payload)),
    );
  }

  void removeReminder(int notificationId) {
    flutterLocalNotificationsPlugin.cancel(notificationId);
    print('Notfication with id: $notificationId been removed successfully');
  }

  // Method 1
//  Future _showNotificationWithSound(String tone) async {
//    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
//        'your channel id', 'your channel name', 'your channel description',
//        sound: RawResourceAndroidNotificationSound(reminderSound),
//        importance: Importance.Max,
//        priority: Priority.High);
//    var iOSPlatformChannelSpecifics =
//        new IOSNotificationDetails(sound: "slow_spring_board.aiff");
//    var platformChannelSpecifics = new NotificationDetails(
//        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
//    await flutterLocalNotificationsPlugin.show(
//      0,
//      'New Post',
//      'How to Show Notification in Flutter',
//      platformChannelSpecifics,
//      payload: 'Custom_Sound',
//    );
//  }
}
