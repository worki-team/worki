import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:worki_ui/src/models/user_model.dart';
import 'package:worki_ui/src/models/worker_model.dart';
import 'package:worki_ui/src/pages/Shared/register_user2_page.dart';
import 'package:worki_ui/src/providers/facebook_provider.dart';
import 'package:worki_ui/src/providers/firebase_provider.dart';
import 'package:worki_ui/src/providers/user_provider.dart';
import 'package:worki_ui/src/providers/worker_provider.dart';
import 'package:worki_ui/src/utils/alert.dart';
import 'package:worki_ui/src/utils/progressDialog.dart';
import 'package:crypto/crypto.dart';
import 'package:worki_ui/src/values/button_decoration.dart';


class RegisterUser1Page extends StatefulWidget {
  @override
  RegisterUser1PageState createState() => RegisterUser1PageState();
}

class RegisterUser1PageState extends State<RegisterUser1Page> {
  User user = new User(); 

  final _formKey = GlobalKey<FormState>();
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _lastNameFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  FirebaseProvider firebaseProvider = new FirebaseProvider();
  FacebookProvider facebookProvider = new FacebookProvider();
  UserProvider userProvider = new UserProvider();


  @override
  Widget build(BuildContext context) {
    var pr = showProgressDialog(context);
    Map<String,dynamic> params = jsonDecode(ModalRoute.of(context).settings.arguments);
    
    if(user.roles.length == 0){
      user.roles.add(params['rol']);
    }  

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
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: CircleAvatar(
                  backgroundImage: ExactAssetImage('assets/logo.png'),
                  radius: 60.0,
                  backgroundColor: Colors.transparent,
                ),
              ),
              Divider(
                height: 30.0,
              ),
              SizedBox(width: 10.0),
              Center(
                child:  Text(
                  user.roles[0] == 'WORKER' ? 'Háblanos de ti': 
                  user.roles[0] == 'ADMINISTRATOR' ? 'Por favor, crea un administrador':
                  user.roles[0] == 'COORDINATOR' ? 'Por favor, crea un coordinador': '',
                  style: TextStyle(
                      fontFamily: 'Trebuchet',
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
              SizedBox(height: 10.0),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10.0),
                    _nameInput(),
                    SizedBox(height: 10.0),
                    _emailInput(),
                    SizedBox(height: 40.0),
                    user.roles[0] == 'ADMINISTRATOR' ? 
                    Container():
                    Text(
                      'Registrate con: ',
                      style: TextStyle(
                          color: Color.fromRGBO(0, 167, 255, 1.0),
                          fontFamily: 'Trebuchet',
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                    SizedBox(height: 10.0),
                  ],
                ),
              ),
              user.roles[0] == 'ADMINISTRATOR' ? 
              Container():
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new FlatButton(
                    child: new Image.asset('assets/google.png'),
                    onPressed: (){
                      _googleLogin(pr);
                    },
                  ),
                  new FlatButton(
                    child: new Image.asset('assets/facebook.png'),
                    onPressed: (){
                      _facebookLogin(pr);
                    },
                  ),
                ],
              ),
              SizedBox(height: 25.0),
              
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: ButtonDecoration.workiButton,
        child: MaterialButton(
          minWidth: 200,
          onPressed: () {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              var materialPageRoute;
              var rol = params['rol'];
              if(rol == 'WORKER'){
                materialPageRoute = MaterialPageRoute(builder: (_) => new RegisterUser2Page(info: {'user':user.toJson()}));
              }else if(rol == 'ADMINISTRATOR'){
                materialPageRoute = MaterialPageRoute(builder: (_) => new RegisterUser2Page(info: {'user':user.toJson(), 'company':params['company']}));
              }else if(rol == 'COORDINATOR'){
                //materialPageRoute = MaterialPageRoute(builder: (_) => new RegisterUser2Page(info: {'user':user.toJson(), 'companyId':params['companyId']}));
              }
                Navigator.push(context, materialPageRoute);
            }
          },
          textColor: Colors.white,
          child: Text("Siguiente".toUpperCase(),
              style: TextStyle(fontSize: 14)),
        ),
      ),
    );
  }

  void fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Widget _nameInput() {
    return new ListTile(
      leading: const Icon(
        Icons.person_outline,
        color: Color.fromRGBO(0, 167, 255, 1.0),
        size: 30,
      ),
      title: new TextFormField(
        focusNode: _nameFocusNode,
        textCapitalization: TextCapitalization.sentences,
        decoration: new InputDecoration(
          hintText: "Nombre",
        ),
        validator: (value) {
          if (value == '') {
            return 'Nombre inválido';
          }
          return null;
        },
        onSaved: (value) => user.name = value,
          onFieldSubmitted: (_){
            fieldFocusChange(context, _nameFocusNode, _lastNameFocusNode);
        },
      ),
    );
  }
  
