import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationPlugin {
  NotificationPlugin() {
    initializeNotifications();
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  initializeNotifications() {
    var initializeSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initialSettings = InitializationSettings(
        initializeSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initialSettings,
        onSelectNotification: selectNotification);
  }

  Future selectNotification(String payload) async {
    if (payload != null) {
      print(payload);
    }
  }

  Future dailyNotification(
      Time time, String message, String subtext, int id, String payload,
      {String sound}) async {
    var androidChannel = AndroidNotificationDetails(
      'channel-id',
      'channel-name',
      'channel-description',
      importance: Importance.Max,
      priority: Priority.Max,
    );

    var iosChannel = IOSNotificationDetails();
    var platformChannel = NotificationDetails(androidChannel, iosChannel);
    flutterLocalNotificationsPlugin.showDailyAtTime(
        id, message, subtext, time, platformChannel,
        payload: payload);
  }

  void dailyNotificationFunction(String subtitle,int hour, int minute, String period, int id, String payload) {
    if (period == 'PM') {
      hour = hour + 12;
      dailyNotification(Time(hour, minute, 0), 'Wake up',subtitle, id, payload);
    } else {
      dailyNotification(Time(hour, minute, 0), 'Wake up',subtitle, id, payload);
    }
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
  Future<void> cancelAllNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
  Future periodicNotification(String message, String subtext, int id, String payload,
      {String sound}) async {
    var androidChannel = AndroidNotificationDetails(
      'repeating channel-id',
      'repeating channel-name',
      'repeating channel-description',
      importance: Importance.Max,
      priority: Priority.Max,
    );

    var iosChannel = IOSNotificationDetails();
    var platformChannel = NotificationDetails(androidChannel, iosChannel);
    flutterLocalNotificationsPlugin.periodicallyShow(
        69, message, subtext,RepeatInterval.Hourly, platformChannel,
        payload: payload);
  }
  //static int notificationAppLaunchDetails = flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
}
