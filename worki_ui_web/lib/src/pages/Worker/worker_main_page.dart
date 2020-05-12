import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:worki_ui/src/models/user_model.dart';
import 'package:worki_ui/src/models/worker_model.dart';
import 'package:worki_ui/src/pages/Shared/notification_page.dart';
import 'package:worki_ui/src/pages/Worker/jobs_page.dart';
import 'package:worki_ui/src/pages/Worker/home_page.dart';
import 'package:worki_ui/src/pages/Worker/settings_page.dart';
import 'package:worki_ui/src/pages/Worker/worker_profile_page.dart';
import 'package:worki_ui/src/utils/search_delegate.dart';
import 'package:worki_ui/src/values/colors.dart';
import 'package:flutter_icons/flutter_icons.dart';

class WorkerMain extends StatefulWidget {
  

  @override
  _WorkerMainState createState() => _WorkerMainState();
}

class _WorkerMainState extends State<WorkerMain> {

  String userId; 
  Worker worker;
  GlobalKey _bottomNavigationKey = GlobalKey();
  int _page = 2;
  bool titulo = false;

  @override
  Widget build(BuildContext context) {
    worker = ModalRoute.of(context).settings.arguments;
    User user = new User();
    user.id = worker.id;
    user.name = worker.name;
    user.profilePic = worker.profilePic;
    user.roles = worker.roles;
    if(userId == null){
      userId = '';
    }

    List<Widget> _widgetOptions = <Widget> [
      NotificationPage(user:user),
      //Center(child: Text('Notifications',style:TextStyle(fontWeight: FontWeight.bold, fontSize: 30))),
      JobsPage(worker: worker),
      HomePage(worker: worker),
      WorkerProfilePage(worker:worker),
      SettingsPage(worker: worker),

    ];


    return Scaffold(  
      body: Stack(
        children:[
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
        ]
      ),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Image.network('https://worki01.web.app/assets/Logo.png',height: 50,),
        centerTitle: false,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            onPressed: (){
              showSearch(context: context, delegate: DataSearch(), );
            },
            icon: Icon(
              Icons.search, 
              color: AppColors.workiColor
            ),
          )
        ],
      ),
    );
  }

  Widget _navigationBar(){
    
    return CurvedNavigationBar(
      key: _bottomNavigationKey,
      index: 2,
      height: 60.0,
      items: <Widget>[
        Icon(FontAwesome.comments, size: 30,  color: AppColors.workiColor),
        Icon(FontAwesome.search, size: 30,  color: AppColors.workiColor),
        Icon(Icons.home, size: 30, color: AppColors.workiColor),
        Icon(Icons.person, size: 30,  color: AppColors.workiColor),
        Icon(Icons.settings, size: 30,  color: AppColors.workiColor),
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

  Widget _blackShadow(){
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