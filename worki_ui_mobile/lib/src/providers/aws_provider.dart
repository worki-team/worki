import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:worki_ui/src/models/faces_compare_model.dart';

class AWSProvider {
  final String _url = 'demo-worki.herokuapp.com';

  Future<dynamic> facesCompare(String source, double similarityThreshold) async {
    FacesCompare facesCompare = new FacesCompare(
        sourceImage: source,
        similarityThreshold: similarityThreshold);

    final url = Uri.https(_url, '/api/facescomparing');
    print('POST: ' + url.toString());

    final req = await http.post(url,
        headers: {'Content-type': 'application/json'},
        body: jsonEncode(facesCompare.toJson()));

    Map<String, dynamic> response = json.decode(utf8.decode(req.bodyBytes));
    print(response);
    
    if (!response.containsKey('error')) {
      return {'ok': true, 'resp': response};
    } else {
      return {'ok': false, 'message': response['message']};
    }
  
  }
}
