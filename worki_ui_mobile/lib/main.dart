// Flutter code sample for Form
// This example shows a [Form] with one [TextFormField] to enter an email
// address and a [RaisedButton] to submit the form. A [GlobalKey] is used here
// to identify the [Form] and validate input.
//
// ![](https://flutter.github.io/assets-for-api-docs/assets/widgets/form.png)
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:worki_ui/src/pages/Administrator/admin_manage_coordinator.dart';
import 'package:worki_ui/src/pages/Administrator/consolidated_page.dart';
import 'package:worki_ui/src/pages/Administrator/edit_company_page.dart';
import 'package:worki_ui/src/pages/Administrator/facial_comparing_page.dart';
import 'package:worki_ui/src/pages/Administrator/graphics_page.dart';
import 'package:worki_ui/src/pages/Administrator/report_page.dart';
import 'package:worki_ui/src/pages/Administrator/workers_page.dart';
import 'package:worki_ui/src/pages/Company/company_details.dart';
import 'package:worki_ui/src/pages/Company/register_company1_page.dart';
import 'package:worki_ui/src/pages/Company/register_company2_page.dart';
import 'package:worki_ui/src/pages/Coordinator/coordinator_profile.dart';
import 'package:worki_ui/src/pages/Event/add_event_page.dart';
import 'package:worki_ui/src/pages/Event/edit_event_page.dart';
import 'package:worki_ui/src/pages/Event/event_details.dart';
import 'package:worki_ui/src/pages/Event/events_page.dart';
import 'package:worki_ui/src/pages/Job/add_job_page.dart';
import 'package:worki_ui/src/pages/Job/edit_job.dart';
import 'package:worki_ui/src/pages/Job/job_details.dart';
import 'package:worki_ui/src/pages/Job/workers_list_page.dart';
import 'package:worki_ui/src/pages/Shared/calendar_&_jobs_page.dart';
import 'package:worki_ui/src/pages/Shared/chat_page.dart';
import 'package:worki_ui/src/pages/Shared/location_page.dart';
import 'package:worki_ui/src/pages/Shared/login_page.dart';
import 'package:worki_ui/src/pages/Shared/notification_page.dart';
import 'package:worki_ui/src/pages/Shared/register_main_page.dart';
import 'package:worki_ui/src/pages/Shared/register_user1_page.dart';
import 'package:worki_ui/src/pages/Shared/register_user2_page.dart';
import 'package:worki_ui/src/pages/Shared/register_user3_page.dart';
import 'package:worki_ui/src/pages/Worker/calendar_page.dart';
import 'package:worki_ui/src/pages/Worker/register_user4_page.dart';
import 'package:worki_ui/src/pages/Shared/splash_screen_page.dart';
import 'package:worki_ui/src/pages/Shared/welcome_page.dart';
import 'package:worki_ui/src/pages/Worker/filter_Job_page.dart';
import 'package:worki_ui/src/pages/Worker/jobs_page.dart';
import 'package:worki_ui/src/pages/Worker/instagram_page.dart';
import 'package:worki_ui/src/pages/Worker/worker_main_page.dart';
import 'package:worki_ui/src/pages/Administrator/admin_main_page.dart';
import 'package:worki_ui/src/pages/Coordinator/coordinator_main_page.dart';
import 'package:worki_ui/src/pages/Worker/worker_profile_page.dart';
import 'package:worki_ui/src/pages/Administrator/worker_qr.dart';
import 'package:worki_ui/src/providers/push_notifications_provider.dart';

void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    final pushProvider = new PushNotificationProvider();
    pushProvider.initNotifications();
    pushProvider.mensajes.listen((data) {});
    
  }
  
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        theme: ThemeData(fontFamily: 'Lato'),
        initialRoute: 'splash',
        routes: {
          '/': (BuildContext context) => LoginPage(),
          'welcome': (BuildContext context) => WelcomePage(),
          'register_main': (BuildContext context) => RegisterMainPage(),
          'worker_main': (BuildContext context) => WorkerMain(),
          'registerUser1': (BuildContext context) => RegisterUser1Page(),
          'registerUser2': (BuildContext context) => RegisterUser2Page(),
          'registerUser3': (BuildContext context) => RegisterUser3Page(),
          'registerCompany1': (BuildContext context) => RegisterCompany1Page(),
          'registerCompany2': (BuildContext context) => RegisterCompany2Page(),
          'profile_page': (BuildContext context) => WorkerProfilePage(),
          'event_page': (BuildContext context) => AddEventPage(),
          'add_job_page': (BuildContext context) => AddJobPage(),
          'jobDetails': (BuildContext context) => JobDetails(),
          'companyDetails': (BuildContext context) => CompanyDetails(),
          'splash': (BuildContext context) => SplashScreen(),
          'admin_main': (BuildContext context) => AdminMainPage(),
          'coordinator_main': (BuildContext context) => CoordinatorMainPage(),
          'add_event': (BuildContext context) => AddEventPage(),
          'notification_page': (BuildContext context) => NotificationPage(),
          'events_page': (BuildContext context) => EventsPage(),
          'edit_company': (BuildContext context) => EditCompanyPage(),
          'edit_event': (BuildContext context) => EditEventPage(),
          'event_details': (BuildContext context) => EventDetails(),
          'jobs_page': (BuildContext context) => JobsPage(),
          'filter_job_page': (BuildContext context) => FilterJobPage(),
          'workers_list_page': (BuildContext context) => WorkersListPage(),
          'workers_page': (BuildContext context) => WorkersPage(),
          'edit_profile': (BuildContext context) => RegisterUser4Page(),
          'worker_qr': (BuildContext context) => WorkerQR(),
          'chat_page': (BuildContext context) => ChatPage(),
          'calendar_page': (BuildContext context) => CalendarPage(),
          'calendar_jobs_page': (BuildContext context) => CalendarJobsPage(),
          'face_comparing': (BuildContext context) => FacialComparing(),
          'admin_coordinator_page': (BuildContext context) => AdminManageCoordinatorPage(),
          'graphics_page': (BuildContext context) => GraphicsPage(),
          'coordinator_profile': (BuildContext context) => CoordinatorProfilePage(),
          'instagram_page': (BuildContext context) => InstagramPage(),
          'report_page' : (BuildContext context) => ReportPage(),
          'consolidated_page'  : (BuildContext context) => ConsolidatedPage(),
          'location_page'  : (BuildContext context) => LocationPage(),
          'edit_job_page'  : (BuildContext context) => EditJobPage(),

        },
      ),
    );
  }
}