import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:worki_ui/src/models/administrator_model.dart';
import 'package:worki_ui/src/providers/firestore_provider.dart';

class AdministratorProvider {
  final String url = 'https://demo-worki.herokuapp.com';
  FirestoreProvider firestoreProvider = new FirestoreProvider();
  Future<Map<String,dynamic>> saveAdministrator(Administrator administrator) async {  
    final String administratorUrl = '$url/api/administrator'; //url
    print("POST : " + administratorUrl); //print method and url

    final req = await http.post(
        //request
        administratorUrl,
        headers: {"Content-type": "application/json"},
        body: jsonEncode(administrator.toJson()));

    Map<String,dynamic> response = json.decode(utf8.decode(req.bodyBytes));
    print(Administrator.fromJson(response).toJson());
    if(response.containsKey('id')){
      return {'ok':true,'administrator': response};
    }else{
      return {'ok':false,'message': response['message']};
    }
  }

  Future<Map<String, dynamic>> updateAdministrator(Administrator administrator) async {
    final administratorId = administrator.id;
    final String administratorUrl = '$url/api/administrator/$administratorId'; //url
    print("Update : " + administratorUrl); //print method and url
    administrator.modificationDate = new DateTime.now();
    final req = await http.put(
        //request
        administratorUrl,
        headers: {"Content-type": "application/json"},
        body: jsonEncode(administrator.toJson()));

    Map<String, dynamic> response = json.decode(utf8.decode(req.bodyBytes));
        await firestoreProvider.updateUser(administrator.id, administrator.name, administrator.profilePic, administrator.roles[0]);

    if (response.containsKey('id')) {
      return {'ok': true, 'admin': response};
    } else {
      return {'ok': false, 'message': response['message']};
    }
  }

  Future<bool> deleteAdministrator(String administratorId) async {
    final _url = '$url/api/administrator/$administratorId';
    final resp = await http.delete(_url);
    final decodedData = json.decode(utf8.decode(resp.bodyBytes));
    return decodedData;
  }

}