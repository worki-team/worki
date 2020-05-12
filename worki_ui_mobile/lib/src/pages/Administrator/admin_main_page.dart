import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:worki_ui/src/models/administrator_model.dart';
import 'package:worki_ui/src/models/company_model.dart';
import 'package:worki_ui/src/models/user_model.dart';
import 'package:worki_ui/src/pages/Administrator/admin_home_page.dart';
import 'package:worki_ui/src/pages/Administrator/admin_settings_page.dart';
import 'package:worki_ui/src/pages/Administrator/workers_page.dart';
import 'package:worki_ui/src/pages/Shared/notification_page.dart';
import 'package:worki_ui/src/values/colors.dart';
import 'package:worki_ui/src/providers/firebase_provider.dart';

class AdminMainPage extends StatefulWidget {
  @override
  _AdminMainPageState createState() => _AdminMainPageState();
}

class _AdminMainPageState extends State<AdminMainPage> {
  Map<String, dynamic> _arguments;
  Administrator admin;
  Company company;
  FirebaseProvider firebaseProvider = new FirebaseProvider();
  int _page = 1;
  GlobalKey _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    _arguments = ModalRoute.of(context).settings.arguments;
    admin = _arguments['admin'];
    company = _arguments['company'];
    User user = new User();
    user.id = admin.id;
    user.name = admin.name;
    user.profilePic = admin.profilePic;
    List<Widget> _widgetOptions = <Widget>[
      //AddEventPage(),
      //AddJobPage(),
      NotificationPage(user: user),
      AdminHomePage(admin: admin, company: company),
      WorkersPage(admin:admin,company:company),
      AdminSettingPage(admin:admin),
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Image.network(
          'https://worki01.web.app/assets/Logo.png',
          height: 50,
        ),
        centerTitle: false,
        actions: <Widget>[
          GestureDetector(
            onTap: (){
              Navigator.pushNamed(context, 'companyDetails',arguments: {'company':company,'user':admin});
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              width: 53,
              height: 50,
              decoration: BoxDecoration(
                  //border: Border.all(color: Colors.black,width: 1),
                  borderRadius: BorderRadius.circular(100)),
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
      body: Stack(children: [
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
      ]),
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

  Widget _navigationBar() {
    return CurvedNavigationBar(
      key: _bottomNavigationKey,
      index: 1,
      height: 60.0,
      items: <Widget>[
        Icon(FontAwesome.comments, size: 30, color: AppColors.workiColor),
        Icon(Icons.home, size: 30, color: AppColors.workiColor),
        Icon(Icons.search, size: 30, color: AppColors.workiColor),
        Icon(Icons.settings, size: 30, color: AppColors.workiColor),
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
}
