import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:worki_ui/src/models/administrator_model.dart';
import 'package:worki_ui/src/pages/Administrator/admin_manage_coordinator.dart';
import 'package:worki_ui/src/providers/administrator_provider.dart';
import 'package:worki_ui/src/providers/firebase_provider.dart';
import 'package:worki_ui/src/values/button_decoration.dart';

class AdminSettingPage extends StatefulWidget {
  Administrator admin;
  AdminSettingPage({this.admin});
  @override
  _AdminSettingPageState createState() => _AdminSettingPageState(admin: this.admin);
}

class _AdminSettingPageState extends State<AdminSettingPage> {
  Administrator admin;
  _AdminSettingPageState({this.admin});
  FirebaseProvider firebaseProvider = new FirebaseProvider();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  AdministratorProvider adminProvider = new AdministratorProvider();

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
              if(admin.devices.contains(token)){
                admin.devices.remove(token);
                await adminProvider.updateAdministrator(admin);
              }
              firebaseProvider.signOut();
              Navigator.of(context).pushReplacementNamed('welcome');
            },
            child: Text('Salir',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
