import 'package:enum_to_string/enum_to_string.dart';
import 'package:intl/intl.dart';
import 'package:worki_ui/src/utils/eventType_enum.dart';

class Events {
  List<Event> items = new List();
  Events();

  Events.fromJsonList( List<dynamic> jsonList ){
    if( jsonList == null ) return;

    for( var item in jsonList ){
      final event = new Event.fromJsonMap(item);
      items.add(event);
    }
  }

}

class Event {
  String id;
  String address;
  String description;
  int duration;
  DateTime finalDate;
  DateTime initialDate;
  double latitude;
  double longitude;
  String name;
  bool state;
  int totalJobs;
  String eventType;
  String companyId;
  String eventPic;

  Event({
    this.id,
    this.address,
    this.description,
    this.duration,
    this.finalDate,
    this.initialDate,
    this.latitude,
    this.longitude,
    this.name,
    this.state,
    this.totalJobs,
    this.eventType,
    this.companyId,
    this.eventPic

  });

  Event.fromJsonMap( Map<String, dynamic> json) {
    id                = json['id'];
    description       = json['description'];
    address           = json['address'] != null ? json['address'] : '';
    duration          = json['duration'];
    finalDate         = DateTime.parse(json['finalDate']);
    initialDate       = DateTime.parse(json['initialDate']);
    latitude          = json['latitude']/1;
    longitude         = json['longitude']/1;
    name              = json['name'];
    state             = json['state'];
    totalJobs         = json['totalJobs'];
    eventType         = json['type'];
    companyId         = json['companyId'];
    eventPic          = json['eventPic'] != null ? json['eventPic'] : '';
  }

  Map<String, dynamic> toJson(){
    //Map eventTypeAux = this.eventType != null ? this.eventType.toJson() : null;
    String finalDateAux = finalDate != null ? finalDate.toIso8601String() : null;
    String initialDateAux = initialDate != null ? initialDate.toIso8601String() : null;


      return {
      'id':                id,
      'address':           address,
      'description':       description,
      'duration':          duration,
      'finalDate':         finalDateAux,
      'initialDate':       initialDateAux,
      'latitude':          latitude,
      'longitude':         longitude,
      'name':              name,
      'state':             state,
      'totalJobs':         totalJobs,
      'eventType':         eventType,
      'companyId':         companyId,
      'eventPic':          eventPic
      };
    }

  getInitialDate(){
    return DateFormat('dd-MM-yyyy').format(initialDate).toString();
  }

  getFinalDate(){
    return DateFormat('dd-MM-yyyy').format(finalDate).toString();
  }

}