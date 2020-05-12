import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

ProgressDialog showProgressDialog(BuildContext context){
  var pr = new ProgressDialog(context,type: ProgressDialogType.Normal);



  pr.style(
    message: 'Cargando ...',
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

  return pr;
}