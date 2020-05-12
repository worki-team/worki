import 'package:awesome_loader/awesome_loader.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:worki_ui/src/models/administrator_model.dart';
import 'package:worki_ui/src/models/company_model.dart';
import 'package:worki_ui/src/models/event_model.dart';
import 'package:worki_ui/src/providers/event_provider.dart';
import 'package:worki_ui/src/values/values.dart';
import 'package:worki_ui/src/widgets/admin_event_card.dart';

class EventsPage extends StatefulWidget {
  Administrator admin;
  Company company;
  EventsPage({@required this.admin, @required this.company});

  @override
  _EventsPageState createState() => _EventsPageState(this.admin, this.company);
}

class _EventsPageState extends State<EventsPage> {
  Administrator admin;
  Company company;
  Map<String,dynamic> _arguments;
  List<Event> events;
  EventsProvider _eventProvider = new EventsProvider();
  _EventsPageState(this.admin, this.company);

  @override
  Widget build(BuildContext context) {
     _arguments = ModalRoute.of(context).settings.arguments;
    admin = _arguments['admin'];
    company = _arguments['company'];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text('Eventos', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: AppColors.workiColor
        ),
        actions: <Widget>[

          IconButton(
            icon: Icon(Icons.add, color: AppColors.workiColor), 
            onPressed: (){
              Navigator.pushNamed(context, 'add_event',arguments: {'admin':admin,'company':company});
            }
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
         /*  Container(
            height: 100,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SearchBar <Event>(
              hintText: 'Buscar...',
              cancellationText: Text('Cancelar'),
              onSearch: _eventProvider.,
              onItemFound: (Event event, int i){
                
              },
            ),
          ), */
          FutureBuilder(
            future: _eventProvider.getEventsByCompany(company.id),
            builder: (BuildContext context, AsyncSnapshot<List> snapshot){
              if (snapshot.hasData) {
                events = snapshot.data;
                return ListView.builder(
                  shrinkWrap: true,
                  //scrollDirection: Axis.horizontal,
                  physics: ScrollPhysics(),
                  itemCount: events.length,
                  itemBuilder: (context, i){
                    
                    Event e = events[i];
                    return AdminEventCard(event: e, notifyParent: refresh,user:admin);
                  }
                );
              } else {
                return Container(
                  height: 400.0,
                  child: Center(
                    child: AwesomeLoader(
                      loaderType: AwesomeLoader.AwesomeLoader4,
                      color: AppColors.workiColor,
                    ),
                  ));
              }
            },
          )
        ],
      ),
    );
  }

  refresh(){
    setState(() {
      
    });
  }
}