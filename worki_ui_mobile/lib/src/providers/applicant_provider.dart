import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:worki_ui/src/models/applicant_model.dart';
import 'package:worki_ui/src/models/job_model.dart';
import 'package:worki_ui/src/models/user_model.dart';
import 'package:worki_ui/src/models/worker_model.dart';
import 'package:worki_ui/src/providers/firestore_provider.dart';
import 'package:worki_ui/src/providers/job_provider.dart';

import '../models/job_model.dart';

class ApplicantsProvider {
  final String _url = 'demo-worki.herokuapp.com';
  List<Applicant> _applicant = new List();
  JobsProvider jobsProvider = new JobsProvider();
  FirestoreProvider firestoreProvider = new FirestoreProvider();
  Future<List<Applicant>> _procesarRespuesta(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(utf8.decode(resp.bodyBytes));
    final applicants = new Applicants.fromJsonList(decodedData);
    return applicants.items;
  }

  Future<List<Applicant>> getApplicants() async {
    final url = Uri.https(_url, '/api/applicant');
    return await _procesarRespuesta(url);
  }

  Future<dynamic> saveApplicant(Applicant applicant) async {
    final url = Uri.https(_url, '/api/applicant');
    print('POST: ' + url.toString());

    final req = await http.post(url,
        headers: {'Content-type': 'application/json'},
        body: jsonEncode(applicant.toJson()));

    Map<String, dynamic> response = json.decode(utf8.decode(req.bodyBytes));
    if (response.containsKey('id')) {
      return {'ok': true, 'companyId': response['id']};
    } else {
      return {'ok': false, 'message': response['message']};
    }
  }

  Future<dynamic> updateApplicant(Applicant applicant) async {
    final applicantId = applicant.id;
    final url = Uri.https(_url, '/api/applicant/$applicantId');
    print('PUT: ' + url.toString());
    final req = await http.put(url,
        headers: {'Content-type': 'application/json'},
        body: jsonEncode(applicant.toJson()));

    final response = json.decode(req.body);
    if (response.containsKey('id')) {
      return {'ok': true, 'id': response['id']};
    } else {
      return {
        'ok': false,
        'message': 'No es posible actualizar la convocatoria'
      };
    }
  }

  Future<Applicant> getApplicantbyJobId(String jobId) async {
    final url = Uri.https(_url, '/api/applicant/jobId/$jobId');
    final resp = await http.get(url);

    Map<String, dynamic> response = json.decode(utf8.decode(resp.bodyBytes));
    if (response.containsKey('id')) {
      return Applicant.fromJsonMap(response);
    } else {
      return null;
    }
  }

  Future<dynamic> addWorkerToApplicant(String workerId, String jobId) async {
    Applicant applicant = await getApplicantbyJobId(jobId);
    if (applicant != null) {
      if (applicant.workersId.contains(workerId)) {
        return {'ok': false, 'message': 'Ya has aplicado al trabajo'};
      }
      if (applicant.workersId.length + 1 > applicant.maxWorkers) {
        return {
          'ok': false,
          'message':
              'Lo sentimos, ya se han inscrito el número máximo de trabajadores'
        };
      }
      return await addWorkerApplicant(applicant.id,workerId);
    } else {
      return {'ok': false, 'message': ''};
    }
  }

  Future<dynamic> addWorkerApplicant(String applicantId,String workerId) async {
    final url = Uri.https(_url, '/api/applicant/$applicantId/$workerId');
    final req = await http.put(url,
        headers: {'Content-type': 'application/json'},
    );
    final response = json.decode(req.body);
    if (response.containsKey('id')) {
      return {'ok': true, 'id': response['id']};
    } else {
      return {
        'ok': false,
        'message': 'No es posible aplicar'
      };
    }
  }

  Future<dynamic> acceptApplicant(
      Worker worker, Job job, BuildContext context) async {
    Applicant applicant = await getApplicantbyJobId(job.id);
    if (applicant != null && job != null) {
      if (!job.workersId.contains(worker.id)) {
        job.workersId.add(worker.id);
        await jobsProvider.updateJob(job);
        applicant.workersId.remove(worker.id);
        await updateApplicant(applicant);
        
        final resp = await firestoreProvider.addMemberToChatWithEventId(
            job.eventId, worker.id);
        //if (pr.isShowing()) pr.hide();
      }
    } else {
      return {'ok': false, 'message': ''};
    }
  }

  Future<List<Job>> getWorkerApplicantJobs(String workerId) async {
    final url = Uri.https(_url, '/api/applicant/workerJobs/$workerId');
    final resp = await http.get(url);
    final decodedData = json.decode(utf8.decode(resp.bodyBytes));
    final jobs = new Jobs.fromJsonList(decodedData);
    return jobs.items;
  }

  Future<void> deleteApplicant(String jobId) async{
    Applicant applicant = await getApplicantbyJobId(jobId);
    String id = applicant.id;
    if(applicant != null){
      final url = Uri.https(_url, '/api/applicant/$id');
      final resp = await http.delete(url);
      return resp;
    }
  }
}
