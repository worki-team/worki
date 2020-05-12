import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class FacebookProvider{

  static const channel = MethodChannel('com.roughike/flutter_facebook_login');
  
  void signinWithFacebook() async{
    print('Facebook Signin');
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logInWithReadPermissions(['email']);
    
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        print(result.accessToken.token);
        onLoginStatusChange(true);
        
        break;
      case FacebookLoginStatus.cancelledByUser:
        print('Se canceló');
        break;
      case FacebookLoginStatus.error:
        print(result.errorMessage);
        break;
    }
  }

  Future<Map<String,dynamic>> getFacebookProfile() async{
    final facebookSignIn = FacebookLogin();
    facebookSignIn.loginBehavior = FacebookLoginBehavior.webViewOnly;
    final result = await facebookSignIn.logInWithReadPermissions(['email']);
    final token = result.accessToken.token;
    final graphResponse = await http.get(
                'https://graph.facebook.com/v2.12/me?fields=name,birthday,first_name,last_name,email&access_token=${token}');
    final profile = json.decode(graphResponse.body);

    return profile;
  }

  void onLoginStatusChange(bool isLoggedIn){
    print('Correcto');
  }

  
  void signoutWithFacebook() async {
    final facebookLogout = FacebookLogin();
    await facebookLogout.logOut().then((res) {
      print('User log out from Facebook');
    });
  }

}