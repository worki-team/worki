import 'package:awesome_loader/awesome_loader.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:worki_ui/src/models/administrator_model.dart';
import 'package:worki_ui/src/models/company_model.dart';
import 'package:worki_ui/src/models/event_model.dart';
import 'package:worki_ui/src/models/job_model.dart';
import 'package:worki_ui/src/models/user_model.dart';
import 'package:worki_ui/src/pages/Worker/calendar_page.dart';
import 'package:worki_ui/src/providers/administrator_provider.dart';
import 'package:worki_ui/src/providers/company_provider.dart';
import 'package:worki_ui/src/providers/event_provider.dart';
import 'package:worki_ui/src/providers/firebase_provider.dart';
import 'package:worki_ui/src/providers/job_provider.dart';
import 'package:worki_ui/src/utils/alert.dart';
import 'package:worki_ui/src/utils/shimmers/job_shimmer_widget.dart';
import 'package:worki_ui/src/values/colors.dart';
import 'package:worki_ui/src/values/values.dart';
import 'package:worki_ui/src/widgets/admin_event_card.dart';
import 'package:worki_ui/src/widgets/job_preview_widget.dart';
import 'package:worki_ui/src/providers/push_notifications_provider.dart';

class AdminHomePage extends StatefulWidget {
  Administrator admin;
  Company company;
  AdminHomePage({@required this.admin, @required this.company});

  @override
  _AdminHomePageState createState() =>
      _AdminHomePageState(admin: this.admin, company: this.company);
}

class _AdminHomePageState extends State<AdminHomePage> with TickerProviderStateMixin {
  Administrator admin;
  Company company;
  _AdminHomePageState({this.admin, this.company});

  EventsProvider _eventsProvider = new EventsProvider();
  CompanyProvider companyProvider = new CompanyProvider();
  JobsProvider jobsProvider = new JobsProvider();
  //AdministratorProvider administratorProvider = new AdministratorProvider();
  //FirebaseProvider firebaseProvider = new FirebaseProvider();
  PushNotificationProvider pushProvider = new PushNotificationProvider();
  bool _showCalendar = false;
  List<Event> events;

