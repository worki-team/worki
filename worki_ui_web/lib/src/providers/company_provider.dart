import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:worki_ui/src/models/company_model.dart';

class CompanyProvider {
  final String _url =  'demo-worki.herokuapp.com';

  List<Company> _companies = new List();

  Future<List<Company>> _procesarRespuesta(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(utf8.decode(resp.bodyBytes));
    final companies = new Companies.fromJsonList(decodedData);
    return companies.items;
  }

  Future<Company> getCompanyById(String id) async {
    final url = Uri.https(_url, '/api/company/$id');
    final resp = await http.get(url);
    final decodedData = json.decode(utf8.decode(resp.bodyBytes));
    final company = new Company.fromJson(decodedData);
    return company;
  }

  Future<Company> getCompanyByAdministratorId(String adminId) async {
    print('adi ' + adminId);
    final url = Uri.https(_url, '/api/administrator/$adminId/company');
    final resp = await http.get(url);
    final decodedData = json.decode(utf8.decode(resp.bodyBytes));
    print(decodedData);
    final company = new Company.fromJson(decodedData);
    return company;
  }

  Future<List<Company>> getCompanies() async {
    final url = Uri.https(_url, '/api/company');
    return await _procesarRespuesta(url);
  }

  Future<Map<String, dynamic>> saveCompany(Company company) async {
    final companyUrl = Uri.https(_url, '/api/company'); //url
    print("POST : " + companyUrl.toString()); //print method and url

    final req = await http.post(
        //request
        companyUrl,
        headers: {"Content-type": "application/json"},
        body: jsonEncode(company.toJson()));

    Map<String, dynamic> response = json.decode(utf8.decode(req.bodyBytes));
    if (response.containsKey('id')) {
      return {'ok': true, 'companyId': response['id']};
    } else {
      return {'ok': false, 'message': response['message']};
    }
  }

  Future<Map<String, dynamic>> updateCompany(Company company) async {
    final companyId = company.id;
    final url = Uri.https(_url, '/api/company/$companyId');
    print('PUT: ' + url.toString());
    print(company.toJson());
    final req = await http.put(url,
        headers: {'Content-type': 'application/json'},
        body: jsonEncode(company.toJson()));
    Map<String, dynamic> response = json.decode(utf8.decode(req.bodyBytes));
    if (response.containsKey('id')) {
      return {'ok': true, 'worker': response};
    } else {
      return {'ok': false, 'message': response['message']};
    }
  }

  Future<bool> deleteCompany(String companyId) async {
    final url = Uri.https(_url, '/api/company/$companyId');
    final resp = await http.delete(url);
    final decodedData = json.decode(utf8.decode(resp.bodyBytes));
    return decodedData;
  }
}
