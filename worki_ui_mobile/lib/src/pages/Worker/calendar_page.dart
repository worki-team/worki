import 'package:flutter/material.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
import 'package:intl/intl.dart';
import 'package:worki_ui/src/models/job_model.dart';
import 'package:worki_ui/src/values/values.dart';

class CalendarPage extends StatefulWidget {
  final List<Job> jobs;
  final bool isExpanded;
  final user;
  CalendarPage({this.jobs,this.isExpanded, this.user});

  @override
  _CalendarPageState createState() => _CalendarPageState(jobs: this.jobs,  isExpanded: this.isExpanded, user: this.user);
}

class _CalendarPageState extends State<CalendarPage> {
  List<Job> jobs;
  bool isExpanded;
  var user;
  _CalendarPageState({this.jobs, this.isExpanded, this.user});

  List _selectedEvents;
  DateTime _selectedDay;
  Map _events = {};

  @override
  void initState() {
    super.initState();
    _selectedEvents = _events[_selectedDay] ?? [];
  }

  
  @override
  Widget build(BuildContext context) {
    jobs.forEach((j){
      String aux = DateFormat('yyyy-MM-dd').format(j.initialDate);
      var isDone = DateTime.now().isAfter(j.finalDate);
      _events[DateTime.parse(aux)]=[{'name': j.id+'\\'+j.name+'\\'+j.jobPic+'\\'+j.getInitialDate(), 'isDone': isDone}];
    }); 
    print(_events);
    return  Column(
      children: <Widget>[
        Calendar(
          events: _events,
          onRangeSelected: (range) =>
              print("Range is ${range.from}, ${range.to}"),
          onDateSelected: (date) => _handleNewDate(date),
          isExpandable: isExpanded,
          isExpanded: false,
          showTodayIcon: true,
          initialDate: DateTime.now(),
          eventDoneColor: Colors.grey,
          eventColor: AppColors.workiColor,
          selectedColor: AppColors.workiColor,
        ),
        _buildEvent(),
      ],
    );
  }

 void _handleNewDate(date) {
    setState(() {
      _selectedDay = date;
      _selectedEvents = _events[_selectedDay] ?? [];
    });
    print(_selectedEvents);
  }

  Widget _buildEvent(){
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      height: _selectedEvents.length == 0 ? 0 : 80,
      child: ListView.builder(
        itemCount: _selectedEvents.length,
        itemBuilder: (context, i){
          
            var attributes = _selectedEvents[i]['name'].toString().split('\\');
            return ListTile(
              leading: Container(
                height: 50,
                width: 50,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: attributes[2]!='' ? 
                      Image.network(attributes[2], fit: BoxFit.cover) :
                      Image.asset('assets/no-image.png', fit: BoxFit.cover),
                  ),
              ),
              title: Text(attributes[1]),
              subtitle: Text(attributes[3]),
              onTap: (){
                Job job;
                jobs.forEach((j){
                  if(j.id == attributes[0]){
                    job = j;
                  }
                });
                Navigator.of(context).pushNamed('jobDetails', arguments: {'job':job,'user':user});
              },
            );
        }
      ),
    );
  }
}