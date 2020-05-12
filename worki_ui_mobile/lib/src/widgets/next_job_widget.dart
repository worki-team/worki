import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:worki_ui/src/models/event_model.dart';
import 'package:worki_ui/src/models/job_model.dart';
import 'package:worki_ui/src/pages/Shared/chat_page.dart';
import 'package:worki_ui/src/providers/event_provider.dart';
import 'package:worki_ui/src/providers/firestore_provider.dart';
import 'package:worki_ui/src/values/values.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:worki_ui/src/widgets/qr_generator_widget.dart';

class NextJobWidget extends StatefulWidget {
  PanelController panelController;
  Job job;
  var user;
  NextJobWidget({this.panelController, this.job, this.user});

  @override
  _NextJobWidgetState createState() => _NextJobWidgetState(
      panelController: this.panelController, job: this.job, user: this.user);
}

class _NextJobWidgetState extends State<NextJobWidget> {
  PanelController panelController;
  Job job;
  var user;
  _NextJobWidgetState({this.panelController, this.job, this.user});
  FirestoreProvider firestoreProvider = new FirestoreProvider();
  EventsProvider eventsProvider = new EventsProvider();
  @override
  Widget build(BuildContext context) {
    print(user.toString());
    return Stack(alignment: Alignment.center, children: <Widget>[
      Container(
        height: 60,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 10),
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
          //padding: EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.message,
                          size: 25,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          firestoreProvider
                              .getChat(job.eventId)
                              .then((chatDoc) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                        chat: chatDoc[0].data,
                                        chatKey: chatDoc[0].documentID,
                                        user: user)));
                          });
                        }),
                    SizedBox(
                      width: 10,
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.directions,
                          size: 25,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          Event e =
                              await eventsProvider.getEventById(job.eventId);
                          Navigator.of(context)
                              .pushNamed('location_page', arguments: e);
                        }),
                  ],
                ),
              ),
              Container(
                height: 70,
                width: 70,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('jobDetails',
                      arguments: {'job': job, 'user': user});
                },
                child: Container(
                  //color:Colors.black,
                  width: MediaQuery.of(context).size.width * 0.32,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * 0.27,
                            child: Text(
                              job.name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width * 0.27,
                              child: Text(job.getInitialDate(),
                                  style: TextStyle(color: Colors.white)))
                        ],
                      ),
                      SizedBox(width: 3),
                      Icon(Icons.arrow_forward_ios,
                          size: 15, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      Container(
        height: 75,
        width: 75,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 3),
            borderRadius: BorderRadius.circular(50)),
        child: Material(
          borderRadius: BorderRadius.circular(50),
          elevation: 0.0,
          borderOnForeground: true,
          color: AppColors.workiColor,
          child: IconButton(
            onPressed: () {
              if (panelController != null) {
                panelController.animatePanelToPosition(0.65);
              }
            },
            icon: Icon(FontAwesome.qrcode, size: 40, color: Colors.white),
          ),
        ),
      ),
    ]);
  }
}
