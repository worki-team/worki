import 'package:intl/intl.dart';

class WorkExperiences {
    List<WorkExperience> items = new List();
    WorkExperiences();
    
    WorkExperiences.fromJsonList(List<dynamic> jsonList){
      if(jsonList == null) return;
      for(var item in jsonList){
        final workExperience = new WorkExperience.fromJson(item);
        items.add(workExperience);
      }
    }
}

class WorkExperience {
  String city;
  String company;
  String description;
  DateTime finalYear;
  DateTime initialYear;
  String position;

  WorkExperience();

  WorkExperience.fromJson(Map<String, dynamic> json){
    city        = json['city'];
    company     = json['company'];
    description = json['description'];
    finalYear   = json['finalYear']  != null ? DateTime.parse(json['finalYear']) : null;
    initialYear = json['initialYear']  != null ? DateTime.parse(json['initialYear']) : null;
    position    = json['position'];
  }

  Map<String, dynamic> toJson(){
    String initial = initialYear != null ? initialYear.toIso8601String() : null;
    String finalY = finalYear != null ? finalYear.toIso8601String() : null;
    return {
      'city' : city,
      'company' : company,
      'description' : description,
      'finalYear' : finalY,
      'initialYear' : initial,
      'position' : position
    };
  }

  getInitialYear(){
    return DateFormat('dd-MM-yyyy').format(initialYear).toString();
  }

  getFinalYear(){
    return DateFormat('dd-MM-yyyy').format(finalYear).toString();
  }
}