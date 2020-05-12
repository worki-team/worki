import 'package:intl/intl.dart';
import 'package:worki_ui/src/models/physicalProfile_model.dart';

class Jobs {
  List<Job> items = new List();
  Jobs();

  Jobs.fromJsonList( List<dynamic> jsonList ){
    if( jsonList == null ) return;

    for( var item in jsonList ){
      final job = new Job.fromJsonMap(item);
      items.add(job);
    }
  }

}

class Job {
  String id;
  String description;
  int duration;
  String jobPic;
  String employmentType;
  DateTime finalDate;
  List<String> functions;
  DateTime initialDate;
  String name;
  String qrCode;
  double salary;
  bool state;
  String eventId;
  String companyId;
  int people;
  List<String> workersId;
  PhysicalProfile physicalProfile;

  Job({
    this.id,
    this.description,
    this.duration,
    this.jobPic,
    this.employmentType,
    this.finalDate,
    this.functions,
    this.initialDate,
    this.name,
    this.qrCode,
    this.salary,
    this.state,
    this.eventId,
    this.companyId,
    this.workersId,
    this.physicalProfile

  });

  Job.fromJsonMap( Map<String, dynamic> json) {
    id                = json['id'];
    description       = json['description'];
    duration          = json['duration'];
    jobPic            = json['jobPic'] != null ? json['jobPic'] : '';
    employmentType    = json['employmentType'];
    finalDate         = DateTime.parse(json['finalDate']);
    functions         = json['functions'] != null ? json['functions'].cast<String>() : [];
    initialDate       = DateTime.parse(json['initialDate']);
    name              = json['name'];
    qrCode            = json['qrCode'];
    salary            = json['salary']/1;
    state             = json['state'];
    eventId           = json['eventId'];
    companyId         = json['companyId'];
    people            = json['people'];
    workersId         = json['workersId'] != null ? json['workersId'].cast<String>() : [];
    physicalProfile   = json['physicalProfile'] != null ? PhysicalProfile.fromJson(json['physicalProfile']) : null;
  }

  Map<String, dynamic> toJson(){
    Map physicalProfileAux = this.physicalProfile != null ? this.physicalProfile.toJson() : null;
    String finalDateAux = finalDate != null ? finalDate.toIso8601String() : null;
    String initialDateAux = initialDate != null ? initialDate.toIso8601String() : null;



    return {
      'id':                       id,
      'description':              description,
      'duration':                 duration,
      'jobPic':                   jobPic,
      'employmentType':           employmentType,
      'finalDate':                finalDateAux,
      'initialDate':              initialDateAux,
      'functions':                functions,
      'name':                     name,
      'qrCode':                   qrCode,
      'salary':                   salary,
      'state':                    state,
      'eventId':                  eventId,
      'companyId':                companyId,
      'people':                   people,
      'workersId':                workersId,
      'physicalProfile':          physicalProfileAux
    };
  }

  getInitialDate(){
    return DateFormat('dd-MM-yyyy').format(initialDate).toString();
  }

  getFinalDate(){
    return DateFormat('dd-MM-yyyy').format(finalDate).toString();
  }

}