import 'package:flutter/material.dart';
import 'package:worki_ui/src/models/coordinator_model.dart';
import 'package:worki_ui/src/utils/search_delegate.dart';
import 'package:worki_ui/src/values/colors.dart';
import 'package:worki_ui/src/providers/firebase_provider.dart';

class CoordinatorMainPage extends StatefulWidget {
  @override
  _CoordinatorMainPageState createState() => _CoordinatorMainPageState();
}

class _CoordinatorMainPageState extends State<CoordinatorMainPage> {
  Coordinator coordinator;

  FirebaseProvider firebaseProvider = new FirebaseProvider();
  @override
  Widget build(BuildContext context) {
    coordinator = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        elevation: 5.0,
        backgroundColor: Colors.white,
        title: Image.network(
          'https://worki01.web.app/assets/Logo.png',
          height: 50,
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.menu, color: AppColors.workiColor),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: DataSearch(),
              );
            },
            icon: Icon(Icons.search, color: AppColors.workiColor),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Text('Coordinador,' + coordinator.name),
          RaisedButton(
            onPressed: () {
              firebaseProvider.signOut();

              Navigator.of(context).pushReplacementNamed('/');
            },
            child: Text('Sign Out',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
          ),
        ],
      ),
    );
  }
}