  AnimationController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(vsync: this,duration: Duration(seconds: 1));
    controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    
    return ListView(
      padding: EdgeInsets.fromLTRB(0, 50, 0, 200),
      children: <Widget>[
        _welcomeHeader(),
        SizedBox(
          height: 40,
        ),
        _mainButtons(),
        SizedBox(
          height: 40,
        ),
        _jobs(),
        //_statistics(),
        _events(),
      ],
    );
  }

  Widget _welcomeHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width / 1.3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Hola ' + admin.name,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      fontFamily: 'Lato'),
                ),
                Text(
                  admin.roles[0],
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      fontFamily: 'Lato'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _mainButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: 80,
                  decoration: BoxDecoration(
                      gradient: Gradients.blueGradient,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black38,
                            blurRadius: 2,
                            offset: Offset(3.0, 3.0))
                      ]),
                  child: FlatButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('events_page',
                          arguments: {'admin': admin, 'company': company});
                    },
                    child: Center(
                      child: Text('Eventos',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.bold)),
                    ),
                  )),
              Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: 80,
                  decoration: BoxDecoration(
                      gradient: Gradients.blueGradient,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black38,
                            blurRadius: 2,
                            offset: Offset(3.0, 3.0))
                      ]),
                  child: FlatButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('admin_coordinator_page',
                          arguments: {'admin': admin});
                    },
                    child: Center(
                      child: Text('Coordinadores',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.bold)),
                    ),
                  )),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              width: MediaQuery.of(context).size.width ,
              height: 80,
              decoration: BoxDecoration(
                  gradient: Gradients.blueGradient,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black38,
                        blurRadius: 2,
                        offset: Offset(3.0, 3.0))
                  ]),
              child: FlatButton(
                onPressed: () {
                   Navigator.of(context).pushNamed('report_page', arguments: {'admin':admin, 'company':company});
                },
                child: Center(
                  child: Text('Reportes',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold)),
                ),
              )),
        ],
      ),
    );
  }

  Widget _events() {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('Tus eventos',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Lato')),
              Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('events_page',
                          arguments: {'admin': admin, 'company': company});
                    },
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        SizedBox(height: 10),
        Container(
          height: 30,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(horizontal: 20.0),
          decoration: BoxDecoration(
              gradient: Gradients.workiGradient,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    blurRadius: 3, color: Colors.black38, offset: Offset(3, 3))
              ]),
          child: FlatButton(
            onPressed: () {
              Navigator.pushNamed(context, 'add_event',
                  arguments: {'admin': admin, 'company': company});
            },
            child: Center(
              child: Icon(Icons.add, color: Colors.white, size: 30),
            ),
          ),
        ),
        FutureBuilder(
          future: _eventsProvider.getEventsByCompany(company.id),
          builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            if (snapshot.hasData) {
              events = snapshot.data;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  //height: 280,
                  child: ListView.builder(
                      shrinkWrap: true,
                      //scrollDirection: Axis.horizontal,
                      physics: ScrollPhysics(),
                      itemCount: events.length,
                      itemBuilder: (context, i) {
                        Event e = events[i];

                        return Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: AdminEventCard(
                                event: e, notifyParent: refresh, user: admin));
                      }),
                ),
              );
            } else {
              return Container(
                  height: 400.0,
                  child: Center(
                    child: AwesomeLoader(
                      loaderType: AwesomeLoader.AwesomeLoader4,
                      color: AppColors.workiColor,
                    ),
                  ));
            }
          },
        ),
      ],
    );
  }

  refresh() {
    setState(() {});
  }

  Widget _statistics() {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('Estadísticas',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Lato')),
              Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      //Navigator.of(context).pushNamed('events_page',arguments: {'admin':admin,'company':company});
                    },
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _jobs() {
    return FutureBuilder(
      future: jobsProvider.getJobsByCompany(company.id),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<Job> jobs = snapshot.data;
          if (jobs.length != 0) {
            return Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('Próximos Trabajos',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Lato')),
                      Row(
                        children: <Widget>[
                          IconButton(
                            onPressed: () {
                              if(_showCalendar){
                                controller.reverse();
                              }else{
                                controller.forward();
                              }
                              _showCalendar = !_showCalendar;
                              
                            },
                            icon: Icon(
                              Icons.calendar_today,
                              size: 20,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed('calendar_jobs_page', arguments: {'jobs':jobs, 'user': admin});
                            },
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              size: 20,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                _calendarPanel(jobs),
                Container(
                  height: 210,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: ScrollPhysics(),
                      itemCount: jobs.length,
                      itemBuilder: (context, i) {
                        return Row(
                          children: <Widget>[
                            i == 0
                                ? SizedBox(
                                    width: 20,
                                  )
                                : Container(),
                            JobPreviewWidget(job: jobs[i], user: admin),
                          ],
                        );
                      }),
                ),
              ],
            );
          } else {
            return Text('');
          }
        } else {
          return Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text('Próximos Trabajos',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Lato')),
                    Row(
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            //Navigator.of(context).pushNamed('events_page',arguments: {'admin':admin,'company':company});
                          },
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                height: 210,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(left: 20),
                  physics: ScrollPhysics(),
                  children: <Widget>[
                    for (int i = 0; i < 4; i++) JobShimmerWidget(),
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _calendarPanel(List<Job> jobs) {
    
    return SizeTransition(
      sizeFactor: CurvedAnimation(
        parent: controller, 
        curve: Curves.fastOutSlowIn
      ),
      axisAlignment: 1.0,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black38)]),
        child: CalendarPage(jobs: jobs, isExpanded: false, user: admin)),
    );
  }
}
