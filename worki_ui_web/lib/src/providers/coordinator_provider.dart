import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:worki_ui/src/models/coordinator_model.dart';
import 'package:worki_ui/src/providers/firestore_provider.dart';

class CoordinatorProvider {
  final String url = 'https://demo-worki.herokuapp.com';
  FirestoreProvider firestoreProvider = new FirestoreProvider();
  Future<Map<String, dynamic>> saveCoordinator(Coordinator coordinator) async {
    final String coordinatorUrl = '$url/api/coordinator'; //url
    print("POST : " + coordinatorUrl); //print method and url

    final req = await http.post(
        //request
        coordinatorUrl,
        headers: {"Content-type": "application/json"},
        body: jsonEncode(coordinator.toJson()));

    Map<String, dynamic> response = json.decode(utf8.decode(req.bodyBytes));
    print(Coordinator.fromJson(response).toJson());

    if (response.containsKey('id')) {
      return {'ok': true, 'coordinator': response};
    } else {
      return {'ok': false, 'message': response['message']};
    }
  }

  Future<Map<String, dynamic>> updateCoordinator(
      Coordinator coordinator) async {
    final coordinatorId = coordinator.id;
    final String coordinatorUrl = '$url/api/coordinator/$coordinatorId'; //url
    print("Update : " + coordinatorUrl); //print method and url
    coordinator.modificationDate = new DateTime.now();
    final req = await http.put(
        //request
        coordinatorUrl,
        headers: {"Content-type": "application/json"},
        body: jsonEncode(coordinator.toJson()));

    Map<String, dynamic> response = json.decode(utf8.decode(req.bodyBytes));
    await firestoreProvider.updateUser(coordinator.id, coordinator.name,
        coordinator.profilePic, coordinator.roles[0]);

    if (response.containsKey('id')) {
      return {'ok': true, 'worker': response};
    } else {
      return {'ok': false, 'message': response['message']};
    }
  }
}
