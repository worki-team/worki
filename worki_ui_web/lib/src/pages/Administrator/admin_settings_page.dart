import 'package:flutter/material.dart';
import 'package:worki_ui/src/pages/Administrator/admin_manage_coordinator.dart';
import 'package:worki_ui/src/providers/firebase_provider.dart';
import 'package:worki_ui/src/values/button_decoration.dart';

class AdminSettingPage extends StatefulWidget {
  AdminSettingPage({Key key}) : super(key: key);
  @override
  _AdminSettingPageState createState() => _AdminSettingPageState();
}

class _AdminSettingPageState extends State<AdminSettingPage> {
  FirebaseProvider firebaseProvider = new FirebaseProvider();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height:30),
            Container(
              decoration: ButtonDecoration.workiButton,
              height: 60,
              width: 200,
              child: FlatButton(
                onPressed: () {
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
            SizedBox(height:30),
            Container(
              decoration: ButtonDecoration.workiButton,
              height: 60,
              width: 200,
              child: FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminManageCoordinatorPage()),
                  );
                },
                child: Text('Coordinador',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
