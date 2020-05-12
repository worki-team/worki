import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:worki_ui/src/models/administrator_model.dart';
import 'package:worki_ui/src/models/company_model.dart';
import 'package:worki_ui/src/models/coordinator_model.dart';
import 'package:worki_ui/src/models/user_model.dart';
import 'package:worki_ui/src/models/worker_model.dart';
import 'package:worki_ui/src/providers/administrator_provider.dart';
import 'package:worki_ui/src/providers/company_provider.dart';
import 'package:worki_ui/src/providers/coordinator_provider.dart';
import 'package:worki_ui/src/providers/firebase_provider.dart';
import 'package:worki_ui/src/providers/worker_provider.dart';
import 'package:worki_ui/src/utils/alert.dart';
import 'package:worki_ui/src/values/values.dart';
import 'package:worki_ui/src/providers/push_notifications_provider.dart';

class RegisterUser3Page extends StatefulWidget {
  final Map<String, dynamic> info; //Info -> Rol y Empresa
  final File image;

  const RegisterUser3Page({@required this.info, this.image});

  @override
  RegisterUser3PageState createState() =>
      RegisterUser3PageState(info: this.info, image: this.image);
}

class RegisterUser3PageState extends State<RegisterUser3Page> {
  Map<String, dynamic> info; //Info -> Rol y Empresa
  File image;

  RegisterUser3PageState({this.info, this.image});

  //Providers
  WorkerProvider workerProvider = new WorkerProvider();
  AdministratorProvider administratorProvider = new AdministratorProvider();
  CompanyProvider companyProvider = new CompanyProvider();
  CoordinatorProvider coordinatorProvider = new CoordinatorProvider();
  FirebaseProvider firebaseProvider = new FirebaseProvider();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  User user;

  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  
  FocusNode _passwordFocusNode = FocusNode();
  FocusNode _passwordConfirmFocusNode = FocusNode();

  bool _passwordVisible = false;

