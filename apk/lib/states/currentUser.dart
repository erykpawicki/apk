import 'package:apk/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CurrentUser extends ChangeNotifier {

  late OurUser _currentUser;

  OurUser get getCurrentUser => _currentUser;

  FirebaseAuth _auth = FirebaseAuth.instance;



  Future<String> onStartUp() async {
    String retVal = "error";

    try {
      User? _firebaseUser = FirebaseAuth.instance.currentUser;
      _currentUser.uid = _firebaseUser!.uid;
     _currentUser.email = _firebaseUser.email!;
      retVal = "success";

    } catch (e) {}

    return retVal;
  }

  Future<String> signOut() async {
    String retVal = "error";

    try {
      await _auth.signOut();

      retVal = "success";
    } catch (e) {}

    return retVal;
  }

  Future<bool> signUpUser(String email, String password, context) async {
    bool retVal = false;

    try {
      UserCredential _authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      if (_authResult.user != null) {
        retVal = true;
      }
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<bool> loginUser(String email, String password, context) async {
    bool retVal = false;

    try {
      UserCredential _authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (_authResult.user != null) {
        _currentUser.uid = _authResult.user!.uid;
        _currentUser.email = _authResult.user!.email!;
        retVal = true;
      }
    } catch (e) {
      print(e);
    }
    return retVal;
  }
}
