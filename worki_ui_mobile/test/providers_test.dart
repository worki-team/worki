import 'package:flutter/material.dart';
import 'package:test/test.dart';
import 'package:worki_ui/src/models/administrator_model.dart';
import 'package:worki_ui/src/models/company_model.dart';
import 'package:worki_ui/src/models/coordinator_model.dart';
import 'package:worki_ui/src/models/event_model.dart';
import 'package:worki_ui/src/models/job_model.dart';
import 'package:worki_ui/src/models/worker_model.dart';
import 'package:worki_ui/src/providers/administrator_provider.dart';
import 'package:worki_ui/src/providers/company_provider.dart';
import 'package:worki_ui/src/providers/coordinator_provider.dart';
import 'package:worki_ui/src/providers/event_provider.dart';
import 'package:worki_ui/src/providers/job_provider.dart';
import 'package:worki_ui/src/providers/user_provider.dart';
import 'package:worki_ui/src/providers/worker_provider.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final workerProvider = new WorkerProvider();
  final jobProvider = new JobsProvider();
  final eventProvider = new EventsProvider();
  final coordinatorProvider = new CoordinatorProvider();
  final adminProvider = new AdministratorProvider();
  final companyProvider = new CompanyProvider();
  final userProvider = new UserProvider();
  group('WorkerProvider',(){
    test('Get Workers',() async {
      print('Get Workers');
      final response = await workerProvider.getWorkers();
      expect(response,isA<List<Worker>>());
    });

    test('Save Worker', () async {
      print('Save Worker');
      Worker worker = new Worker();
      worker.name = 'Nicolas Suarez';
      worker.password = '123';
      worker.profilePic = 'https://lh3.googleusercontent.com/a-/AOh14GjUDlhGzsxPHBNCaNGzbvFd_mIUXp9W0R2o_puA4A=s96-c';
      worker.roles.add('WORKER');
      worker.isNewUser = true;
      worker.isActive = false;
      final response = await workerProvider.saveWorker(worker);
      expect(response['ok'],isTrue);
    });

    test('Get worker',() async {
      print('Get Worker');
      final response = await workerProvider.getWorker('5ea5dbab34cd57469308bbd6');
      expect(response['worker'],isMap);
    });

    test('Update Worker', () async {
      print('Update Worker');
      var response = await workerProvider.getWorker('5ea5dbab34cd57469308bbd6');
      Worker worker = Worker.fromJson(response['worker']);
      worker.phone = 123;
      response = await workerProvider.updateWorker(worker);
      expect(response['ok'],isTrue);
    });

    test('Get Workers that applied for a Job',() async {
      print('Get Workers that applied for a Job');
      final response = await workerProvider.getWorkersApplicantsByJobId('5e863a4863b41152c4aef560');
      expect(response,isA<List<Worker>>());
    });

    test('Get Workers by filter',() async {
      print('Get Workers by filter');
      Map<String,dynamic> attributes = {
        'startAge' : '18',
        'endAge' : '70',
        'city' : 'Bogotá',
        'contexture' : 'Delgada',
        'name' : '',
        'gender' : 'Todos',
        'language' : '',
        'aptitude' : '',
        'eyeColor' : '',
        'hairType' : '',
        'hairColor' : '',
        'skinColor' : '',
        'height' : '',
        'weight' : '',
      };
      final response = await workerProvider.getFilteredWorkers(attributes);
      expect(response,isA<List<Worker>>());
    });


  });

  group('JobProvider',(){
    test('Get Jobs',() async {
      print('Get Jobs');
      final response = await jobProvider.getJobs();
      expect(response,isA<List<Job>>());
    });

    test('Save Job', () async {
      print('Save Job');
      Job job = new Job();
      job.name = 'Test';
      job.jobPic = 'https://firebasestorage.googleapis.com/v0/b/worki2020.appspot.com/o/image%2Fjob%2Fingenierosonido.jpg?alt=media&token=b1a4a34d-7122-4d62-ba04-7d55fe7b3d73';
      job.eventId = '5e86398063b41152c4aef55f';
      job.companyId = '5e83f2222a48ed143735dbda';
      final response = await jobProvider.saveJob(job);
      expect(response,isMap);
    });

    test('Get Job',() async {
      print('Get Job');
      final response = await jobProvider.getJobById('5e863a4863b41152c4aef560');
      expect(response,isA<Job>());
    });

    test('Update Job', () async {
      print('Update Job');
      Job job = await jobProvider.getJobById('5e863a4863b41152c4aef560');
      job.duration = 12;
      var response = await jobProvider.updateJob(job);
      expect(response,isTrue);
    });

    test('Delete Job', () async {
      print('Delete Job');
      var response = await jobProvider.deleteJob('5e863a4863b41152c4aef560');
      expect(response,isTrue);
    });

    test('Get Jobs by filter', () async {
    print('Get Jobs by filter');
     Map<String,dynamic> attributes = {
        'name' : '',
        'startSalary' : '0',
        'endSalary' : '1000000',
        'initialDate' : '',
        'finalDate' : '',
        'duration' : '',
        'city' : 'Bogotá',
        'company' : '',
        'functions' : '',
      };
      final response = await jobProvider.getFilteredJobs(attributes);
      expect(response,isA<List<Job>>());
    });

    test('Get Jobs by Company',() async {
      print('Get Jobs by Company');
      final response = await jobProvider.getJobsByCompany('5e83f2222a48ed143735dbda');
      expect(response,isA<List<Job>>());
    });

    test('Get Jobs by Event',() async {
      print('Get Jobs by Event');
      final response = await jobProvider.getJobsByEvent('5e86398063b41152c4aef55f');
      expect(response,isA<List<Job>>());
    });

    test('Get Jobs Worker Id',() async {
      print('Get Jobs Worker Id');
      final response = await jobProvider.getJobsByWorkerId('5ea5dbab34cd57469308bbd6');
      expect(response,isA<List<Job>>());
    });

    test('Get Jobs Coordinator Id',() async {
      print('Get Jobs Coordinator Id');
      final response = await jobProvider.getJobsByCoordinatorId('5e8a7c89852aea485db37df4');
      expect(response,isA<List<Job>>());
    });

    test('Get Workers by Job Id',() async {
      print('Get Workers by Job Id');
      final response = await jobProvider.getWorkersByJobId('5e863a4863b41152c4aef560');
      expect(response,isA<List<Worker>>());
    });

    test('Get Registered Workers by Job Id',() async {
      print('Get Registered Workers by Job Id');
      final response = await jobProvider.getRegisteredWorkersByJobId('5e863a4863b41152c4aef560');
      expect(response,isA<List<Worker>>());
    });

  });

   group('EventProvider',(){
    test('Get Events',() async {
      print('Get Events');
      final response = await eventProvider.getEvents();
      expect(response,isA<List<Event>>());
    });

    test('Save Event', () async {
      print('Save Event');
      Event event = new Event();
      event.name = 'Test';
      event.eventPic = 'https://firebasestorage.googleapis.com/v0/b/worki2020.appspot.com/o/image%2Fjob%2Fingenierosonido.jpg?alt=media&token=b1a4a34d-7122-4d62-ba04-7d55fe7b3d73';
      event.companyId = '5e83f2222a48ed143735dbda';
      final response = await eventProvider.saveEvent(event);
      expect(response,isMap);
    });

    test('Get Event',() async {
      print('Get Event');
      final response = await eventProvider.getEventById('5e86398063b41152c4aef55f');
      expect(response,isA<Event>());
    });

    test('Update Event', () async {
      print('Update Event');
      Event event = await eventProvider.getEventById('5e86398063b41152c4aef55f');
      event.duration = 12;
      var response = await eventProvider.updateEvent(event);
      expect(response,isTrue);
    });

    test('Delete Event',() async {
      print('Delete Event');
      final response = await eventProvider.deleteEvent('5e86398063b41152c4aef55f');
      expect(response,isA<Event>());
    });

    test('Get Coordinator by Event ID',() async {
      print('Get Coordinator by Event ID');
      final response = await eventProvider.getCoordinatorsByEvent('5e86398063b41152c4aef55f');
      expect(response,isA<List<Coordinator>>());
    });

    test('Get Events by Company ID',() async {
      print('Get Events by Company ID');
      final response = await eventProvider.getEventsByCompany('5e83f2222a48ed143735dbda');
      expect(response,isA<List<Event>>());
    });

     test('Get Events by Coordinator ID',() async {
       print('Get Events by Coordinator ID');
      final response = await eventProvider.getEventsByCoordinator('5e8a7c89852aea485db37df4');
      expect(response,isA<List<Event>>());
    });
  });

  group('CoordinatorProvider',(){
    test('Get Coordinator',() async {
      print('Get Coordinator');
      final response = await userProvider.getUserByFireUID('zd40y1TCFARFFRIqAMpvGKnW9KE2');
      expect(response,isMap);
    });

    test('Get Coordinators by Company',() async {
      print('Get Coordinators by Company');
      final response = await coordinatorProvider.getCoordinatorsByCompanyId('5e8667b8e0f55650869d1bff');
      expect(response,isA<List<Coordinator>>());
    });

    test('Save Coordinator', () async {
      print('Save Coordinator');
      Coordinator coordinator = new Coordinator();
      coordinator.name = 'Test';
      coordinator.companyId = '5e83f2222a48ed143735dbda';
      final response = await coordinatorProvider.saveCoordinator(coordinator);
      expect(response,isMap);
    });

    test('Update Coordinator', () async {
      print('Update Coordinator');
      Coordinator coordinator = new Coordinator();
      coordinator.name = 'Nicolas';
      coordinator.city = 'Bogotá';
      coordinator.companyId = '5e8667b8e0f55650869d1bff';
      coordinator.id = '5e8a7c89852aea485db37df4';
      coordinator.password = '6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b';
      coordinator.email = 'a@a.com';
      coordinator.roles.add('COORDINATOR');
      coordinator.gender = 'Masculino';
      var response = await coordinatorProvider.updateCoordinator(coordinator);
      expect(response['ok'],isTrue);
    });
  });

  group('AdministratorProvider',(){
    
    test('Get Administrator',() async {
      print('Get Administrator');
      final response = await userProvider.getUserByFireUID('iwM9H5vzlnNDDLYokG58Q0KM28e2');
      expect(response,isMap);
    });

    test('Save Administrator', () async {
      print('Save Administrator');
      Administrator admin = new Administrator();
      admin.name = 'Nicolas Suarez';
      admin.password = '123';
      admin.profilePic = 'https://lh3.googleusercontent.com/a-/AOh14GjUDlhGzsxPHBNCaNGzbvFd_mIUXp9W0R2o_puA4A=s96-c';
      admin.roles.add('ADMINISTRATOR');
      final response = await adminProvider.saveAdministrator(admin);
      expect(response['ok'],isTrue);
    });

    test('Update Administrator', () async {
      print('Update Administrator');
      var response = await userProvider.getUserByFireUID('iwM9H5vzlnNDDLYokG58Q0KM28e2');
      Administrator admin = new Administrator.fromJson(response);
      admin.phone = 1234;
      final auxResponse = await adminProvider.updateAdministrator(admin);
      expect(auxResponse,isMap);
    });

     test('Delete Administrator', () async {
       print('Delete Administrator');
      final auxResponse = await adminProvider.deleteAdministrator('iwM9H5vzlnNDDLYokG58Q0KM28e2');
      expect(auxResponse,isMap);
    });
  });

   group('CompanyProvider',(){

    test('Get Companies',() async {
      print('Get Companies');
      final response = await companyProvider.getCompanies();
      expect(response,isA<List<Company>>());
    });
    test('Get Company',() async {
      print('Get Company');
      final response = await companyProvider.getCompanyById('5e8667b8e0f55650869d1bff');
      expect(response,isA<Company>());
    });

    test('Save Company', () async {
      print('Save Company');
      Company company = new Company();
      company.name = 'Nicolas Suarez';
      company.profilePic = 'https://lh3.googleusercontent.com/a-/AOh14GjUDlhGzsxPHBNCaNGzbvFd_mIUXp9W0R2o_puA4A=s96-c';
      final response = await companyProvider.saveCompany(company);
      expect(response['ok'],isTrue);
    });

    test('Update Company', () async {
      print('Update Company');
      Company company = await companyProvider.getCompanyById('5e8667b8e0f55650869d1bff');
      company.phone = 1234;
      final auxResponse = await companyProvider.updateCompany(company);
      expect(auxResponse,isMap);
    });

    test('Delete Company', () async {
      print('Delete Company');
      final auxResponse = await companyProvider.deleteCompany('5e8667b8e0f55650869d1bff');
      expect(auxResponse,isMap);
    });

    test('Get Company by Administrator ID',() async {
      print('Get Company by Administrator ID');
      final response = await companyProvider.getCompanyByAdministratorId('5e83d582ee8dde4cb27f84e8');
      expect(response,isA<Company>());
    });
  });
}