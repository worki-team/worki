import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:worki_ui/src/models/administrator_model.dart';
import 'package:worki_ui/src/models/event_model.dart';
import 'package:worki_ui/src/providers/event_provider.dart';
import 'package:worki_ui/src/providers/job_provider.dart';
import 'package:worki_ui/src/utils/alert.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:worki_ui/src/values/values.dart';

class AdminEventCard extends StatefulWidget {
  Event event;
  Function() notifyParent;
  var user;
  AdminEventCard({@required this.event, this.notifyParent, @required this.user});

  @override
  _AdminEventCardState createState() => _AdminEventCardState(event: this.event, notifyParent: this.notifyParent, user: this.user);
}

class _AdminEventCardState extends State<AdminEventCard> {
  EventsProvider _eventsProvider = new EventsProvider();
  JobsProvider _jobProvider = JobsProvider();
  Event event;
  Function() notifyParent;
  var user;

  _AdminEventCardState({@required this.event, this.notifyParent, this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).pushNamed('event_details',arguments:{'event':event,'user':user});// {'event':event,'user':user});
      },
      child: Container(
        height: 250,
        width: MediaQuery.of(context).size.width*0.9,
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              color: Colors.black38,
              offset: Offset(3,3)
            )
          ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(right: 10),
                  height: 80,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomRight: Radius.circular(30)),
                    child: Image.network(event.eventPic, fit: BoxFit.cover),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    height: 35,
                    width: 110,
                    margin: EdgeInsets.all(15),
                    child: LiteRollingSwitch(
                      value: event.state,
                      textOn: 'Activo',
                      textOff: 'Inactivo',
                      iconOff: Icons.power_settings_new,
                      onChanged: (bool state) {
                        event.state = state;
                        _eventsProvider.updateEvent(event);
                        //this.notifyParent();
                      },
                    ),
                  ),
                ),
              ]
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(event.name, style: TextStyle(fontSize: 20,)),
                  IconButton(
                    icon: Icon(Icons.add, color: AppColors.workiColor), 
                    onPressed: (){
                      Navigator.of(context).pushNamed('add_job_page',arguments: event);
                    }
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:10),
              child:Text('Coordinador: ', overflow: TextOverflow.ellipsis,),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(FontAwesome5.calendar_check, color:AppColors.workiColor),
                      Text(event.getInitialDate()),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Icon(FontAwesome5.calendar_times, color:AppColors.workiColor),
                      Text(event.getFinalDate()),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            FutureBuilder(
              future: _jobProvider.getJobsByEvent(event.id),
              builder:(BuildContext context, AsyncSnapshot<List> snapshot){
                if(snapshot.hasData){
                  return Container(
                    height: 50,
                    child: ListView.builder(
                      shrinkWrap: false,

                      physics: ScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, i){
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: GestureDetector(
                            onTap: (){
                              Navigator.of(context).pushNamed('jobDetails', arguments: {'job':snapshot.data[i],'user':user});
                            },
                            child: Chip(
                              label: Text(snapshot.data[i].name, style: TextStyle(color: Colors.white)), 
                              backgroundColor: AppColors.workiColor, 
                              elevation: 2.0,
                            ),
                          ),
                        );
                      }
                    ),
                  );
                }else{
                  return Container();
                }
              }
            ),
          ],
        ),
      ),
    );
  }
}