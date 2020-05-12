import 'package:flutter/material.dart';
import 'package:worki_ui/src/models/event_model.dart';
import 'package:worki_ui/src/models/job_model.dart';
import 'package:worki_ui/src/models/worker_model.dart';
import 'package:worki_ui/src/pages/Shared/chat_page.dart';
import 'package:worki_ui/src/pages/Worker/calendar_page.dart';
import 'package:worki_ui/src/providers/company_provider.dart';
import 'package:worki_ui/src/providers/event_provider.dart';
import 'package:worki_ui/src/providers/firestore_provider.dart';
import 'package:worki_ui/src/providers/job_provider.dart';
import 'package:worki_ui/src/providers/applicant_provider.dart';
import 'package:worki_ui/src/utils/shimmers/event_card_shimmer.dart';
import 'package:worki_ui/src/utils/shimmers/job_shimmer_widget.dart';
import 'package:worki_ui/src/values/values.dart';
import 'package:worki_ui/src/widgets/event_card_widget.dart';
import 'package:worki_ui/src/widgets/job_card_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:worki_ui/src/widgets/job_preview_widget.dart';
import 'package:worki_ui/src/widgets/next_job_widget.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:worki_ui/src/widgets/qr_generator_widget.dart';
import 'package:worki_ui/src/providers/push_notifications_provider.dart';
import 'package:flutter_icons/flutter_icons.dart';

class HomePage extends StatefulWidget {
  final Worker worker;
  const HomePage({@required this.worker});