  void initState() {
    _passwordVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    user = User.fromJson(info['user']);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Registro',
            style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        leading: IconButton(
            icon: Icon(Icons.navigate_before,
                color: Color.fromRGBO(0, 167, 255, 0.7)),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: <Widget>[
          Icon(Icons.add),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 70.0),
                  Center(
                    child: Text(
                      '¡Último paso!',
                      style: TextStyle(
                          fontFamily: 'Trebuchet',
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Center(
                    child: user.roles[0] == 'ADMINISTRATOR'
                        ? Text(
                            'Por favor define una contraseña para el administrador.',
                            style: TextStyle(fontFamily: 'Trebuchet', fontSize: 17),
                            textAlign: TextAlign.center,
                          )
                        : user.roles[0] == 'COORDINATOR'
                            ? Text(
                                'Por favor define una contraseña para el coordinador.',
                                style: TextStyle(
                                    fontFamily: 'Trebuchet', fontSize: 17),
                                textAlign: TextAlign.center,
                              )
                            : Text(
                                'Por favor define un email y una contraseña.',
                                style: TextStyle(
                                    fontFamily: 'Trebuchet', fontSize: 17),
                                textAlign: TextAlign.center,
                              ),
                  ),
                  SizedBox(height: 30.0),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        _passwordInput(),
                        SizedBox(height: 40.0),
                        _confirmPassword(),
                        SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                  SizedBox(height: 25.0),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: ButtonDecoration.workiButton,
              child: MaterialButton(
                minWidth: 200,
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    user.creationDate = new DateTime.now();
                    user.modificationDate = new DateTime.now();
                    
                    registerUser(user);
                  }
                },
                textColor: Colors.white,
                child: Text("Siguiente".toUpperCase(),
                    style: TextStyle(fontSize: 14)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Widget _passwordInput() {
    return new ListTile(
      leading: const Icon(
        Icons.lock,
        color: Color.fromRGBO(0, 167, 255, 1.0),
        size: 30,
      ),
      title: new TextFormField(
        controller: _passwordController,
        focusNode: _passwordFocusNode,
        obscureText: !_passwordVisible,
        decoration: new InputDecoration(
          hintText: "Contraseña",
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                if (_passwordVisible) {
                  _passwordVisible = false;
                } else {
                  _passwordVisible = true;
                }
              });
            },
            child: Icon(
                _passwordVisible ? Icons.visibility : Icons.visibility_off),
          ),
        ),
        validator: (value) {
          if (value == '') {
            return 'Contraseña inválida';
          }
          return null;
        },
        onSaved: (value) =>
            user.password = sha256.convert(utf8.encode(value)).toString(),
        onFieldSubmitted: (_) {
          fieldFocusChange(
              context, _passwordFocusNode, _passwordConfirmFocusNode);
        },
      ),
    );
  }

  Widget _confirmPassword() {
    return new ListTile(
      leading: const Icon(
        Icons.lock,
        color: Color.fromRGBO(0, 167, 255, 1.0),
        size: 30,
      ),
      title: new TextFormField(
        obscureText: !_passwordVisible,
        decoration: new InputDecoration(
          hintText: "Confirma tu contraseña",
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                if (_passwordVisible) {
                  _passwordVisible = false;
                } else {
                  _passwordVisible = true;
                }
              });
            },
            child: Icon(
                _passwordVisible ? Icons.visibility : Icons.visibility_off),
          ),
        ),
        validator: (value) {
          if (value == '') {
            return 'Contraseña inválida';
          } else if (value != _passwordController.text) {
            return 'Las contraseñas deben coincidir';
          }
          return null;
        },
        onSaved: (value) =>
            user.password = sha256.convert(utf8.encode(value)).toString(),
      ),
    );
  }

  registerUser(User user) async {
    var pr = new ProgressDialog(context, type: ProgressDialogType.Normal);

    pr.style(
      message: 'Creando...',
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
    firebaseProvider
        .createUserWithEmail(user.email, user.password)
        .then((FirebaseUser result) async {
      user.fireUID = result.uid;
      if (image != null && image!='') {
        user.profilePic = await firebaseProvider.uploadFile(
            image, 'profilePic/' + image.path.split('/').last, 'image');
      }else{
        user.profilePic = '';
      }
      if (user.roles[0] == 'WORKER') {
        Worker worker = new Worker();
        worker = Worker.fromJson(user.toJson());
        worker.isNewUser = true;
        worker.isProfileFinished = false;
        worker.isActive = false;
        String token;
        token = await _firebaseMessaging.getToken();
        if(!worker.devices.contains(token)){
          worker.devices.add(token);
        }
        worker.age = worker.getAge();
        Map<String, dynamic> data = await workerProvider.saveWorker(worker);
        if (pr.isShowing()) pr.hide();
        if (data['ok']) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
          showAlert(context, 'Se ha creado su cuenta satisfactoriamente');
        } else {
          data['message'] != null
              ? showAlert(context,
                  "No es posible crear el trabajador. " + data['message'])
              : showAlert(context, "No es posible crear el trabajador");
        }
      } else if (user.roles[0] == 'ADMINISTRATOR') {
        Administrator administrator = new Administrator();
        administrator = Administrator.fromJson(user.toJson());
        administrator.isNewUser = true;
        administrator.isActive = true;
        Company company = new Company();
        company = Company.fromJson(info['company']);

        Map<String, dynamic> companyData =
            await companyProvider.saveCompany(company);
        if (companyData['ok']) {
          showAlert(context, 'Se ha creado la empresa satisfactoriamente');
          administrator.companyId = companyData['companyId'];
          String token;
          token = await _firebaseMessaging.getToken();
          if(!administrator.devices.contains(token)){
            administrator.devices.add(token);
          }
          Map<String, dynamic> data =
              await administratorProvider.saveAdministrator(administrator);

          if (pr.isShowing()) pr.hide();
          if (data['ok']) {
            
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
            showAlert(
                context, 'Se ha creado el administrador satisfactoriamente');
          } else {
            data['message'] != null
                ? showAlert(context,
                    "No es posible crear el administrador. " + data['message'])
                : showAlert(context, "No es posible crear el trabajador");
          }
        } else {
          showAlert(context,
              "No es posible crear la empresa. " + companyData['message']);
        }
      }else if (user.roles[0] == 'COORDINATOR') {
        Coordinator coordinator = new Coordinator();
        coordinator = Coordinator.fromJson(user.toJson());
        coordinator.isNewUser = true;
        coordinator.isActive = true;
        coordinator.companyId = info['companyId'];
        Map<String, dynamic> data = await coordinatorProvider.saveCoordinator(coordinator);
        if (data['ok']) {
          firebaseProvider.signinWithEmail(info['admin']['email'], info['admin']['password'])
          .then((user){
            if (pr.isShowing()) pr.hide();
            Navigator.of(context).popUntil(ModalRoute.withName('admin_coordinator_page'));
            showAlert(context, 'Se ha creado el coordinador satisfactoriamente');
          });
        } else {
          data['message'] != null
              ? showAlert(context,
                  "No es posible crear el coordinador. " + data['message'])
              : showAlert(context, "No es posible crear el trabajador");
        }

      }
    }).catchError((e) {
      if (pr.isShowing()) pr.hide();
      showAlert(context, "No es posible crear el usuario " + e.toString());
    });
  }
}
