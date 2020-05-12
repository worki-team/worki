import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:worki_ui/src/models/worker_model.dart';
import 'package:worki_ui/src/providers/firestore_provider.dart';

class WorkerProvider {
  final String url = 'https://demo-worki.herokuapp.com';
  List<Worker> _workers = new List();
  FirestoreProvider firestoreProvider = new FirestoreProvider();

  Future<List<Worker>> _procesarRespuesta(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(utf8.decode(resp.bodyBytes));
    _workers = new Workers.fromJsonList(decodedData).items;
    return _workers;
  }

  Future<Map<String, dynamic>> saveWorker(Worker worker) async {
    final String workerUrl = '$url/api/worker'; //url
    print("POST : " + workerUrl); //print method and url

    final req = await http.post(
        //request
        workerUrl,
        headers: {"Content-type": "application/json"},
        body: jsonEncode(worker.toJson()));

    Map<String, dynamic> response = json.decode(utf8.decode(req.bodyBytes));
    if (response.containsKey('id')) {
      return {'ok': true, 'worker': response};
    } else {
      return {'ok': false, 'message': response['message']};
    }
  }

  Future<Map<String, dynamic>> getWorker(String idWorker) async {
    final String workerUrl = '$url/api/worker/$idWorker'; //url
    print("GET : " + workerUrl); //print method and url

    final req = await http.get(
        //request
        workerUrl,
        headers: {"Content-type": "application/json"});

    Map<String, dynamic> response = json.decode(utf8.decode(req.bodyBytes));

    if (response.containsKey('id')) {
      return {'ok': true, 'worker': response};
    } else {
      return {'ok': false, 'message': response['message']};
    }
  }

  Future<List<Worker>> getWorkers() async {
    final String workerUrl = '/api/worker'; //url
    final url = Uri.https('demo-worki.herokuapp.com', workerUrl);
    return await _procesarRespuesta(url);
  }

  Future<Map<String, dynamic>> updateWorker(Worker worker) async {
    final workerId = worker.id;
    final String workerUrl = '$url/api/worker/$workerId'; //url
    print("Update : " + workerUrl); //print method and url
    worker.modificationDate = new DateTime.now();
    final req = await http.put(
        //request
        workerUrl,
        headers: {"Content-type": "application/json"},
        body: jsonEncode(worker.toJson()));

    Map<String, dynamic> response = json.decode(utf8.decode(req.bodyBytes));
    final fireAnswer = await firestoreProvider.updateUser(worker.id, worker.name, worker.profilePic, worker.roles[0]);
    if (response.containsKey('id')) {
      return {'ok': true, 'worker': response};
    } else {
      return {'ok': false, 'message': response['message']};
    }
  }

  Future<List<Worker>> getWorkersApplicantsByJobId(String jobId) async {
    final String workerUrl = '/api/applicant/jobId/$jobId/workers'; //url
    final url = Uri.https('demo-worki.herokuapp.com', workerUrl);
    return await _procesarRespuesta(url);
  }

  Future<List<Worker>> getFilteredWorkers(Map<String,dynamic> attributes) async{
    
    Map<String,String> _params = {
      'startAge' : '18',
      'endAge' : '70'
    };

    if(attributes['name'] != ''){
      _params['name'] =  attributes['name'];
    }
    if(attributes['startAge'] != '18'){
      _params['startAge'] = attributes['startAge'];
    }
    if(attributes['endAge'] != '70'){
      _params['endAge'] = attributes['endAge'];
    }
    if(attributes['city'] != ''){
      _params['city'] = attributes['city'];
    }
    if(attributes['gender'] != 'Todos'){
      _params['gender'] = attributes['gender'];
    }
    if(attributes['language'] != ''){
      _params['language'] = attributes['language'];
    }
    if(attributes['aptitude'] != ''){
      _params['aptitude'] = attributes['aptitude'];
    }
    if(attributes['contexture'] != ''){
      Map<String,String> _contexture = {
        'Delgada':'THIN',
        'Musculosa':'MUSCLE',
        'Gruesa':'THICK',
      };
      _params['contexture'] = _contexture[attributes['contexture']];
    }
    if(attributes['eyeColor'] != ''){
      Map<String,String> _eyeColor ={
        'Negros':'BLACK',
        'Cafes':'BROWN',
        'Azules':'BLUE',
        'Verdes':'GREEN',
        'Grises':'GRAY'

      };
      _params['eyeColor'] = _eyeColor[attributes['eyeColor']];
    }
    if(attributes['hairType'] != ''){
      Map<String,String> _hairType = {
        'Lacio':'STRAIGHT',
        'Crespo':'CURLY',
        'Ondulado':'WAVY'
      };
      _params['hairType'] = _hairType[attributes['hairType']];
    }
    if(attributes['hairColor'] != ''){
      Map<String,String> _hairColor = {
        'Negro':'BLACK',
        'Cafe':'BROWN',
        'Rojo':'RED',
        'Verde':'GREEN',
        'Gris':'GRAY',
        'Rubio':'BLONDE',
        'Otro':'OTHER'
      };
      _params['hairColor'] = _hairColor[attributes['hairColor']];
    }
    if(attributes['skinColor'] != ''){
      Map<String,String> _skinColor = {
        'Clara':'WHITE',
        'Morena':'BROWN',
        'Oscura':'BLACK'
      };
      _params['skinColor'] = _skinColor[attributes['skinColor']];
    }
    if(attributes['height'] != ''){
      _params['height'] = attributes['height'];
    }
    if(attributes['weight'] != ''){
      _params['weight'] = attributes['weight'];
    }

    final url = Uri.https( 
      'demo-worki.herokuapp.com', 
      '/api/worker/filter',
      _params
    );
    print(url);
    return await _procesarRespuesta(url);
  }
}
