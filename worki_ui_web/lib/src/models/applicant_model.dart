class Applicants {
  List<Applicant> items = new List();
  Applicants();

  Applicants.fromJsonList( List<dynamic> jsonList ){
    if( jsonList == null ) return;

    for( var item in jsonList ){
      final job = new Applicant.fromJsonMap(item);
      items.add(job);
    }
  }

}


class Applicant {
  String id;
  DateTime closeDate;
  int maxWorkers;
  String jobId;
  List<String> workersId;

  Applicant() {}

  Applicant.fromJsonMap(Map<String, dynamic> json) {
    id = json['id'];
    closeDate = json['closeDate'] != null ? DateTime.parse(json['closeDate']) : null;
    maxWorkers = json['maxWorkers'];
    jobId = json['jobId'];
    workersId = json['workersId'] != null ? json['workersId'].cast<String>() : [];
  }

  Map<String, dynamic> toJson() {
    
    String closeDateAux = closeDate != null ? closeDate.toIso8601String() : null;

    return {
      'id' : id,
      'closeDate' : closeDateAux,
      'maxWorkers' : maxWorkers,
      'jobId' : jobId,
      'workersId' : workersId
    };
  }
}
