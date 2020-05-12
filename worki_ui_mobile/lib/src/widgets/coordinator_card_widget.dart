import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:worki_ui/src/models/administrator_model.dart';
import 'package:worki_ui/src/models/coordinator_model.dart';
import 'package:worki_ui/src/providers/coordinator_provider.dart';
import 'package:worki_ui/src/providers/firebase_provider.dart';

class CoordinatorCardWidget extends StatefulWidget {
  Color color;
  Coordinator coordinator;
  Administrator admin;
  Function() notifyParent;
  CoordinatorCardWidget({this.coordinator, this.color, this.notifyParent, this.admin});

  @override
  _CoordinatorCardWidgetState createState() => new _CoordinatorCardWidgetState(
      coordinator: this.coordinator,
      color: this.color,
      notifyParent: this.notifyParent,
      admin: this.admin);
}

class _CoordinatorCardWidgetState extends State<CoordinatorCardWidget> {
  Color color;
  Coordinator coordinator;
  Function() notifyParent;
  Administrator admin;
  _CoordinatorCardWidgetState(
      {this.coordinator, this.color, this.notifyParent, this.admin});
  CoordinatorProvider coordinatorProvider = new CoordinatorProvider();
  FirebaseProvider firebaseProvider = new FirebaseProvider();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(20), topRight: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            color: Colors.black26,
            offset: Offset(3.0, 3.0)
          )
        ],
        color: Colors.white
      ),
      child: Row(
        children: <Widget>[
          Container(width: 10.0, height: 210.0, color: widget.color),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    coordinator.name,
                    style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      coordinator.phone.toString(),
                      style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      coordinator.email,
                      style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('coordinator_profile', arguments: {'coordinator': coordinator});
                        },
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          // Replace with a Row for horizontal icon + text
                          children: <Widget>[
                            Icon(Icons.edit),
                            Text("Editar"),
                          ],
                        ),
                      ),
                      FlatButton(
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(20.0))
                                  ),
                                  title: Text(
                                      '¿Está seguro de borrar este coordinador?'),
                                  actions: <Widget>[
                                    FlatButton(
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                          var pr = ProgressDialog(context,
                                              type: ProgressDialogType.Normal);
                                          pr.style(
                                            message: 'Eliminado Coordinador',
                                            borderRadius: 10.0,
                                            backgroundColor: Colors.white,
                                            progressWidget:
                                                CircularProgressIndicator(),
                                            elevation: 10.0,
                                            insetAnimCurve: Curves.easeInOut,
                                            progressTextStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.w400),
                                            messageTextStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: 19.0,
                                                fontWeight: FontWeight.w600),
                                          );
                                          pr.show();
                                          print('BORRAR DE FIREBASE');
                                          await firebaseProvider.signinWithEmail(coordinator.email, coordinator.password).then((user){
                                            firebaseProvider.deleteCurrentUser();
                                          });
                                          print('INICIO DE SESIÓN');
                                          print(admin.email+' '+admin.password);
                                          firebaseProvider.signinWithEmail(admin.email, admin.password).then((value) async {
                                            await coordinatorProvider.deleteCoordinator(
                                              coordinator.id
                                            );
                                            setState(() {  
                                            });
                                            notifyParent();
                                            pr.hide();
                                          });
                                        },
                                        child: Text('Si')),
                                    FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('No')),
                                  ],
                                );
                              });
                        },
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          // Replace with a Row for horizontal icon + text
                          children: <Widget>[
                            Icon(Icons.delete, color: Colors.red),
                            Text("Eliminar", style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          new Container(
            height: 150.0,
            width: 150.0,
            color: Colors.transparent,
            child: Stack(
              children: <Widget>[
                new Transform.translate(
                  offset: new Offset(50.0, 0.0),
                  child: new Container(
                    height: 500.0,
                    width: 500.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.color,
                    ),
                  ),
                ),
                new Transform.translate(
                  offset: Offset(10.0, 20.0),
                  child: new Card(
                    elevation: 40.0,
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    child: new Container(
                      height: 120.0,
                      width: 120.0,
                      decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.white,
                          border: Border.all(
                            width: 10.0,
                            color: Colors.white,
                            style: BorderStyle.solid,
                          ),
                          image: DecorationImage(
                            image: coordinator.profilePic != ''
                                ? NetworkImage(coordinator.profilePic)
                                : AssetImage('assets/noprofilepic.png'),
                          )),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
