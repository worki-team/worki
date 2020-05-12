import 'dart:io';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:worki_ui/src/models/physicalProfile_model.dart';
import 'package:worki_ui/src/models/worker_model.dart';
import 'package:worki_ui/src/pages/Worker/edit_abilities.dart';
import 'package:worki_ui/src/pages/Worker/edit_main_page.dart';
import 'package:worki_ui/src/pages/Worker/edit_more_info_page.dart';
import 'package:worki_ui/src/pages/Worker/personal_references.dart';
import 'package:worki_ui/src/pages/Worker/physical_profile_page.dart';
import 'package:worki_ui/src/providers/firebase_provider.dart';
import 'package:worki_ui/src/providers/worker_provider.dart';
import 'package:worki_ui/src/utils/alert.dart';
import 'package:worki_ui/src/utils/contextureType_enum.dart';
import 'package:worki_ui/src/values/colors.dart';
import 'package:worki_ui/src/values/values.dart';

class RegisterUser4Page extends StatefulWidget {
  final Worker worker;
  RegisterUser4Page({@required this.worker});
  @override
  RegisterUser4PageState createState() =>
      RegisterUser4PageState(worker: this.worker);
}

class RegisterUser4PageState extends State<RegisterUser4Page> {
  FirebaseProvider firebaseProvider = FirebaseProvider();
  Worker worker;
  RegisterUser4PageState({this.worker});
  final workerProvider = new WorkerProvider();

  @override
  Widget build(BuildContext context) {
    worker = ModalRoute.of(context).settings.arguments;
    if(worker.physicalProfile == null){
      worker.physicalProfile = new PhysicalProfile();
    }
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.edit, color: AppColors.workiColor,),
              ),
              Tab(icon: Icon(Icons.add_circle_outline,color: AppColors.workiColor)),
              Tab(
                icon: Icon(Icons.work,color: AppColors.workiColor),
              ),
              Tab(
                icon: Icon(Icons.person_outline,color: AppColors.workiColor),
              ),
              Tab(
                icon: Icon(Icons.book,color: AppColors.workiColor),
              ),
            ],
          ),
          title: Text(
            'Información',
            style: TextStyle(color: Colors.black)
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: AppColors.workiColor
          ),
        ),
        body: TabBarView(
          children: [
            EditMainPage(worker: worker, notifyParent: refresh,),
            EditMoreInfoPage(worker: worker, notifyParent: refresh,),
            PersonalReferencesPage(worker: worker,notifyParent: refresh),
            PhysicalProfilePage(worker: worker, notifyParent: refresh),
            EditAbilitiesPage(worker:worker),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: ButtonDecoration.workiButton,
          height: 50,
          child: FlatButton(
            onPressed: (){
              
              //print(worker.aptitudes.toString());
              updateWorker(worker);
            }, 
            child: Text('GUARDAR', style: TextStyle(color: Colors.white))
          ),
        ),
      ),
    );
  }

  refresh(){
    setState(() {
      
    });
  }

  void updateWorker(Worker worker) async {
    if(worker.birthDate == null || worker.gender == '' || worker.gender == null || worker.city == '' || worker.city == null || worker.name == ''){
      showAlert(context, 'Por favor finaliza de llenar los datos básicos');
    }else{
      if(worker.getAge() <18){  
        showAlert(context, 'Parece que no tienes la edad mínima');
      }else{
        var pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
        pr.style(
          message: 'Actualizando el perfil',
          borderRadius: 10.0,
          backgroundColor: Colors.white,
          progressWidget: CircularProgressIndicator(),
          elevation: 10.0,
          insetAnimCurve: Curves.easeInOut,
          progressTextStyle: TextStyle(
              color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
          messageTextStyle: TextStyle(
              color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
        );
        pr.show();
        worker.age = worker.getAge();
        worker.modificationDate = DateTime.now();
        worker.isProfileFinished = true;
        if (worker.picFile != null) {
          worker.profilePic = await firebaseProvider.uploadFile(
              worker.picFile, 'profilePic/' + worker.picFile.path.split('/').last, 'image');
        }

        Map<String, dynamic> data = await workerProvider.updateWorker(worker);
        if (pr.isShowing()) pr.hide();
        if (data['ok']) {
          showAlert(context, 'Se ha actualizado satisfactoriamente');
        } else {
          data['message'] != null
              ? showAlert(
                  context, "No es posible actualizar los datos. " + data['message'])
              : showAlert(context, "No es posible actualizar los datos.");
        }

      }
    }
  }
}
