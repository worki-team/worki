import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:meta/meta.dart';
import 'package:worki_ui/src/values/colors.dart';

NotificationDetails get _noSound {
  final androidChannelSpecifics = AndroidNotificationDetails(
    'silent channel id',
    'silent channel name',
    'silent channel description',
    playSound: false,
  );
  final iOSChannelSpecifics = IOSNotificationDetails(presentSound: false);

  return NotificationDetails(androidChannelSpecifics, iOSChannelSpecifics);
}

Future showSilentNotification(
    FlutterLocalNotificationsPlugin notifications, {
      @required String title,
      @required String body,
      int id = 0,
    }) =>
    _showNotification(notifications,
        title: title, body: body, id: id, type: _noSound);

NotificationDetails get _ongoing {
  final androidChannelSpecifics = AndroidNotificationDetails(
    'your channel id',
    'your channel name',
    'your channel description',
    importance: Importance.Max,
    priority: Priority.High,
    ongoing: false,
    autoCancel: true,
    color: AppColors.workiColor,
  );
  final iOSChannelSpecifics = IOSNotificationDetails();
  return NotificationDetails(androidChannelSpecifics, iOSChannelSpecifics);
}

Future showOngoingNotification(
  FlutterLocalNotificationsPlugin notifications, {
  @required String title,
  @required String body,
  @required String payload,
  int id = 0,
}) =>
    _showNotification(notifications,
        title: title, body: body, id: id, type: _ongoing, payload: payload);

Future _showNotification(
  FlutterLocalNotificationsPlugin notifications, {
  @required String title,
  @required String body,
  @required NotificationDetails type,
  @required String payload,
  int id = 0,
}) =>
    notifications.show(id, title, body, type, payload: payload);

Future showCalendarNotification(FlutterLocalNotificationsPlugin notifications,{
  @required String title,
  @required String body,
  @required scheduledDate,
  int id = 0,
}) => notifications.schedule(id, title, body, scheduledDate, _ongoing);