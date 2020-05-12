import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:worki_ui/src/models/job_model.dart';
import 'package:worki_ui/src/models/worker_model.dart';
import 'package:worki_ui/src/providers/firebase_provider.dart';
import 'package:worki_ui/src/providers/job_provider.dart';
import 'package:worki_ui/src/providers/worker_provider.dart';
import 'package:worki_ui/src/values/colors.dart';
import 'package:worki_ui/src/values/values.dart';

class WorkerQR extends StatefulWidget {
  WorkerQR();
  @override
  _WorkerQRState createState() => _WorkerQRState();
}

class _WorkerQRState extends State<WorkerQR> {
  WorkerProvider workerProvider = new WorkerProvider();
  FirebaseProvider firebaseProvider = FirebaseProvider();
  JobsProvider jobsProvider = new JobsProvider();
  Worker worker;
  Job job;
  Map<String, dynamic> _arguments;
  var rol;
  bool isRegister = false;
  _WorkerQRState();

  @override
  Widget build(BuildContext context) {
    _arguments = ModalRoute.of(context).settings.arguments;
    worker = _arguments['worker'];
    job = _arguments['job'];
    isRegister = job.workersId.contains(worker.id);
    return Scaffold(
      appBar: _createAppbar(job),
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          //_register(),

          SizedBox(
            height: 10.0,
          ),
          _register(),
          _workerCard(worker, context),
          _workerTitle(worker, context),
          SizedBox(
            height: 10.0,
          )
        ],
      ),
      bottomNavigationBar: _bottomButtons(),
    );
  }

  _createAppbar(Job job) {
    return AppBar(
      title: Text(job.name,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0.0,
      iconTheme: IconThemeData(color: AppColors.workiColor),
    );
  }

  Widget _workerCard(Worker worker, BuildContext context) {
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
            color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12, width: 1),
                    borderRadius: BorderRadius.circular(100)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: worker.profilePic != ''
                      ? Image.network(
                          worker.profilePic,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/no-image.png',
                          fit: BoxFit.cover,
                        ),
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
                      worker.name + ' - '+worker.getAge().toString(),
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Text(
                      'ID: ' + worker.cardId.toString(),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontFamily: 'Lato', fontSize: 15),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _workerTitle(Worker worker, BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  blurRadius: 10,
                  color: Colors.black38,
                  offset: Offset(1.0, 1.0))
            ],
            color: Colors.white),
        margin: EdgeInsets.all(10.0),
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
                              color: AppColors.workiColor),
                          child:
                              Icon(Icons.group, color: Colors.white, size: 18)),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(worker.gender, style: TextStyle(fontSize: 18))
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                          height: 25,
                          width: 25,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.workiColor),
                          child:
                              Icon(Icons.phone, color: Colors.white, size: 18)),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(worker.phone.toString(),
                          style: TextStyle(fontSize: 18))
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.mail, color: AppColors.workiColor, size: 18),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(worker.email, style: TextStyle(fontSize: 18))
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _register() {
    if (isRegister == true) {
      return Container(
        height: 70,
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), 
          gradient: Gradients.greenGradient,
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              color: Colors.black45,

            )
          ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Usuario registrado previamente',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.white, ),
                  ),
                ),
                SizedBox(width: 10,),
                Icon(Icons.check, color: Colors.white),
              ],
            ),
            
            //_buttomAceptar(),
          ],
        ),
      );
    } else {
     return Container(
        height: 70,
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), 
          gradient: Gradients.redGradient,
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              color: Colors.black45,

            )
          ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Usuario no registrado',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.white, shadows: [Shadow(blurRadius: 1,color: Colors.black)]),
                  ),
                ),
                SizedBox(width: 10,),
                Icon(Icons.cancel, color: Colors.white),
              ],
            ),
            //_buttomAceptar(),
          ],
        ),
      );
    }
  }

  Widget _bottomButtons() {
    return Container(
      height: 80,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                height: 70,
                decoration: ButtonDecoration.workiButton,
                child: FlatButton(
                  child: Text('Aceptar', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                  onPressed: () async {
                    var pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
                    pr.style(
                      message: 'Guardando...',
                      borderRadius: 10.0,
                      backgroundColor: Colors.white,
                      progressWidget: CircularProgressIndicator(),
                      elevation: 10.0,
                      insetAnimCurve: Curves.easeInOut,
                      progressTextStyle: TextStyle(
                          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
                      messageTextStyle: TextStyle(
                          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
                    );
                    pr.show();
                    job.registeredIds.add(worker.id);
                    await jobsProvider.updateJob(job);
                    pr.hide();
                    Navigator.of(context).pop();

                  },
                ),
              ),
            ),
            SizedBox(width:10),
            Expanded(
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: Gradients.redGradient,
                ),
                child: FlatButton(
                  child: Text('Rechazar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _description(Worker worker) {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 10.0,
        ),
        Text(
          'Descripción del trabajador:',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10.0,
        ),
        Text(
          worker.description,
          textAlign: TextAlign.justify,
        ),
      ],
    ));
  }
}
