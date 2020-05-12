import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:worki_ui/src/models/company_model.dart';
import 'package:worki_ui/src/models/coordinator_model.dart';
import 'package:worki_ui/src/models/user_model.dart';
import 'package:worki_ui/src/pages/Coordinator/coordinator_home_page.dart';
import 'package:worki_ui/src/pages/Coordinator/coordinator_settings_page.dart';
import 'package:worki_ui/src/pages/Shared/notification_page.dart';
import 'package:worki_ui/src/providers/coordinator_provider.dart';
import 'package:worki_ui/src/utils/search_delegate.dart';
import 'package:worki_ui/src/values/colors.dart';
import 'package:worki_ui/src/providers/firebase_provider.dart';

class CoordinatorMainPage extends StatefulWidget {
  @override
  _CoordinatorMainPageState createState() => _CoordinatorMainPageState();
}

class _CoordinatorMainPageState extends State<CoordinatorMainPage> {
  Coordinator coordinator;
  Company company;
  Map<String, dynamic> _arguments;
  GlobalKey _bottomNavigationKey = GlobalKey();
  int _page = 1;

  FirebaseProvider firebaseProvider = new FirebaseProvider();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  CoordinatorProvider coordinatorProvider = new CoordinatorProvider();

  @override
  Widget build(BuildContext context) {
    _arguments = ModalRoute.of(context).settings.arguments;
    coordinator = _arguments['coordinator'];
    company = _arguments['company'];
    List<Widget> _widgetOptions = <Widget>[
      NotificationPage(user: coordinator),
      CoordinatorHomePage(coordinator: coordinator, company: company),
      CoordinatorSettingsPage(
        coordinator: coordinator,
      )
    ];
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Image.network(
          'https://worki01.web.app/assets/Logo.png',
          height: 50,
        ),
        centerTitle: false,
        actions: <Widget>[
          Container(
            width: 100,
            //color: Colors.black,
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Empresa:',
                  style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
                ),
                Text(
                  company.name,
                  style: TextStyle(fontSize: 15, color: Colors.black),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, 'companyDetails',
                  arguments: {'company': company, 'user': coordinator});
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              width: 53,
              height: 50,
              decoration: BoxDecoration(
                  //border: Border.all(color: Colors.black,width: 1),
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 3,
                      color: Colors.black26,
                    )
                  ]),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  company.profilePic, //worker.profilePic,
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: _widgetOptions.elementAt(_page),
          ),
          _blackShadow(),
          Align(
            alignment: Alignment.bottomCenter,
            child: _navigationBar(),
          ),
        ],
      ),
    );
  }

  Widget _navigationBar() {
    return CurvedNavigationBar(
      key: _bottomNavigationKey,
      index: 1,
      height: 60.0,
      items: <Widget>[
        Icon(FontAwesome.comments, size: 30, color: AppColors.workiColor),
        Icon(Icons.home, size: 30, color: AppColors.workiColor),
        Icon(Icons.person, size: 30, color: AppColors.workiColor),
        //Icon(Icons.settings, size: 30, color: AppColors.workiColor),
      ],
      color: Colors.white,
      buttonBackgroundColor: Colors.white,
      backgroundColor: Colors.white10.withOpacity(0.001),
      animationCurve: Curves.easeInCubic,
      animationDuration: Duration(milliseconds: 600),
      onTap: (index) {
        setState(() {
          _page = index;
        });
      },
    );
  }

  Widget _blackShadow() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 90,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(0.4),
              Colors.black.withOpacity(0.2),
              Colors.black.withOpacity(0.1),
              Colors.black.withOpacity(0.05),
              Colors.black.withOpacity(0.02),
              Colors.black.withOpacity(0)
            ],
          ),
        ),
      ),
    );
  }
}
