import 'package:awesome_loader/awesome_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:worki_ui/src/models/company_model.dart';
import 'package:worki_ui/src/models/coordinator_model.dart';
import 'package:worki_ui/src/models/event_model.dart';
import 'package:worki_ui/src/models/job_model.dart';
import 'package:worki_ui/src/pages/Shared/chat_page.dart';
import 'package:worki_ui/src/providers/company_provider.dart';
import 'package:worki_ui/src/providers/event_provider.dart';
import 'package:worki_ui/src/providers/job_provider.dart';
import 'package:worki_ui/src/utils/shimmers/company_shimmer_widget.dart';
import 'package:worki_ui/src/utils/shimmers/job_card_shimmer_widget.dart';
import 'package:worki_ui/src/values/colors.dart';
import 'package:worki_ui/src/values/values.dart';
import 'package:worki_ui/src/widgets/job_card_widget.dart';
import 'package:worki_ui/src/widgets/user_small_card_widget.dart';

class EventDetails extends StatefulWidget {

  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {

  EventsProvider _eventsProvider = new EventsProvider();
  JobsProvider _jobsProvider = new JobsProvider();
  CompanyProvider companyProvider = new CompanyProvider();
  Map<String, dynamic> _arguments;
  EventsProvider eventsProvider = new EventsProvider();
  Event event;
  var user;
  var rol;
  @override
  Widget build(BuildContext context) {
    _arguments = ModalRoute.of(context).settings.arguments;
    event = _arguments['event'];
    user = _arguments['user'];
    rol = user.roles[0];
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[
          _createAppbar(event),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                height: 10.0,
              ),
              _companyCard(event,context),
              _eventTitle(event, context),
              SizedBox(
                height: 10.0,
              ),
              _coordinatorBuilder(),
              
              SizedBox(
                height: 10.0,
              ),
              _eventJobs(event),
              //_createWorkers(job)
            ]),
          )
        ],
      ),
    );
  }

  _createAppbar(Event event) {
    return SliverAppBar(
      elevation: 0.0,
      backgroundColor: Colors.white,
      expandedHeight: 250.0,
      floating: false,
      pinned: true,
      iconTheme: IconThemeData(color: AppColors.workiColor),
      actions: <Widget>[
        rol == 'ADMINISTRATOR' ?Container(
          width: 110,
          margin: EdgeInsets.only(bottom: 10,left: 10,right: 10,top: 10),
          child: LiteRollingSwitch(
            value: event.state,
            textOn: 'Activo',
            textOff: 'Inactivo',
            iconOff: Icons.power_settings_new,
            onChanged: (bool state) {
              event.state = state;
              _eventsProvider.updateEvent(event);
            },
          ),
        ): Container(),
      ],
      
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        collapseMode: CollapseMode.pin,
        title: Container(
          width: 220,
          child: Text(
            event.name,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black, fontSize: 16.0),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        background: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 10),
              width: MediaQuery.of(context).size.width,
              height: 220,
              color: Colors.white,
              child: ClipRRect(
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(40)),
                child: event.eventPic != null ? 
                  Hero(
                    tag:event.id,
                    child: Image.network(event.eventPic, fit: BoxFit.cover)
                  ) : Image.asset('assets/no-image.png'),
              ),
            ),
            
          ],
        ),
      ),
    );
  }

  Widget _companyCard(Event event, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: 130,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                blurRadius: 10,
                color: Colors.black38,
                offset: Offset(1.0, 1.0))
          ],
          color: Colors.white
        ),
        child: FutureBuilder(
          future: companyProvider.getCompanyById(event.companyId),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              Company company = snapshot.data;
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12,width: 1),
                        borderRadius: BorderRadius.circular(100)
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: company.profilePic != '' ?
                          Image.network(
                            company.profilePic,
                            fit: BoxFit.cover,
                          ) : Image.asset('assets/no-image.png', fit: BoxFit.cover,),
                      ),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          //color: Colors.black,
                          child: Text(
                            company.name,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: Text(
                            company.address,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontFamily: 'Lato', fontSize: 15),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                                                        IconButton(
                                icon: Icon(Icons.directions,
                                    color: AppColors.workiColor),
                                onPressed: () {
                                  Navigator.of(context).pushNamed(
                                        'location_page',
                                        arguments: {'latitude':company.latitude,'longitude':company.longitude});
                                })
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            } else {
              return Container(
                child: ProfileShimmer(),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _eventTitle(Event event, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              blurRadius: 10,
              color: Colors.black38,
              offset: Offset(1.0, 1.0))
        ],
        color: Colors.white
      ),
      margin:  EdgeInsets.all(10.0),
      padding: EdgeInsets.all(20.0),
      child: Row(
        children: <Widget>[
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.workiColor
                      ),
                      child: Icon(Icons.location_on, color: Colors.white, size: 18)
                    ),

                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      event.address,
                      style: TextStyle(fontSize: 18)
                    )
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: <Widget>[
                    Icon(FontAwesome5.calendar_check, color: AppColors.workiColor, size: 18),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      event.getInitialDate(),
                      style: TextStyle(fontSize: 18)
                    )
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: <Widget>[
                    Icon(FontAwesome5.calendar_times, color: AppColors.workiColor, size: 18),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      event.getFinalDate(),
                      style: TextStyle(fontSize: 18)
                    )
                  ],
                ), 
                SizedBox(
                  height: 10.0,
                ),
                _description(event),
              ],
            ),
          ),
          rol == 'ADMINISTRATOR' ? IconButton(
            icon: Icon(Icons.edit, color: AppColors.workiColor), 
            onPressed: (){
              Navigator.of(context).pushNamed('edit_event',arguments: event);
            }
          ) : Container(),
        ],
      )
    );
  }

  Widget _description(Event event) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10.0,
          ),
          Text(
            'Descripción del evento:',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            event.description,
            textAlign: TextAlign.justify,
          ),
        ],
      )
    );
  }

  Widget _eventJobs(Event event){
    print(event.id);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Text(
            'Trabajos', 
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              fontFamily: 'Lato'
            )
          ),
        ),
        SizedBox(height: 20,),
        rol == 'ADMINISTRATOR' ? Container(
          height: 30,
          margin: EdgeInsets.symmetric(horizontal: 10),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                blurRadius: 5,
                color: Colors.black38,
                offset: Offset(3.0,3.0)
              )
            ] ,
            gradient: Gradients.workiGradient
          ),
          child: FlatButton(
            onPressed: (){
              Navigator.of(context).pushNamed('add_job_page',arguments: event);
            }, 
            child: Icon(
              Icons.add,
              color: Colors.white
            )

          )
          
        ) : Container(),
        FutureBuilder(
          future: _jobsProvider.getJobsByEvent(event.id),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.hasData){
              List<Job> jobs = snapshot.data;
              return ListView.builder(
                itemCount: jobs.length,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, i){
                  return JobCardWidget(job: jobs[i],user: user,);
                }
              );
            }else{
              return JobCardShimmer();
            }
          },
        ),
        SizedBox(height: 60,),
      ],
    );
  }

  Widget _coordinatorBuilder(){
    return FutureBuilder(
      future: eventsProvider.getCoordinatorsByEvent(event.id),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        
        if(snapshot.hasData){
          List<Coordinator> coordinators = snapshot.data;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  coordinators.length == 1 ? 'Coordinador' : 'Coordinadores', 
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    fontFamily: 'Lato'
                  )
                ),
              ),
              SizedBox(height: 20,),
              Container(
                height: 120,
                child: ListView.builder(
                  padding: EdgeInsets.only(left: 15),
                  scrollDirection: Axis.horizontal,
                  physics: ScrollPhysics(),
                  itemCount: coordinators.length,
                  itemBuilder: (context, i){
                    return UserSmallCardWidget(user: coordinators[i]);
                  },
                ),
              ),
            ],
          );
        }else{
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  'Coordinador', 
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    fontFamily: 'Lato'
                  )
                ),
              ),
              SizedBox(height: 20,),
              Container(
                height: 120,
                child: ListView(
                  padding: EdgeInsets.only(left: 10),
                  scrollDirection: Axis.horizontal,
                  physics: ScrollPhysics(),
                  children: <Widget>[
                    for(int i=0; i<5; i++)
                    CompanyShimmer(),
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
