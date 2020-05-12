import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:worki_ui/src/models/job_model.dart';
import 'package:worki_ui/src/models/worker_model.dart';
import 'package:worki_ui/src/providers/applicant_provider.dart';




class JobsProvider {
  final String _url     = 'demo-worki.herokuapp.com';
  int _page             = 0;
  bool _cargado         = false;

  Future<List<Job>> _procesarRespuesta( Uri url ) async {
    final resp          = await http.get( url );
    final decodedData   = json.decode( utf8.decode(resp.bodyBytes) );
    final jobs          = new Jobs.fromJsonList(decodedData);
    return jobs.items;
  }

  Future<List<Job>> getJobs() async {
    final url = Uri.https( _url, '/api/job');
    return await _procesarRespuesta(url);
  }

   Future<List<Job>> getJobsByEvent(String eventId) async {
    final url = Uri.https( _url, '/api/job/event/$eventId');
    return await _procesarRespuesta(url);
  }

 Future<List<Job>> getJobsByCompany(String companyId) async {
    final url = Uri.https( _url, '/api/job/company/$companyId');
    return await _procesarRespuesta(url);
  }

  Future<List<Job>> getJobsByWorkerId(String workerId) async {
    final url = Uri.https( _url, '/api/job/worker/$workerId');
    return await _procesarRespuesta(url);
  }

  Future<List<Worker>>getWorkersByJobId(String jobId) async {
    final url = Uri.https( _url, '/api/job/$jobId/workers');
    final resp          = await http.get( url );
    final decodedData   = json.decode( utf8.decode(resp.bodyBytes) );
    final workers          = new Workers.fromJsonList(decodedData);
    return workers.items;
  }

  Future<Job> getJobById( String jobId ) async {
    final url = Uri.https( _url, '/api/job/$jobId');
    final resp          = await http.get( url );
    final decodedData   = json.decode( utf8.decode(resp.bodyBytes) );
    Job job             = new Job.fromJsonMap(decodedData);
    return job;
  }

   Future<List<Job>> searchJob(String query) async {
    final url = Uri.https( _url, '/api/search/job/$query');
    return await _procesarRespuesta(url);
  }

  Future<dynamic> saveJob(Job job) async {
    
    final url = Uri.https( _url, '/api/job');
    print('POST: '+url.toString());
    final req = await http.post(
      url,
      headers: {'Content-type':'application/json'},
      body: jsonEncode(job.toJson())
    );
    final response = json.decode(req.body) ;
    return response;
  }

 Future<dynamic> updateJob(Job job) async {
    String jobId = job.id;
    final url = Uri.https( _url, '/api/job/$jobId');
    print('POST: '+url.toString());

    final req = await http.put(
      url,
      headers: {'Content-type':'application/json'},
      body: jsonEncode(job.toJson())
    );

    final response = json.decode(req.body) ;
    return response;
  }

   Future<bool> deleteJob( String jobId ) async {
    ApplicantsProvider applicantProvider = new ApplicantsProvider();
    await applicantProvider.deleteApplicant(jobId);
    final url           = Uri.https( _url, '/api/job/$jobId');
    final resp          = await http.delete( url );
    final decodedData   = json.decode( utf8.decode(resp.bodyBytes) );
    return decodedData;
  }


  Future<List<Job>> getFilteredJobs(Map<String,dynamic> attributes) async{
    
    Map<String,String> _params = {
      'startSalary' : '0',
      'endSalary' : '1000000'
    };

    if(attributes['name'] != ''){
      _params['name'] =  attributes['name'];
    }
    if(attributes['startSalary'] != '20000'){
      _params['startSalary'] = attributes['startSalary'];
    }
    
    if(attributes['endSalary'] != '99999'){
       _params['endSalary'] = attributes['endSalary'];
    }
    
    if(attributes['initialDate'] != ''){
      print(attributes['initialDate']);
       _params['initialDate' ] = attributes['initialDate'];
    }
    
    if(attributes['finalDate'] != ''){
       _params['finalDate'] = attributes['finalDate'];
    }
    
    if(attributes['duration'] != ''){
       _params['duration'] = attributes['duration'];
    }
    
    if(attributes['city'] != ''){
       _params['city'] = attributes['city'];
    }
    
    if(attributes['company'] != ''){
       _params['company'] = attributes['company'];
    }
    
    if(attributes['functions'] != ''){
       _params['functions'] = attributes['functions'];
    }

    final url = Uri.https( 
      _url, 
      '/api/job/filter',
      _params
    );
    print(url);
    return await _procesarRespuesta(url);
  }

}