Widget _emailInput() {
    return new ListTile(
      leading: const Icon(
        Icons.alternate_email,
        color: Color.fromRGBO(0, 167, 255, 1.0),
        size: 30,
      ),
      title: new TextFormField(
        focusNode: _emailFocusNode,
        decoration: new InputDecoration(
          hintText: "Email",
        ),
        validator: (value) {
          Pattern pattern =
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
          RegExp regex = new RegExp(pattern);
          if (!regex.hasMatch(value)) {
            return 'Email inválido';
          }
          return null;
        },
        onSaved: (value) => user.email = value,
      ),
    );
  }

   void _googleLogin(ProgressDialog pr)  {
    pr.show();
    firebaseProvider.signInWithGoogle()
      .then((FirebaseUser user) async {
        
        Map<String,dynamic> userResult = await userProvider.getUserByFireUID(user.uid);
        if(userResult.containsKey('email')){
          pr.hide();
          Worker worker = new Worker.fromJson(userResult);
          Navigator.of(context).pushReplacementNamed('worker_main', arguments: worker);
        }else{
          Worker aux = new Worker();
          aux.email = user.email;
          aux.name = user.displayName;
          aux.profilePic = user.photoUrl;
          if(user.phoneNumber != null){
            aux.phone = int.parse(user.phoneNumber);
          }
          aux.fireUID = user.uid;
          aux.password = '_';
          aux.roles.add('WORKER');
          WorkerProvider workerProvider = new WorkerProvider();
          Map<String,dynamic> result = await workerProvider.saveWorker(aux);
          if(result['worker'].containsKey('id')){
            Worker worker = new Worker.fromJson(result['worker']);
            pr.hide();
            Navigator.of(context).pushReplacementNamed('worker_main', arguments: worker);
          }else{
            showAlert(context, 'Parece que ha ocurrido un error, por favor intenta de nuevo.');
          }
        }
      })
      .catchError((e) { 
        print(e);
        pr.hide();
        showAlert(context, 'No se pudo iniciar sesión con Google');
      });
    
  }

  void _facebookLogin(ProgressDialog pr) async {
    pr.show();
    Map<String,dynamic> profile = await facebookProvider.getFacebookProfile();
    if(profile != null){
      pr.show();
      firebaseProvider.createUserWithEmail(profile['email'], sha256.convert(utf8.encode(profile['name'])).toString())
        .then((FirebaseUser user) async {
          Worker aux = new Worker();
          aux.email = user.email;
          aux.name = profile['name'];
          aux.profilePic = '';
          aux.fireUID = user.uid;
          aux.password = sha256.convert(utf8.encode(profile['name'])).toString();
          aux.roles.add('WORKER');
          WorkerProvider workerProvider = new WorkerProvider();
          Map<String,dynamic> result = await workerProvider.saveWorker(aux);
          if(result['worker'].containsKey('id')){
            Worker worker = new Worker.fromJson(result['worker']);
            pr.hide();
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed('worker_main', arguments: worker);
          }
        })
        .catchError((e){
          firebaseProvider.signinWithEmail(profile['email'], sha256.convert(utf8.encode(profile['name'])).toString())
            .then((FirebaseUser user) async {
              Map<String,dynamic> userResult = await userProvider.getUserByFireUID(user.uid);
              if(userResult.containsKey('email')){
                Worker worker = new Worker.fromJson(userResult);
                pr.hide();
                Navigator.of(context).pushReplacementNamed('worker_main', arguments: worker);
              }
            })
            .catchError((e){
              showAlert(context, 'Parece que ocurrió un error, intenta de nuevo');
            });
          //showAlert(context, 'Parece que ocurrió un error, intenta de nuevo');
        });
                     

    }else{
      showAlert(context, 'Parece que ocurrió un error, intenta de nuevo');
    }
    
    
  }
}
