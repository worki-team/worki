import 'dart:convert';

import 'package:dbcrypt/dbcrypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
//import 'package:password/password.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:worki_ui/src/models/administrator_model.dart';
import 'package:worki_ui/src/models/company_model.dart';
import 'package:worki_ui/src/models/coordinator_model.dart';
import 'package:worki_ui/src/models/worker_model.dart';
import 'package:worki_ui/src/providers/administrator_provider.dart';
import 'package:worki_ui/src/providers/company_provider.dart';
import 'package:worki_ui/src/providers/coordinator_provider.dart';
import 'package:worki_ui/src/providers/facebook_provider.dart';
import 'package:worki_ui/src/providers/user_provider.dart';
import 'package:worki_ui/src/providers/worker_provider.dart';
import 'package:worki_ui/src/utils/alert.dart';
import 'package:worki_ui/src/utils/progressDialog.dart';
import 'package:worki_ui/src/values/values.dart';
import 'package:worki_ui/src/providers/firebase_provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        //resizeToAvoidBottomPadding: false,
        body: LoginContent(),
      ),
    );
  }
}

class LoginContent extends StatefulWidget {
  LoginContent({Key key}) : super(key: key);

  @override
  _LoginContentState createState() => _LoginContentState();
}

class _LoginContentState extends State<LoginContent> {
  String _email, _password = "";
  final _formKey = GlobalKey<FormState>();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  UserProvider userProvider = new UserProvider();
  CompanyProvider _companyProvider = new CompanyProvider();
  bool _passwordVisible = false;
  final _passwordController = TextEditingController();
  bool _loading = false;
  FirebaseProvider firebaseProvider = new FirebaseProvider();
  FacebookProvider facebookProvider = new FacebookProvider();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  Widget build(BuildContext context) {
    var pr = showProgressDialog(context);
    return Container(
      height: MediaQuery.of(context).size.height * 1.2,
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          //** BACKGROUND PHOTO **//
          Positioned(
            left: -100,
            right: -100,
            top: -10,
            child: Image.asset(
              'assets/collins-lesulie-er3bp5ot4io-unsplash.png',
              fit: BoxFit.cover,
            ),
          ),

          ListView(
            shrinkWrap: false,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
                child: Image.asset('assets/w.png', fit: BoxFit.cover),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      _emailInput(),
                      SizedBox(
                        height: 20,
                      ),
                      _passwordInput(),
                      SizedBox(
                        height: 20.0,
                      ),
                      _loginButton(userProvider, pr),
                      _forgotPassword(),
                      SizedBox(
                        height: 40,
                      ),
                      _socialMediaButtons(pr),
                      SizedBox(
                        height: 20,
                      ),
                      //_signoutButtons()
                    ],
                  )),
            ],
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child:IconButton(
                icon: Icon(Icons.arrow_back, color: AppColors.workiColor),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _emailInput() {
    return Container(
      width: MediaQuery.of(context).size.height * 0.4,
      height: 55,
      constraints: BoxConstraints(minWidth: 250),
      child: TextFormField(
        focusNode: _emailFocusNode,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
            labelText: 'Email',
            labelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
            fillColor: Colors.white70,
            filled: true,
            prefixIcon: Icon(Icons.person, color: Colors.black),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 3.0),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            )),
        validator: (value) {
          Pattern pattern =
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
          RegExp regex = new RegExp(pattern);
          if (!regex.hasMatch(value)) {
            return 'Email inválido';
          }
          return null;
        },
        onSaved: (value) => _email = value,
        onFieldSubmitted: (_) {
          fieldFocusChange(context, _emailFocusNode, _passwordFocusNode);
        },
      ),
    );
  }

  Widget _passwordInput() {
    return Container(
      width: MediaQuery.of(context).size.height * 0.4,
      height: 55,
      constraints: BoxConstraints(minWidth: 250),
      child: new TextFormField(
        focusNode: _passwordFocusNode,
        controller: _passwordController,
        obscureText: !_passwordVisible,
        decoration: new InputDecoration(
          labelText: 'Contraseña',
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
          labelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
          fillColor: Colors.white70,
          filled: true,
          prefixIcon: Icon(Icons.lock, color: Colors.black),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Contraseña inválida';
          }
          return null;
        },
        onSaved: (value) => _password = value,
      ),
    );
  }

  Widget _loginButton(UserProvider userProvider, ProgressDialog pr) {
    var container = Container(
      width: 250,
      height: 50,
      decoration: ButtonDecoration.workiButton,
      margin: EdgeInsets.only(bottom: 10),
      child: FlatButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            pr.show();
            _formKey.currentState.save();
            _login(_email, _password, context, pr);
          }
        },
        textColor: Color.fromARGB(255, 255, 255, 255),
        padding: EdgeInsets.all(0),
        child: Text(
          "Iniciar Sesión",
          textAlign: TextAlign.left,
          style: TextStyle(
            color: AppColors.primaryText,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
    );
    return container;
  }

  Widget _forgotPassword() {
    return Container(
      child: FlatButton(
        onPressed: () => print('Olvide mi contraseña'),
        child: Text(
          'Olvidé mi contraseña',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 15,
              shadows: [Shadow(color: Colors.black, blurRadius: 8)]),
        ),
      ),
    );
  }

  Widget _socialMediaButtons(ProgressDialog pr) {
    return Container(
      //color: Colors.black,
      height: MediaQuery.of(context).size.height * 0.06,
      width: MediaQuery.of(context).size.width,

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.height * 0.2,
            height: 40,
            child: FlatButton(
                color: Colors.white,
                onPressed: () {
                  _googleLogin(pr);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Google'),
                    Image.asset(
                      'assets/google.png',
                      height: 25,
                      width: 25,
                    )
                  ],
                )),
          ),
          SizedBox(
            width: 5,
          ),
          Container(
            width: MediaQuery.of(context).size.height * 0.2,
            height: 40,
            child: FlatButton(
                color: Color.fromARGB(255, 24, 119, 242),
                onPressed: () {
                  _facebookLogin(pr);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Facebook', style: TextStyle(color: Colors.white)),
                    Image.asset(
                      'assets/facebook.png',
                      height: 25,
                      width: 25,
                    )
                  ],
                )),
          ),
        ],
      ),
    );
  }

  Widget _signoutButtons() {
    return Container(
      //color: Colors.black,
      height: MediaQuery.of(context).size.height * 0.06,
      width: MediaQuery.of(context).size.width,

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.height * 0.2,
            height: 40,
            child: FlatButton(
                color: Colors.white,
                onPressed: () {
                  _signOutGoogle();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Salir'),
                    Image.asset(
                      'assets/google.png',
                      height: 25,
                      width: 25,
                    )
                  ],
                )),
          ),
          SizedBox(
            width: 5,
          ),
          Container(
            width: MediaQuery.of(context).size.height * 0.2,
            height: 40,
            child: FlatButton(
                color: Color.fromARGB(255, 24, 119, 242),
                onPressed: () {
                  _signOutFacebook();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Salir', style: TextStyle(color: Colors.white)),
                    Image.asset(
                      'assets/facebook.png',
                      height: 25,
                      width: 25,
                    )
                  ],
                )),
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

  _login(String email, String password, BuildContext context,
      ProgressDialog pr) async {
    firebaseProvider
        .signinWithEmail(
            email, sha256.convert(utf8.encode(password)).toString())
        .then((result) async {
      Map<String, dynamic> data = await userProvider.login(
          email, sha256.convert(utf8.encode(password)).toString());
      String token = await _firebaseMessaging.getToken();
      //Map<String,dynamic> data = await userProvider.login(email,DBCrypt().hashpw(password, new DBCrypt().gensalt()));
      if (data['ok']) {
        if (data['user']['roles'][0] == 'WORKER') {
          Worker worker = Worker.fromJson(data['user']);
          if (!worker.devices.contains(token)) {
            worker.devices.add(token);
          }
          WorkerProvider _workerProvider = new WorkerProvider();
          await _workerProvider.updateWorker(worker);
          if (pr.isShowing()) pr.hide();
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.of(context)
              .pushReplacementNamed('worker_main', arguments: worker);
        }
        if (data['user']['roles'][0] == 'ADMINISTRATOR') {
          Administrator admin = Administrator.fromJson(data['user']);
          if (!admin.devices.contains(token)) {
            admin.devices.add(token);
          }
          AdministratorProvider _adminProvider = new AdministratorProvider();
          _adminProvider.updateAdministrator(admin);
          Company company =
              await _companyProvider.getCompanyById(admin.companyId);
          if (pr.isShowing()) pr.hide();
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.of(context).pushReplacementNamed('admin_main',
              arguments: {'admin': admin, 'company': company});
        }
        if (data['user']['roles'][0] == 'COORDINATOR') {
          Coordinator coordinator = Coordinator.fromJson(data['user']);
          if (!coordinator.devices.contains(token)) {
            coordinator.devices.add(token);
          }
          CoordinatorProvider _coordinatorProvider = new CoordinatorProvider();
          _coordinatorProvider.updateCoordinator(coordinator);
          Company company =
              await _companyProvider.getCompanyById(coordinator.companyId);
          if (pr.isShowing()) pr.hide();
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.of(context).pushReplacementNamed('coordinator_main',
              arguments: {'coordinator': coordinator, 'company': company});
        }
      } else {
        showAlert(context, 'Por favor ingrese los campos nuevamente');
      }
    }).catchError((e) {
      if (pr.isShowing()) pr.hide();
      //var pass = Password.hash(_password, new PBKDF2());
      showAlert(context, 'Por favor ingrese los campos nuevamente');
    });
  }

  void _googleLogin(ProgressDialog pr) {
    pr.show();
    firebaseProvider.signInWithGoogle().then((FirebaseUser user) async {
      Map<String, dynamic> userResult =
          await userProvider.getUserByFireUID(user.uid);
      String token = await _firebaseMessaging.getToken();
      if (userResult.containsKey('email')) {
        Worker worker = new Worker.fromJson(userResult);
        if (!worker.devices.contains(token)) {
          worker.devices.add(token);
        }
        WorkerProvider _workerProvider = new WorkerProvider();
        await _workerProvider.updateWorker(worker);
        pr.hide();
        Navigator.of(context)
            .pushReplacementNamed('worker_main', arguments: worker);
      } else {
        pr.hide();
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                title: Center(child: Text('Ups')),
                content: Text(
                    'Parece que este usuario no está registrado, por favor selecciona el tipo de registro:'),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () async {
                        pr.show();
                        Worker aux = new Worker();
                        aux.email = user.email;
                        aux.name = user.displayName;
                        aux.profilePic = user.photoUrl;
                        if (user.phoneNumber != null) {
                          aux.phone = int.parse(user.phoneNumber);
                        }
                        String token;
                        token = await _firebaseMessaging.getToken();
                        if (!aux.devices.contains(token)) {
                          aux.devices.add(token);
                        }
                        aux.fireUID = user.uid;
                        aux.password = '';
                        aux.roles.add('WORKER');
                        aux.isActive = false;
                        aux.isNewUser = true;
                        aux.isProfileFinished = false;
                        WorkerProvider workerProvider = new WorkerProvider();
                        Map<String, dynamic> result =
                            await workerProvider.saveWorker(aux);

                        if (result['worker'].containsKey('id')) {
                          Worker worker = new Worker.fromJson(result['worker']);
                          pr.hide();
                          Navigator.of(context).pop();
                          Navigator.of(context).pushReplacementNamed(
                              'worker_main',
                              arguments: worker);
                        }
                      },
                      child: Text('Quiero Trabajar')),
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('registerCompany1');
                      },
                      child: Text('Quiero Contratar')),
                  FlatButton(
                      onPressed: () {
                        firebaseProvider.signOut();
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancelar'))
                ],
              );
            });
      }
      //Navigator.of(context).pushReplacementNamed('worker_main', arguments:);
    }).catchError((e) {
      print(e);
      pr.hide();
      showAlert(context, 'No se pudo iniciar sesión con Google');
    });
  }

  void _signOutGoogle() {
    firebaseProvider.signOut();
  }

  void _facebookLogin(ProgressDialog pr) async {
    pr.show();
    Map<String, dynamic> profile = await facebookProvider.getFacebookProfile();
    if (profile != null) {
      firebaseProvider
          .signinWithEmail(profile['email'],
              sha256.convert(utf8.encode(profile['name'])).toString())
          .then((FirebaseUser user) async {
        Map<String, dynamic> userResult =
            await userProvider.getUserByFireUID(user.uid);
        String token = await _firebaseMessaging.getToken();
        if (userResult.containsKey('email')) {
          Worker worker = new Worker.fromJson(userResult);
          if (!worker.devices.contains(token)) {
            worker.devices.add(token);
          }
          WorkerProvider _workerProvider = new WorkerProvider();
          await _workerProvider.updateWorker(worker);
          pr.hide();
          Navigator.of(context)
              .pushReplacementNamed('worker_main', arguments: worker);
        }
      }).catchError((e) {
        pr.hide();
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                title: Center(child: Text('Ups')),
                content: Text(
                    'Parece que este usuario no está registrado, por favor selecciona el tipo de registro:'),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () async {
                        pr.show();
                        firebaseProvider
                            .createUserWithEmail(
                                profile['email'],
                                sha256
                                    .convert(utf8.encode(profile['name']))
                                    .toString())
                            .then((FirebaseUser user) async {
                          Worker aux = new Worker();
                          aux.email = user.email;
                          aux.name = profile['name'];
                          aux.profilePic = '';
                          aux.fireUID = user.uid;
                          aux.password = sha256
                              .convert(utf8.encode(profile['name']))
                              .toString();
                          aux.roles.add('WORKER');
                          aux.isActive = false;
                          aux.isNewUser = true;
                          aux.isProfileFinished = false;
                          String token;
                          token = await _firebaseMessaging.getToken();
                          if (!aux.devices.contains(token)) {
                            aux.devices.add(token);
                          }
                          WorkerProvider workerProvider = new WorkerProvider();
                          Map<String, dynamic> result =
                              await workerProvider.saveWorker(aux);
                          if (result['worker'].containsKey('id')) {
                            Worker worker =
                                new Worker.fromJson(result['worker']);
                            pr.hide();
                            Navigator.of(context).pop();
                            Navigator.of(context).pushReplacementNamed(
                                'worker_main',
                                arguments: worker);
                          }
                        }).catchError((e) => print(e));
                      },
                      child: Text('Quiero Trabajar')),
                  FlatButton(
                      onPressed: () {
                        _signOutFacebook();
                        Navigator.of(context).pushNamed('registerCompany1');
                      },
                      child: Text('Quiero Contratar')),
                  FlatButton(
                      onPressed: () {
                        firebaseProvider.signOut();
                        _signOutFacebook();
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancelar'))
                ],
              );
            });
      });
    } else {
      showAlert(context, 'Parece que ocurrió un error, intenta de nuevo');
    }
  }

  void _signOutFacebook() {
    print('Sign Out Facebook');
    facebookProvider.signoutWithFacebook();
  }
}
