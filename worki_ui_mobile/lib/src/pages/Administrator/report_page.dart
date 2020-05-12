import 'dart:convert';

import 'package:awesome_loader/awesome_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:intl/intl.dart';
import 'package:worki_ui/src/models/administrator_model.dart';
import 'package:worki_ui/src/models/company_model.dart';
import 'package:worki_ui/src/models/event_model.dart';
import 'package:worki_ui/src/models/job_model.dart';
import 'package:worki_ui/src/providers/event_provider.dart';
import 'package:worki_ui/src/providers/job_provider.dart';
import 'package:worki_ui/src/values/values.dart';

class ReportPage extends StatefulWidget {
  Administrator admin;
  ReportPage({this.admin});

  @override
  _ReportPageState createState() => _ReportPageState(admin: this.admin);
}

class _ReportPageState extends State<ReportPage> with TickerProviderStateMixin {
  Administrator admin;
  Company company;
  _ReportPageState({this.admin});

  EventsProvider _eventsProvider = new EventsProvider();
  JobsProvider _jobsProvider = new JobsProvider();
  Map<String,dynamic> _arguments;
  AnimationController controller;
  bool _showTime = false;
  NumberFormat money = new NumberFormat.currency(decimalDigits: 0, symbol: ' ');
  DateTime initialDate = new DateTime.now();
  DateTime finalDate = new DateTime.now();
  List<String> months = ['Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(vsync: this,duration: Duration(seconds: 1));
    controller.reverse();
  }
  
