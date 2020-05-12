import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:worki_ui/src/models/event_model.dart';
import 'package:worki_ui/src/models/job_model.dart';
import 'package:worki_ui/src/providers/job_provider.dart';

//import '../models/event_model.dart';

class EventsProvider {
  final String _url = 'demo-worki.herokuapp.com';
  int _page = 0;
  bool _cargado = false;

  Future<List<Event>> _procesarRespuesta(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(utf8.decode(resp.bodyBytes));
    final events = new Events.fromJsonList(decodedData);
    return events.items;
  }

  Future<List<Event>> getEvents() async {
    final url = Uri.https(_url, '/api/event');
    print('Events');
    return await _procesarRespuesta(url);
  }

  Future<Event> getEventById(String eventId) async {
    final url = Uri.https(_url, '/api/event/$eventId');
    final resp = await http.get(url);
    final decodedData = json.decode(utf8.decode(resp.bodyBytes));
    final event = new Event.fromJsonMap(decodedData);
    return event;
  }

  Future<dynamic> saveEvent(Event event) async {
    final url = Uri.https(_url, '/api/event');
    print('POST: ' + url.toString());
    final req = await http.post(url,
        headers: {'Content-type': 'application/json'},
        body: jsonEncode(event.toJson()));
    Map<String, dynamic> response = json.decode(utf8.decode(req.bodyBytes));
    if (response.containsKey('id')) {
      return {'ok': true, 'companyId': response['id']};
    } else {
      return {'ok': false, 'message': response['message']};
    }
  }

  Future<List<Event>> getEventsByCompany(String id) async {
    print('Get event by: ' + id);
    final url = Uri.https(_url, '/api/event/company/$id');
    var resp = await _procesarRespuesta(url);
    print(resp);
    return resp;
  }

  Future<dynamic> updateEvent(Event event) async {
    var id = event.id;
    final url = Uri.https(_url, '/api/event/$id');
    print('POST: ' + url.toString());
    final req = await http.put(url,
        headers: {'Content-type': 'application/json'},
        body: jsonEncode(event.toJson()));
    final response = json.decode(req.body);
    return response;
  }

  Future<dynamic> deleteEvent(String eventId) async {
    JobsProvider jobsProvider = new JobsProvider();
    List<Job> jobs = await jobsProvider.getJobsByEvent(eventId);
    if (jobs != null) {
      for (Job j in jobs) {
        await jobsProvider.deleteJob(j.id);
      }
    }
    final url = Uri.https(_url, '/api/event/$eventId');
    final resp = await http.delete(url);
    final decodedData = json.decode(utf8.decode(resp.bodyBytes));
    print(decodedData);
    return decodedData;
  }
}
