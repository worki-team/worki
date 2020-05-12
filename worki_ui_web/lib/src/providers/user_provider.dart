import 'dart:convert';
//import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:worki_ui/src/models/worker_model.dart';
import 'package:worki_ui/src/models/user_model.dart';
//import 'package:worki_ui/src/models/workExperience_model.dart';
//import 'package:worki_ui/src/models/worker_model.dart';

class UserProvider {
  final String url = 'https://demo-worki.herokuapp.com';

  
  Future<Map<String,dynamic>> login(String email, String password) async {
    final String urlLogin = '$url/api/login';
    
    var user = {};
    user["email"] = email;
    user["password"] = password;
    
    final req = await http.post(
      urlLogin,
      headers: {'Content-type': 'application/json'},
      body: jsonEncode(
        user
      )
    );

    Map<String,dynamic> response = json.decode(utf8.decode(req.bodyBytes));
    
    if(response.containsKey('id')){
      return {'ok':true,'user': response};
    }else{
      return {'ok':false,'message': response['message']};
    }
  }

  Future<Map<String,dynamic>> saveWorker(Worker worker) async {
    
    final String workerUrl = '$url/api/worker'; //url
    print("POST : " + workerUrl); //print method and url

    final req = await http.post(
        //request
        workerUrl,
        headers: {"Content-type": "application/json"},
        body: jsonEncode(worker.toJson()));

    Map<String,dynamic> response = json.decode(utf8.decode(req.bodyBytes));
    if(response.containsKey('id')){
      return {'ok':true,'id': response['id']};
    }else{
      return {'ok':false,'message': response['message']};
    }
  }

  Future<Map<String,dynamic>> getUserByFireUID( String fireUID ) async {
    final String userUrl = '$url/api/user/$fireUID'; //url
    print("Get user by: " + fireUID); //print method and url

    final req = await http.get(
        //request
        userUrl,
        headers: {"Content-type": "application/json"},
    );

    Map<String,dynamic> response = json.decode(utf8.decode(req.bodyBytes));
    if(response.containsKey('id')){
      return response;
    }else{
      return {'ok':false,'message': response['message']};
    }
  }
}