  @override
  Widget build(BuildContext context) {
    _arguments = ModalRoute.of(context).settings.arguments;
    admin = _arguments['admin'];
    company = _arguments['company'];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Reportes',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold
          ),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.workiColor),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 20,),
          _buttonsBuilder(),
          _timeSelection(),
          _eventsBuilder(),
        ],
      ),
    );
  }



  Widget _eventsBuilder(){
    return FutureBuilder(
      future: _eventsProvider.getEventsByCompany(admin.companyId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.hasData){
          List<Event> events = snapshot.data;
          return Column(
            children: <Widget>[
              SizedBox(height: 40,),
              ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: events.length,
                itemBuilder: (context,i){
                  return FutureBuilder(
                    future: _jobsProvider.getJobsByEvent(events[i].id),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if(snapshot.hasData){
                        List<Job> jobs = snapshot.data;
                        return _eventTile(events[i], jobs);
                      }else{
                        return ListView(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          children: <Widget>[
                            for(int i=0; i<1; i++)
                            Container(
                              height: 140,
                              margin: EdgeInsets.symmetric(horizontal: 10, vertical:5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.black12
                              ),
                              child: ListTile(
                                leading: Container(
                                  height:50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(100)
                                  ),
                                ),
                                title: Row(
                                  children: <Widget>[
                                    Container(
                                      height: 20,
                                      width: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        color: Colors.black12
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle:  Row(
                                  children: <Widget>[
                                    Container(
                                      height: 20,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        color: Colors.black12
                                      ),
                                    ),
                                  ],
                                ),
                                trailing:  Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.black12
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  );
                }
              ),
            ],
          );
        }else{
          return Container(
            height: MediaQuery.of(context).size.height*0.7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AwesomeLoader(
                    loaderType: AwesomeLoader.AwesomeLoader3,
                    color: AppColors.workiColor),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buttonsBuilder(){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.45,
            height: 80,
            decoration: BoxDecoration(
                gradient: Gradients.blueGradient,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black38,
                      blurRadius: 2,
                      offset: Offset(3.0, 3.0))
                ]),
            child: FlatButton(
              onPressed: () {
                if(_showTime){
                  controller.reverse();
                }else{
                  controller.forward();
                }
                _showTime = !_showTime;
              },
              child: Center(
                child: Text('Generar Reporte',
                  textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.bold)),
              ),
            )
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.45,
            height: 80,
            decoration: BoxDecoration(
                gradient: Gradients.blueGradient,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black38,
                      blurRadius: 2,
                      offset: Offset(3.0, 3.0))
                ]),
            child: FlatButton(
              onPressed: () {
                Navigator.of(context).pushNamed('graphics_page',arguments: {'user':admin,'company':company});
              },
              child: Center(
                child: Text('Estadísticas',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.bold)),
              ),
            )
          ),
        ],
      ),
    );
  }

  Widget _timeSelection(){
    List<String> _timeSelection = ['Semana', 'Quincena', 'Mes'];
    return SizeTransition(
      sizeFactor: CurvedAnimation(
        parent: controller, 
        curve: Curves.fastOutSlowIn
      ),
      axisAlignment: 1.0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              color: Colors.white
            )
          ],
          color: Colors.white
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            for(int i=0; i<_timeSelection.length; i++)
            Container(
              width: 110,
              height: 40,
              margin: EdgeInsets.symmetric(vertical:5),
              decoration: ButtonDecoration.workiButton,
              child: FlatButton(
                onPressed: () async {
                  
                  if(_timeSelection[i] == 'Semana'){
                    initialDate = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      initialDate: initialDate ?? DateTime.now(),
                      lastDate: DateTime.now());
                    finalDate = initialDate.add(Duration(days: 7));
                    print(company.toJson().toString());
                    print(initialDate);
                    print(finalDate);
                    Navigator.of(context).pushNamed('consolidated_page',arguments: {
                      'company':company,'initialDate':initialDate,'finalDate':finalDate, 'timeType':'Semana'});
                  }
                  if(_timeSelection[i] == 'Quincena'){
                    initialDate = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      initialDate: initialDate ?? DateTime.now(),
                      lastDate: DateTime.now());
                  
                    finalDate = initialDate.add(Duration(days: 15));
                    Navigator.of(context).pushNamed('consolidated_page',arguments: {
                      'company':company,'initialDate':initialDate,'finalDate':finalDate, 'timeType':'Quincena'});
                  }
                  if(_timeSelection[i] == 'Mes'){
                    print('MES');
                    await showPickerDate(context);
                    finalDate = new DateTime(initialDate.year, initialDate.month+1,1);
                    Navigator.of(context).pushNamed('consolidated_page',arguments: {
                      'company':company,'initialDate':initialDate,'finalDate':finalDate, 'timeType':'Mes de '+months[initialDate.month-1]});
                  }
                  if(_timeSelection[i] == 'Otro'){
                    initialDate = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      initialDate: initialDate ?? DateTime.now(),
                      lastDate: DateTime.now());
                    finalDate = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      initialDate: finalDate ?? DateTime.now(),
                      lastDate: DateTime.now());
                    Navigator.of(context).pushNamed('consolidated_page',arguments: {
                      'company':company,'initialDate':initialDate,'finalDate':finalDate, 'timeType':'Otro'});
                  }

                }, 
                child: Text(_timeSelection[i], style: TextStyle(
                  color: Colors.white
                )),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _eventTile(Event e, List<Job> jobs){
    double totalPayment = 0;
    jobs.forEach((j){
      totalPayment = totalPayment + (j.salary*j.registeredIds.length);
    });
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical:5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: Colors.black38
          )
        ],
        color: Colors.white
      ),
      child: ExpansionTile(
        title: Text(
          e.name,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height:10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(Icons.attach_money, color: AppColors.workiColor),
                    Text(money.format(totalPayment.toInt())),
                  ],
                ),
              ],
            ),
            SizedBox(height:5),
            Text(
              e.getInitialDate() + ' - ' + e.getFinalDate(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width*0.5,
                  height: 30,
                  margin: EdgeInsets.symmetric(vertical:8),
                  decoration: ButtonDecoration.workiButton,
                  child: FlatButton(
                    onPressed: (){
                      Navigator.of(context).pushNamed('consolidated_page',arguments: {'event':e});
                    }, 
                    child: Text('Reporte', style: TextStyle(
                      color: Colors.white
                    )),
                  ),
                ),
              ],
            )
          ],
        ),
        leading: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                blurRadius: 5,
                color: Colors.black38
              )
            ]
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child:e.eventPic != null && e.eventPic != '' 
            ? Image.network(e.eventPic, fit: BoxFit.cover) 
            : Image.asset('assets/no-image.png',fit: BoxFit.cover) 
          ),
        ),
        children: <Widget>[
          ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: jobs.length,
            itemBuilder: (context,i){
              return _jobTile(jobs[i]);
            }
          ),
        ],
      ),
    );
  }

  Widget _jobTile(Job j){
    double payment = j.salary*j.registeredIds.length;
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: ListTile(
        title: Text(
          j.name
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(Icons.attach_money),
                Text(money.format(payment.toInt())),
              ],
            ),
            FlatButton(
              padding: EdgeInsets.all(0.0),
              child: Text(
                'Reporte '+j.name,
                style: TextStyle(
                  decoration: TextDecoration.underline
                ),
              ),
              onPressed: (){
                Navigator.of(context).pushNamed('consolidated_page',arguments: {'job':j});
              },
            ),
          ],
        ),
        trailing: Container(
          alignment: Alignment.center,
          width: 50,
          child: Row(
            children: <Widget>[
              Icon(Icons.person),
              Text(
                j.registeredIds.length.toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          
        ),
        leading: Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                blurRadius: 5,
                color: Colors.black38
              )
            ]
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: j.jobPic != null && j.jobPic != '' 
            ? Image.network(j.jobPic, fit: BoxFit.cover) 
            : Image.asset('assets/no-image.png',fit: BoxFit.cover) 
          ),
        ),
      ),
    );
  }

  showPickerDate(BuildContext context) {
    return new Picker(
        hideHeader: true,
        adapter: new DateTimePickerAdapter(
          customColumnType: [1, 0],
          yearEnd: DateTime.now().year,
          yearBegin: 2018,

        ),
        title: new Text("Seleccione el Mes y Año"),
        selectedTextStyle: TextStyle(color: Colors.black),
        onConfirm: (Picker picker, List value) {
          int year = (picker.adapter as DateTimePickerAdapter).value.year;
          int month = (picker.adapter as DateTimePickerAdapter).value.month;
          initialDate = new DateTime(year,month,1);
        }
    ).showDialog(context);
  }

}