import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:worki_ui/src/models/user_model.dart';
import 'package:worki_ui/src/models/notification_model.dart';
import 'package:http/http.dart' as http;
import 'package:worki_ui/src/utils/alert.dart';
import 'package:worki_ui/src/utils/notification_helper.dart';

class PushNotificationProvider {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  //FirebaseMessaging.getInstance().subscribeToTopic("TopicName");
  final _mensajeStreamController = StreamController<String>.broadcast();
  Stream<String> get mensajes => _mensajeStreamController.stream;
  String tok;
  User user;
  final String url = 'https://demo-worki.herokuapp.com';
  final notifications = FlutterLocalNotificationsPlugin();
  
  initNotifications(){
    final settingsAndroid = AndroidInitializationSettings('app_icon');
    final settingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) =>
            onSelectNotification(payload));

    notifications.initialize(
        InitializationSettings(settingsAndroid, settingsIOS),
        onSelectNotification: onSelectNotification);


    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.getToken().then((token){
        print('=======FMC Token======');
        print(token);
        tok = token;
        
    });
    _firebaseMessaging.configure(
      onMessage: (info) async {
        print("======= On Message =============");
        print(info);
        showOngoingNotification(
          notifications,
          title: info['notification']['title'], 
          body:info['notification']['body'],
          payload: info['data'].toString()
        );

        if(info['data']['schedule'] == 'true'){
          print('NOTIFICACIÓN DE CALENDARIO');
          showCalendarNotification(
            notifications, 
            title: info['data']['jobName'], 
            body: 'Tu próximo evento te espera. Fecha: '+info['data']['date'], 
            scheduledDate: DateTime.parse(info['data']['date']).subtract(Duration(days: 1))
          );
        }
      },
      
      onLaunch: (info) async {
        print("======= On Launch =============");
        print(info);
        print('Hola');
        if(info['data']['schedule'] == 'true'){
          print('NOTIFICACIÓN DE CALENDARIO');
          showCalendarNotification(
            notifications, 
            title: info['data']['jobName'], 
            body: 'Tu próximo evento te espera. Fecha: '+info['data']['date'], 
            scheduledDate: DateTime.parse(info['data']['date']).subtract(Duration(days: 1))
          );
        }
      },
      
      onResume: (info) async {
        print("======= On Resume =============");
        print(info); 
        if(info['data']['schedule'] == 'true'){
          print('NOTIFICACIÓN DE CALENDARIO');
          showCalendarNotification(
            notifications, 
            title: info['data']['jobName'], 
            body: 'Tu próximo evento te espera. Fecha: '+info['data']['date'], 
            scheduledDate: DateTime.parse(info['data']['date']).subtract(Duration(days: 1))
          );
        }
      }
    );
  }
  dispose(){
    _mensajeStreamController?.close();
  }

  sendNotification(NotificationModel notification, String userId) async {
    final String notificationUrl = '$url/api/sendByUser/$userId'; //url
    print("POST : " + notificationUrl); 
    final req = await http.post(
      notificationUrl,
      headers: {"Content-type": "application/json"},
      body: jsonEncode(notification.toJson())
    );
    print('MENSAJE');
    print(req.body);
  }

  Future onSelectNotification(String payload) async { 
    
  }
}