  @override
  _HomePageState createState() => _HomePageState(worker: this.worker);
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final Worker worker;
  JobsProvider jobProvider = new JobsProvider();
  EventsProvider eventsProvider = new EventsProvider();
  ApplicantsProvider applicantProvider = new ApplicantsProvider();
  CompanyProvider companyProvider = new CompanyProvider();
  FirestoreProvider firestoreProvider = new FirestoreProvider();
  PanelController _panelController = new PanelController();
  bool _showCalendar = false;
  String _slideType = 'qrCode';
  _HomePageState({this.worker});
  PushNotificationProvider pushProvider = PushNotificationProvider();
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
    print(pushProvider.tok);
    return SlidingUpPanel(
      maxHeight: MediaQuery.of(context).size.height * 0.8,
      minHeight: 5,
      backdropEnabled: true,
      controller: _panelController,
      panelBuilder: (ScrollController sc) =>
          _slidingPanel(sc, _panelController),
      borderRadius: BorderRadius.circular(20),
      body: Stack(
        children: <Widget>[
          CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(
                    height: 30,
                  ),
                  _welcomeHeader(),
                  SizedBox(
                    height: 40,
                  ),
                  _yourJobs(),
                  SizedBox(
                    height: 30,
                  ),
                  _yourApplicantJobs(),
                  SizedBox(
                    height: 30,
                  ),
                  _recommendedJobs(),
                  SizedBox(
                    height: 200,
                  ),
                ]),
              )
            ],
          ),
        ],
      ),
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
            child: Text(
              'Hola ' + worker.name,
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  fontFamily: 'Lato'),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.network(
              worker.profilePic,
              height: 50,
              width: 50,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Widget _nextJob(Job job) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text('Próximo trabajo',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Lato')),
        ),
        SizedBox(
          height: 10,
        ),
        NextJobWidget(
          panelController: _panelController,
          job: job,
          user: worker,
        ),
      ],
    );
  }

  Widget _mainButtons() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: 100,
            width: MediaQuery.of(context).size.width / 2.3,
            decoration: BoxDecoration(
                color: Colors.black38, borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: Text('Trabajos'),
            ),
          ),
          Container(
            height: 100,
            width: MediaQuery.of(context).size.width / 2.3,
            decoration: BoxDecoration(
                color: Colors.black38, borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: Text('Empresas'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _yourJobs() {
    return Container(
      child: FutureBuilder(
        future: jobProvider.getJobsByWorkerId(worker.id),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasData) {
            List<Job> allJobs = snapshot.data;

            List<Job> nextJobs = new List<Job>();
            print('ACA');
            allJobs.forEach((j) {
                if(j.finalDate.isAfter(DateTime.now())){
                  print('ADD');
                  nextJobs.add(j);
                }
              }
            );
            if (nextJobs.length == 0) {
              if(allJobs.length != 0){
                return Column(
                  children: [
                    Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Container(
                        decoration: BoxDecoration(
                            gradient: Gradients.workiGradient,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 2.0),
                                blurRadius: 5.0,
                                color: Color.fromARGB(100, 0, 0, 0),
                              ),
                            ]),
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text('Tus trabajos',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Lato',
                                    color: Colors.white
                                  )
                                ),
                            Row(
                              children: <Widget>[
                                IconButton(
                                  onPressed: () {
                                    //Navigator.of(context).pushNamed('calendar_page');
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
                                    color: Colors.white
                                  ),
                                ),
                                SizedBox(width: 20),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        'calendar_jobs_page',
                                        arguments: {'user': worker, 'jobs': allJobs});
                                  },
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 20,
                                    color: Colors.white
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    _calendarPanel(allJobs),
                  ],
                );
              }else{
                return Container();
              }
            } else {
              return Column(
                children: <Widget>[
                  _nextJob(nextJobs[0]),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('Tus trabajos',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Lato')),
                        Row(
                          children: <Widget>[
                            IconButton(
                              onPressed: () {
                                //Navigator.of(context).pushNamed('calendar_page');
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
                            SizedBox(width: 20),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    'calendar_jobs_page',
                                    arguments: {'user': worker, 'jobs': allJobs});
                              },
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  _calendarPanel(allJobs),
                  Container(
                    height: 220,
                    child: ListView.builder(
                      itemCount: nextJobs.length,
                      physics: ScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, i) => _nextJobCard(nextJobs[i], i),
                    ),
                  ),
                ],
              );
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
                      Text('Próximo trabajo',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Lato')),
                    ],
                  ),
                ),
                Container(
                  height: 100,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('Tus trabajos',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Lato')),
                      Row(
                        children: <Widget>[
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.calendar_today,
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 20),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  height: 200.0,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      SizedBox(width: 15),
                      for (int i = 0; i < 4; i++) JobShimmerWidget(),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _nextJobCard(Job j, int i) {
    return Row(
      children: <Widget>[
        i == 0
            ? SizedBox(
                width: 15,
              )
            : Container(),
        Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed('jobDetails',
                    arguments: {'job': j, 'user': worker});
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                height: 140,
                width: 140,
                decoration: BoxDecoration(
                    color: Colors.white,
                    //gradient: Gradients.workiGradient,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 3.0,
                          color: Colors.black38,
                          offset: Offset(3.0, 3.0))
                    ]),
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: 140,
                      width: 140,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: j.jobPic == null || j.jobPic == ''
                            ? Image.network(
                                'https://image.shutterstock.com/image-vector/picture-vector-icon-no-image-260nw-1350441335.jpg',
                                fit: BoxFit.cover)
                            : Image.network(j.jobPic, fit: BoxFit.cover),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10),
                              topLeft: Radius.circular(10)),
                        ),
                        child: IconButton(
                          onPressed: () async {
                            firestoreProvider.getChat(j.eventId).then((chatDoc){
                              Navigator.push(context,MaterialPageRoute(builder: (context) => ChatPage(chat: chatDoc[0].data,chatKey: chatDoc[0].documentID,user: worker)));
                            });
                          },
                          icon: Icon(Icons.message, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              j.name,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Lato'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Icon(FontAwesome5.calendar_check, size:15),
                SizedBox(width:10),
                Text(
                  j.getInitialDate(),
                  overflow: TextOverflow.clip,
                ),
              ],
            ),
            SizedBox(height:10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Icon(FontAwesome5.calendar_times,size:15),
                SizedBox(width:10),
                Text(
                  j.getFinalDate(),
                  overflow: TextOverflow.clip,
                ),
              ],
            ),
          ],
        )
      ],
    );
  }

  Widget _yourApplicantJobs() {
    return FutureBuilder(
        future: applicantProvider.getWorkerApplicantJobs(worker.id),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          print(snapshot.error);
          if (snapshot.hasData) {
            List<Job> jobs = snapshot.data;
            if (jobs.length == 0) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Te invitamos a explorar los trabajos que tenemos para ti',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                  Container(
                    height: 300,
                    child: Image.asset(
                      'assets/webSearch_undraw.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              );
            } else {
              return Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('Trabajos por confirmar',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Lato')),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 200,
                    child: ListView.builder(
                      itemCount: jobs.length,
                      scrollDirection: Axis.horizontal,
                      //PageController(viewportFraction: 0.3, initialPage: 0),
                      itemBuilder: (context, i) =>
                          _applicantJobCard(jobs[i], i),
                    ),
                  ),
                ],
              );
            }
          } else {
            if (snapshot.connectionState == ConnectionState.done) {
              return Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/webSearch_undraw.png',
                      fit: BoxFit.cover,
                      height: 100,
                    ),
                  ],
                ),
              );
            } else {
              return Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('Trabajos por confirmar',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Lato')),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 200.0,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        SizedBox(width: 15),
                        for (int i = 0; i < 4; i++) JobShimmerWidget(),
                      ],
                    ),
                  ),
                ],
              );
            }
          }
        });
  }

  Widget _applicantJobCard(Job job, int i) {
    return Row(
      children: <Widget>[
        i == 0 ? SizedBox(width: 15) : Container(),
        JobPreviewWidget(job: job, user: worker),
      ],
    );
  }

  Widget _recommendedJobs() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text('Eventos recomendados',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lato')),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
              height: 230,
              width: MediaQuery.of(context).size.width,
              child: FutureBuilder(
                future: eventsProvider.getEvents(),
                builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                  if (snapshot.hasData) {
                    List<Event> events = snapshot.data;
                    return events.length > 0
                        ? CarouselSlider(
                            autoPlay: false,
                            autoPlayInterval: Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 800),
                            autoPlayCurve: Curves.decelerate,
                            viewportFraction: 0.9,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                            aspectRatio: 16 / 9,
                            items: events.map((i) {
                              return _recommendedJobCard(
                                i,
                              );
                            }).toList(),
                          )
                        : Container();
                  } else {
                    return EventCardShimmer();
                  }
                },
              )),
        ],
      ),
    );
  }

  Widget _recommendedJobCard(Event e) {
    return Column(
      children: <Widget>[
        EventCardWidget(
          e: e,
          user: worker,
        )
      ],
    );
  }

  Widget _slidingPanel(ScrollController sc, PanelController _panelController) {
    return FutureBuilder(
      future: jobProvider.getJobsByWorkerId(worker.id),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData && snapshot.data.length > 0) {
          Job job = snapshot.data[0];
          return QrGeneratorWidget(
              panelController: _panelController,
              sc: sc,
              user: worker,
              job: job,
              push: true);
        } else {
          return Container();
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
          child: CalendarPage(jobs: jobs, isExpanded: false, user: worker)),
    );
  }
}
