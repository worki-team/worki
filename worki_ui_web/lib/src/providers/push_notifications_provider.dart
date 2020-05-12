//import 'dart:io';
import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationProvider {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  //FirebaseMessaging.getInstance().subscribeToTopic("TopicName");
  final _mensajeStreamController = StreamController<String>.broadcast();
  Stream<String> get mensajes => _mensajeStreamController.stream;

  initNotifications(){
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.getToken().then((token){

        print('=======FMC Token======');
        print(token);
    });
    _firebaseMessaging.configure(
       onMessage: ( info ) async {
        print('======================================OnMessage======================================');
        print(info);
        //final noti = info['data']['Usuario'];
        //print(noti);
        
        String argumento = 'no-data';
        //if(Platform.isAndroid){
          argumento = info['data']['Usuario'];
        //}
        _mensajeStreamController.sink.add(argumento);

      },
      onLaunch: ( info ) async {
        print('======================================OnLaunch======================================');
        print(info);
        final noti = info['data']['Usuario'];
        print(noti);
      },
 
      onResume: ( info ) async {
        print('======================================OnResume======================================');
        print(info);
        final noti = info['data']['Usuario'];
        _mensajeStreamController.sink.add(noti);
        //fSxpAm1Wwuo:APA91bFtoKSjbbKDCs_vcQZ2YYeyybiXwja4GxMRl5qfoUXVFpTBdSQDBihVvuL0lFogUK982Lbtfz9iVnpnYuVGQopFxKAeBybZCWHaoQ4dagXfcdmnWweALWbywXNKo2FXu0E1twBn
      }
    );
  }
  dispose(){
    _mensajeStreamController?.close();
  }
}

/*
{
	"to": "cqc-xKKxihM:APA91bEJc-0lN7OTssRBjmuMBsi6AdzdjCkskF9kOf_TMB5zDqxTFDF0-VXalCdVCSfqC5WSJ-xylXFm-nYEheFZg5Uze0t2gbPcfvoNyk8UodcmM7yP_wgmLsKO8BtlROSXROGuhQxK",
	"notification": {
		"title": "Postman",
		"body": "Body desde Postman"
	}
	"data": {
		"comida": "Comida desde Postman"
	} 
}
*/