import 'package:awesome_loader/awesome_loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:worki_ui/src/models/administrator_model.dart';
import 'package:worki_ui/src/models/company_model.dart';
import 'package:worki_ui/src/models/coordinator_model.dart';
import 'package:worki_ui/src/models/worker_model.dart';
import 'package:worki_ui/src/providers/company_provider.dart';
import 'package:worki_ui/src/providers/firebase_provider.dart';
import 'package:worki_ui/src/providers/user_provider.dart';
import 'package:worki_ui/src/values/values.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  bool isLoggedIn;
  FirebaseProvider firebaseProvider = new FirebaseProvider();
  UserProvider userProvider = new UserProvider();
  CompanyProvider _companyProvider = new CompanyProvider();
  
  void initState() {
    isLoggedIn = false;
    firebaseProvider.checkStatus().then((FirebaseUser user) async{
      if(user == null){
        Navigator.of(context).pushReplacementNamed('welcome');
      }else{
        Map<String,dynamic> userResult = await userProvider.getUserByFireUID(user.uid);
        
        if(userResult['ok'] == false){
          Navigator.of(context).pushReplacementNamed('welcome');
          firebaseProvider.signOut();
        }
        if(userResult['roles'][0] == 'WORKER'){
          Worker worker = new Worker.fromJson(userResult);
          Navigator.of(context).pushReplacementNamed('worker_main',arguments: worker);
        }
        if(userResult['roles'][0] == 'ADMINISTRATOR'){
          Administrator admin = new Administrator.fromJson(userResult);
          Company company = await _companyProvider.getCompanyById(admin.companyId);
          Navigator.of(context).pushReplacementNamed('admin_main', arguments: {'admin':admin, 'company':company});
        }
        if(userResult['roles'][0] == 'COORDINATOR'){
          Coordinator coordinator = new Coordinator.fromJson(userResult);
          Navigator.of(context).pushReplacementNamed('coordinator_main', arguments: coordinator);
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: <Widget>[
            Container(
              padding: EdgeInsets.all(20),
              child: Image.asset('assets/Logo2.png', fit: BoxFit.scaleDown),
            ),
            Container(
              
              child: AwesomeLoader(
                loaderType: AwesomeLoader.AwesomeLoader3,
                color: AppColors.workiColor,
              ),
            ),
         ],
       ),
    );
  }
}