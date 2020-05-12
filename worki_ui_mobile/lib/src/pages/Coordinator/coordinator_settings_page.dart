import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:worki_ui/src/models/coordinator_model.dart';
import 'package:worki_ui/src/pages/Coordinator/coordinator_profile.dart';
import 'package:worki_ui/src/providers/coordinator_provider.dart';
import 'package:worki_ui/src/providers/firebase_provider.dart';
import 'package:worki_ui/src/values/button_decoration.dart';

class CoordinatorSettingsPage extends StatefulWidget {
  Coordinator coordinator;
  CoordinatorSettingsPage({this.coordinator});

  @override
  _CoordinatorSettingsPageState createState() =>
      _CoordinatorSettingsPageState(coordinator: this.coordinator);
}

class _CoordinatorSettingsPageState extends State<CoordinatorSettingsPage> {
  Coordinator coordinator;
  _CoordinatorSettingsPageState({this.coordinator});
  FirebaseProvider firebaseProvider = new FirebaseProvider();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  CoordinatorProvider coordinatorProvider = new CoordinatorProvider();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        CoordinatorProfilePage(coordinator: coordinator),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.only(bottom: 80),
            child: _logOutButton()
          ),
        ),
      ],
    );
  }

  Widget _logOutButton(){
    return Container(
      decoration: ButtonDecoration.workiButton,
      width: MediaQuery.of(context).size.width*0.9,
      child: FlatButton(
        child: Text('Salir',
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            fontSize: 25,
            fontFamily: 'Lato',
            color: Colors.white
          ),
        ),
        onPressed: () async {
          firebaseProvider.signOut();
          var pr =
              new ProgressDialog(context, type: ProgressDialogType.Normal);
          pr.style(
            message: 'Cerrando sessión',
            borderRadius: 10.0,
            backgroundColor: Colors.white,
            progressWidget: CircularProgressIndicator(),
            elevation: 10.0,
            insetAnimCurve: Curves.easeInOut,
            progressTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 13.0,
                fontWeight: FontWeight.w400),
            messageTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 19.0,
                fontWeight: FontWeight.w600),
          );
          pr.show();
          String token;
          token = await _firebaseMessaging.getToken();
          if (coordinator.devices.contains(token)) {
            coordinator.devices.remove(token);
            await coordinatorProvider.updateCoordinator(coordinator);
          }
          Navigator.of(context).pushReplacementNamed('welcome');
        },
      ),
    );
  }
}
