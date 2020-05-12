import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:worki_ui/src/providers/facebook_provider.dart';


class FirebaseProvider{

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FacebookProvider facebookProvider = new FacebookProvider();
  //** SIGN IN **/
  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
        return user;
  }

  Future<FirebaseUser> createUserWithEmail(String email, String password) async {
    final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    )).user;
    return user;
  }


  Future<FirebaseUser> signinWithEmail(String email, String password) async {
     final FirebaseUser user = (await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    )).user;
    return user;
  }

  void deleteCurrentUser() async{
    final FirebaseUser user = await _auth.currentUser();
    user.delete();
  }

  

  Future<FirebaseUser> checkStatus() async {
    final FirebaseUser user = await _auth.currentUser();
    return user;
  }

  //** SIGNOUT **/

  void signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    facebookProvider.signoutWithFacebook();
  }



  //** UPLOAD FILE **/
  Future<String> uploadFile(File file, String fileName, String fileType) async {
    StorageReference storageReference;
    if(fileType == 'image'){
      storageReference = FirebaseStorage.instance.ref().child('image/$fileName');
    }
    if (fileType == 'audio') {
      storageReference = 
        FirebaseStorage.instance.ref().child("audio/$fileName");
    }
    if (fileType == 'video') {
      storageReference = 
        FirebaseStorage.instance.ref().child("videos/$fileName");
    }
    if (fileType == 'pdf') {
      storageReference = 
        FirebaseStorage.instance.ref().child("pdf/$fileName");
    }
    if (fileType == 'others') {
      storageReference = 
        FirebaseStorage.instance.ref().child("others/$fileName");
    }

    final StorageUploadTask uploadTask = storageReference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    return url;
  }

  
}