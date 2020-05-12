import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:worki_ui/src/values/values.dart';

class RegisterMainPage extends StatelessWidget {
  const RegisterMainPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _backgroundImage(),
        _blackShadow(),
        _workiImage(context),
        _buttons(context),
      ],
    );
  }

  Widget _backgroundImage(){
    return Image.asset(
      'assets/welcome6.jpeg',
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,   
    );
  }

  Widget _blackShadow(){
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 400,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(1),
              Colors.black.withOpacity(0.9),
              Colors.black.withOpacity(0.8),
              Colors.black.withOpacity(0.7),
              Colors.black.withOpacity(0.6),
              Colors.black.withOpacity(0.5),
              Colors.black.withOpacity(0.4),
              Colors.black.withOpacity(0.1),
              Colors.black.withOpacity(0.05),
              Colors.black.withOpacity(0.025)
            ],
          ),
        ),
      ),
    );
  }

  Widget _workiImage(BuildContext context){
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height*0.5,
      child: Image.asset('assets/w.png',fit:BoxFit.cover),
    );
  }

  Widget _buttons(BuildContext context){
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              height: 50,
              width: 233,
              decoration: ButtonDecoration.workiButton,
              child: FlatButton(
                onPressed: (){
                  //Navigator.of(context).push('registerUser1',(Route<dynamic> route,) => false, arguments: jsonEncode({'rol' : 'WORKER'}));
                  Navigator.of(context).pushNamed('registerUser1',arguments: jsonEncode({'rol': 'WORKER'}));
                }, 
                textColor: Color.fromARGB(255, 255, 255, 255),
                padding: EdgeInsets.all(0),
                child: Text(
                  "Quiero trabajar",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            SizedBox(height: 40.0,),
            Container(
              height: 50,
              width: 233,
              decoration: ButtonDecoration.workiButton,
              child: FlatButton(
                onPressed: (){
                  Navigator.of(context).pushNamed('registerCompany1');
                }, 
                textColor: Color.fromARGB(255, 255, 255, 255),
                padding: EdgeInsets.all(0),
                child: Text(
                  "Quiero contratar",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}

