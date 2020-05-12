import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:worki_ui/src/models/administrator_model.dart';
import 'package:worki_ui/src/models/event_model.dart';
import 'package:worki_ui/src/models/job_model.dart';
import 'package:worki_ui/src/providers/event_provider.dart';
import 'package:worki_ui/src/providers/job_provider.dart';
import 'package:worki_ui/src/utils/alert.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:worki_ui/src/values/values.dart';
import 'package:worki_ui/src/widgets/job_preview_widget.dart';

class AdminEventCard extends StatefulWidget {
  Event event;
  Function() notifyParent;
  var user;
  AdminEventCard(
      {@required this.event, this.notifyParent, @required this.user});

  @override
  _AdminEventCardState createState() => _AdminEventCardState(
      event: this.event, notifyParent: this.notifyParent, user: this.user);
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
      onTap: () {
        Navigator.of(context).pushNamed('event_details', arguments: {
          'event': event,
          'user': user
        }); // {'event':event,'user':user});
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  blurRadius: 4, color: Colors.black38, offset: Offset(3, 3))
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(right: 10),
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomRight: Radius.circular(30)),
                  child: event.eventPic != null && event.eventPic != ''
                      ? Image.network(event.eventPic, fit: BoxFit.cover)
                      : Image.asset('assets/no-image.png', fit: BoxFit.cover),
                ),
              ),
              user.roles[0] == 'ADMINISTRATOR'
                  ? Align(
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
                    )
                  : Container(),
            ]),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(event.name,
                      style: TextStyle(
                        fontSize: 20,
                      )),
                  user.roles[0] == 'ADMINISTRATOR'
                      ? IconButton(
                          icon: Icon(Icons.add, color: AppColors.workiColor),
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed('add_job_page', arguments: event);
                          })
                      : Container(),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(FontAwesome5.calendar_check,
                          color: AppColors.workiColor),
                      Text(event.getInitialDate()),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Icon(FontAwesome5.calendar_times,
                          color: AppColors.workiColor),
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
                builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                  if (snapshot.hasData) {
                    List<Job> jobs = snapshot.data;
                    return Container(
                      height: jobs.length != 0 ? 120 : 0,
                      child: ListView.builder(
                          padding: EdgeInsets.only(left: 10),
                          shrinkWrap: false,
                          physics: ScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, i) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed('jobDetails',
                                    arguments: {
                                      'job': jobs[i],
                                      'user': user
                                    });
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(height: 10),
                                    Container(
                                      height: 80,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 5,
                                            color: Colors.black38
                                          )
                                        ]
                                      ),
                                      child: jobs[i].jobPic != null && jobs[i].jobPic != ''
                                        ?ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Image.network(jobs[i].jobPic, fit: BoxFit.cover)
                                        )
                                        :ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Image.asset('assets/no-image.png', fit: BoxFit.cover)
                                        ),
                                    ),
                                    SizedBox(height: 5,),
                                    Text(
                                      jobs[i].name,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                                
                              ),
                             
                            );
                          }),
                    );
                  } else {
                    return Container();
                  }
                }),
          ],
        ),
      ),
    );
  }
}
