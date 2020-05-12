import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:worki_ui/src/models/job_model.dart';
import 'package:worki_ui/src/models/worker_model.dart';
import 'package:worki_ui/src/providers/applicant_provider.dart';
import 'package:worki_ui/src/providers/job_provider.dart';
import 'package:worki_ui/src/values/values.dart';

class WorkersListPage extends StatefulWidget {
  WorkersListPage({Key key}) : super(key: key);

  @override
  _WorkersListPageState createState() => _WorkersListPageState();
}

class _WorkersListPageState extends State<WorkersListPage> {
  List<Worker> _workers;
  Job _job;
  Map<String,dynamic> _arguments;
  JobsProvider jobsProvider = new JobsProvider();
  ApplicantsProvider applicantProvider = new ApplicantsProvider();


  @override
  Widget build(BuildContext context) {
    _arguments = ModalRoute.of(context).settings.arguments;
    _workers = _arguments['workers'];
    _job = _arguments['job'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text('Trabajadores', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: AppColors.workiColor
        ),
      ),
      body: ListView.builder(
        itemCount: _workers.length,
        physics: ScrollPhysics(),
        key: Key('list'),
        itemBuilder: (context, i){
          String age = _workers[i].age == null ? _workers[i].getAge().toString() : ' ';
          String cardId = _workers[i].cardId == null ? _workers[i].cardId.toString() : ' ';
          String subtitle = 'Edad: '+age+' - ID: '+cardId;
          var pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
          pr.style(
            message: 'Aplicando al trabajo',
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
          
          return ListTile(
            title: Text(_workers[i].name),
            subtitle: Text(subtitle),
            leading: Container(
              height: 50,
              width: 50,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(_workers[i].profilePic, fit: BoxFit.cover)
              ),
            ),
            trailing: IconButton(
              icon: Icon(FontAwesome5.trash_alt, color: Colors.red), 
              onPressed: (){
                showDialog(
                  context: context,
                  builder: (BuildContext context){
                    return AlertDialog(
                      content: Text('Desea eliminar definitivamente a este trabajador o desea dejarlo en la lista de candidatos:'),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('Lista de espera'),
                          onPressed: () async {
                            Navigator.of(context).pop();
                            pr.show();
                            await applicantProvider.addWorkerToApplicant(_workers[i].id, _job.id);
                            _job.workersId.remove(_workers[i].id);
                            await jobsProvider.updateJob(_job);
                            _workers.remove(_workers[i]);
                            pr.hide();
                            setState(() {});
                          }, 
                        ),
                        FlatButton(
                          child: Text('Eliminar'),
                          onPressed: () async {
                            Navigator.of(context).pop();
                            pr.show();
                            _job.workersId.remove(_workers[i].id);
                            await jobsProvider.updateJob(_job);
                            _workers.remove(_workers[i]);
                            pr.hide();
                            setState(() {});
                          }, 
                        ),
                        FlatButton(
                          child: Text('Cancelar'),
                          onPressed: (){
                            Navigator.of(context).pop();
                          }, 
                        )
                      ],
                    );
                  }
                );
              
              }
            
            ),

          );
        }
      ),
    );
  }
}