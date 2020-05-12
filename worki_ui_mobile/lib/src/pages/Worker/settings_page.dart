import 'dart:io';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:worki_ui/src/models/worker_model.dart';
import 'package:worki_ui/src/providers/firebase_provider.dart';
import 'package:worki_ui/src/providers/worker_provider.dart';
import 'package:worki_ui/src/utils/alert.dart';
import 'package:worki_ui/src/values/button_decoration.dart';
import 'package:worki_ui/src/values/colors.dart';

class SettingsPage extends StatefulWidget {
  final Worker worker;
  SettingsPage({@required this.worker});

  @override
  _SettingsPageState createState() => _SettingsPageState(worker: this.worker);
}

class _SettingsPageState extends State<SettingsPage> {
  FirebaseProvider firebaseProvider = FirebaseProvider();
  final Worker worker;
  _SettingsPageState({this.worker});
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  WorkerProvider workerProvider = new WorkerProvider();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Container(
          decoration: ButtonDecoration.workiButton,
          height: 60,
          width: 200,
          child: FlatButton(
            onPressed: () async {
              var pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
              pr.style(
                message: 'Cerrando sesión',
                borderRadius: 10.0,
                backgroundColor: Colors.white,
                progressWidget: CircularProgressIndicator(),
                elevation: 10.0,
                insetAnimCurve: Curves.easeInOut,
                progressTextStyle: TextStyle(
                    color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
                messageTextStyle: TextStyle(
                    color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
              );
              pr.show();
              String token;
              token = await _firebaseMessaging.getToken();
              if(worker.devices.contains(token)){
                worker.devices.remove(token);
                await workerProvider.updateWorker(worker);
              }
              firebaseProvider.signOut();
              Navigator.of(context).pushReplacementNamed('welcome');
            },
            child: Text('Salir',
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: 30,
                color: Colors.white
              )
            ),
          ),
        ),
      ),
    );
  }
}
