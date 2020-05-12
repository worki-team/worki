import 'package:awesome_loader/awesome_loader.dart';
import 'package:flutter/material.dart';
import 'package:worki_ui/src/models/company_model.dart';
import 'package:worki_ui/src/models/coordinator_model.dart';
import 'package:worki_ui/src/models/event_model.dart';
import 'package:worki_ui/src/models/job_model.dart';
import 'package:worki_ui/src/providers/event_provider.dart';
import 'package:worki_ui/src/providers/job_provider.dart';
import 'package:worki_ui/src/utils/shimmers/event_card_shimmer.dart';
import 'package:worki_ui/src/utils/shimmers/job_shimmer_widget.dart';
import 'package:worki_ui/src/values/values.dart';
import 'package:worki_ui/src/widgets/admin_event_card.dart';
import 'package:worki_ui/src/widgets/job_preview_widget.dart';

class CoordinatorHomePage extends StatefulWidget {
  Coordinator coordinator;
  Company company;
  CoordinatorHomePage({this.coordinator, this.company});

  @override
  _CoordinatorHomePageState createState() => _CoordinatorHomePageState(
      coordinator: this.coordinator, company: this.company);
}

class _CoordinatorHomePageState extends State<CoordinatorHomePage> {
  Coordinator coordinator;
  Company company;
  _CoordinatorHomePageState({this.coordinator, this.company});

  EventsProvider _eventsProvider = new EventsProvider();
  JobsProvider _jobProvider = new JobsProvider();
  List<Event> events;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(0, 50, 0, 200),
      children: <Widget>[
        
        _welcomeHeader(), 
        SizedBox(height: 30,),
        _jobs(),
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
                  'Hola ' + coordinator.name,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      fontFamily: 'Lato'),
                ),
                Text(
                  coordinator.roles[0],
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

  Widget _jobs(){
    return FutureBuilder(
      future: _jobProvider.getJobsByCoordinatorId(coordinator.id),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.hasData){
          List<Job> jobs = snapshot.data;
          if(jobs.length != 0){
            return Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('Trabajos asignados',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Lato')),
                    ],
                  ),
                ),
                Container(
                  height: 200,
                  child: ListView.builder(
                    physics: ScrollPhysics(),
                    itemCount: jobs.length,
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.only(left: 15),
                    itemBuilder: (context, i){
                      return JobPreviewWidget(job: jobs[i], user: coordinator);
                    }
                  ),
                ),
              ],
            );
          }else{
            return Container();
          }

        }else{
          return Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text('Trabajos asignados',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Lato')),
                  ],
                ),
              ),
              Container(
                height: 200,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: ScrollPhysics(),
                  padding: EdgeInsets.only(left: 15),
                  children: <Widget>[
                    for(int i=0; i<5; i++)
                    JobShimmerWidget(),
                  ],
                ),

              ),
            ],
          );
        }
      },
    );
  }

  Widget _events() {
    return FutureBuilder(
      future: _eventsProvider.getEventsByCoordinator(coordinator.id),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          events = snapshot.data;
          if(events.length != 0){
            return Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('Eventos asignados',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Lato')),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                coordinator.roles[0] != 'COORDINATOR'
                ? Container(
                    height: 30,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                        gradient: Gradients.workiGradient,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 3,
                              color: Colors.black38,
                              offset: Offset(3, 3))
                        ]),
                    child: FlatButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'add_event',
                            arguments: {'admin': coordinator, 'company': company});
                      },
                      child: Center(
                        child: Icon(Icons.add, color: Colors.white, size: 30),
                      ),
                    ),
                  )
                : Container(),
                Container(
                  child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.all(10),
                      physics: ScrollPhysics(),
                      itemCount: events.length,
                      itemBuilder: (context, i) {
                        Event e = events[i];

                        return Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: AdminEventCard(
                            event: e,
                            notifyParent: refresh,
                            user: coordinator
                          )
                        );
                      }),
                ),
              ],
            );

          }else{
             return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 300,
                    child: Image.asset(
                      'assets/chill_undraw.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Parece que aun no tienes ningún evento asignado ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
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
                    Text('Eventos asignados',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Lato')),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                child: ListView(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  children: <Widget>[
                    for(int i=0; i<3; i++)
                    EventCardShimmer(),
                  ],
                )
              ),
            ],
          );
        }
      },
    );
  }

  refresh() {
    setState(() {});
  }
}
