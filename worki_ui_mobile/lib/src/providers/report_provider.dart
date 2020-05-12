import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:worki_ui/src/models/worker_model.dart';

class ReportProvider{

  final String _url     = 'demo-worki.herokuapp.com';

  Future<List<Worker>> _procesarRespuesta( Uri url ) async {
    print('Get Report: '+ url.toString());
    final resp          = await http.get( url );
    final decodedData   = json.decode( utf8.decode(resp.bodyBytes) );
    final workers          = new Workers.fromJsonList(decodedData);
    return workers.items;
  }

  Future<List<Worker>> getReportByJobId(String jobId)async {
    Map<String,String> _params = {
      'jobId' : jobId
    };

    final url = Uri.https( 
      _url, 
      '/api/report',
      _params
    );
    
    return await _procesarRespuesta(url);
  }

  Future<List<Worker>> getReportByEventId(String eventId)async {
    Map<String,String> _params = {
      'eventId' : eventId
    };

    final url = Uri.https( 
      _url, 
      '/api/report',
      _params
    );

    return await _procesarRespuesta(url);
  }

  Future<List<Worker>> getReportByCompanyId(String companyId)async {
    Map<String,String> _params = {
      'companyId' : companyId
    };

    final url = Uri.https( 
      _url, 
      '/api/report',
      _params
    );

    return await _procesarRespuesta(url);
  }

   Future<List<Worker>> getReportByCompanyAndTimeId(String companyId, DateTime initialDate, DateTime finalDate)async {
    Map<String,String> _params = {
      'companyId' : companyId,
    };

    if(initialDate != null){
      String auxInitialDate = DateFormat('yyyy/MM/dd').format(initialDate).toString();
      _params['initialDate'] = auxInitialDate;
    }
    if(finalDate != null){
      String auxFinalDate = DateFormat('yyyy/MM/dd').format(finalDate).toString();
      _params['finalDate'] = auxFinalDate;
    }

    final url = Uri.https( 
      _url, 
      '/api/report',
      _params
    );

    return await _procesarRespuesta(url);
  }
}