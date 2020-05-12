import 'dart:convert';

import 'package:awesome_loader/awesome_loader.dart';
import 'package:flutter/material.dart';
import 'package:worki_ui/src/models/administrator_model.dart';
import 'package:worki_ui/src/models/company_model.dart';
import 'package:worki_ui/src/models/coordinator_model.dart';
import 'package:worki_ui/src/models/event_model.dart';
import 'package:worki_ui/src/models/job_model.dart';
import 'package:worki_ui/src/models/user_model.dart';
import 'package:worki_ui/src/models/worker_model.dart';
import 'package:worki_ui/src/pages/Shared/notification_page.dart';
import 'package:worki_ui/src/providers/company_provider.dart';
import 'package:worki_ui/src/providers/firestore_provider.dart';
import 'package:worki_ui/src/values/button_decoration.dart';
import 'package:worki_ui/src/values/colors.dart';

class WorkerCardWidget extends StatelessWidget {
  final Worker worker;
  final user;

  WorkerCardWidget({@required this.worker, this.user});
  CompanyProvider companyProvider = new CompanyProvider();
  FirestoreProvider firestoreProvider = new FirestoreProvider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        elevation: 5.0,
        child: GestureDetector(
          child: Container(
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: <Widget>[
                  _backgroundPicture(context),
                  _blackShadow(),
                  //_topCardContent(company),
                  _bottomCardContent(context),
                ],
              )),
          onTap: () {
            Navigator.of(context)
                .pushNamed('profile_page', arguments: {'worker': worker,'user':user,'companyId':user.companyId});
          },
        ),
      ),
    );
  }

  Widget _backgroundPicture(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: worker.profilePic != '' && worker.profilePic != null
          ? FadeInImage(
              placeholder: AssetImage('assets/noprofilepic.png'),
              image: NetworkImage(worker.profilePic),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            )
          : Image.network(
              'https://image.shutterstock.com/image-vector/picture-vector-icon-no-image-260nw-1350441335.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
    );
  }

  Widget _blackShadow() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(0.2),
              Colors.black.withOpacity(0.1),
              Colors.black.withOpacity(0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topCardContent(Company company) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      company.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lato',
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(1.0, 1.0),
                            blurRadius: 2.0,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomCardContent(context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
          padding: EdgeInsets.only(bottom: 15, left: 15, right: 15),
          child: Column(mainAxisAlignment: MainAxisAlignment.end, children: <
              Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      worker.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lato',
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(1.0, 1.0),
                            blurRadius: 2.0,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      worker.email,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lato',
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(1.0, 1.0),
                            blurRadius: 2.0,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        Text(
                          worker.getRating().toString() == '0.0'
                              ? 'No ha sido calificado'
                              : worker.getRating().toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                          ),
                        ),
                        GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(20.0))
                                    ),
                                    content: Text(
                                        '¿Crear chat con ' + worker.name + '?'),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('Si'),
                                        onPressed: () async {
                                          List<User> userIds = new List<User>();

                                          User fireUserAdmin = new User();
                                          fireUserAdmin.id = user.id;
                                          fireUserAdmin.name = user.name;
                                          fireUserAdmin.profilePic =
                                              user.profilePic;
                                          fireUserAdmin.roles = user.roles;
                                          userIds.add(fireUserAdmin);

                                          User fireUserWorker = new User();
                                          fireUserWorker.id = worker.id;
                                          fireUserWorker.name = worker.name;
                                          fireUserWorker.profilePic =
                                              worker.profilePic;
                                          fireUserWorker.roles = worker.roles;
                                          userIds.add(worker);

                                          firestoreProvider
                                              .createChat(
                                                  worker.id + user.id,
                                                  'Chat: ' +
                                                      user.name +
                                                      "-" +
                                                      worker.name,
                                                  worker.profilePic,
                                                  userIds)
                                              .then((docRef) {
                                            var materialPageRoute;
                                            materialPageRoute =
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        new NotificationPage(
                                                            user: user));
                                            Navigator.push(
                                                context, materialPageRoute);
                                          });
                                        },
                                      ),
                                      FlatButton(
                                        child: Text('No'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                            child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 50),
                                child: Icon(
                                  Icons.chat,
                                  size: 30,
                                  color: Colors.white,
                                )))
                      ],
                    )
                  ],
                ),
                /*
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                for (var i = 0; i < job.functions.length; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Chip(
                        backgroundColor: Colors.white,
                        label: Text(job.functions[i])),
                  )
              ],
            ),
            */
              ],
            ),
          ])),
    );
  }
}
