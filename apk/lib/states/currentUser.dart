import 'package:apk/models/user.dart';
import 'package:apk/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class CurrentUser extends ChangeNotifier {
  OurUser _currentUser = OurUser(uid: '', email: '', fullName: '');

  OurUser get getCurrentUser => _currentUser;

  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> onStartUp() async {
    String retVal = "error";

    try {
      User? _firebaseUser = FirebaseAuth.instance.currentUser;
      _currentUser.uid = _firebaseUser?.uid;
      _currentUser.email = _firebaseUser?.email;
      var user = await OurDatabase().getUserInfo(_currentUser.uid!);
      _currentUser.groupId = user.groupId;
      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> signOut() async {
    String retVal = "error";
    try {
      await _auth.signOut();
      _currentUser = OurUser();
      retVal = "success";
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<String> signUpUser(
      String email, String password, String fullName) async {
    String retVal = "error";
    OurUser _user = OurUser();

    try {
      UserCredential _authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      _user.uid = _authResult.user?.uid;
      _user.email = _authResult.user?.email;
      _user.fullName = fullName;
      String _returnString = await OurDatabase().createUser(_user);
      if (_returnString == 'success') {
        retVal = 'success';
      }

      retVal = "success";
    } on PlatformException catch (e) {
      retVal = e.message!;
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  //     if (_authResult.user != null) {
  //       retVal = true;
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  //   return retVal;
  // }

  Future<String> loginUser(String email, String password) async {
    String retVal = "error";

    try {
      UserCredential _authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      _currentUser.uid = _authResult.user?.uid;
      _currentUser.email = _authResult.user?.email;
      var user = await OurDatabase().getUserInfo(_currentUser.uid!);
      _currentUser.groupId = user.groupId;
      retVal = "success";
    } on PlatformException catch (e) {
      retVal = e.message!;
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> leaveGroup() async {
    String retVal = "error";
    try {
      await OurDatabase().leaveGroup(_currentUser.groupId!, _currentUser.uid!);
      _currentUser.groupId = null;
      retVal = "success";
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<String> createGroup(String groupName) async {
    String retVal = "error";
    try {
      var groupId =
          await OurDatabase().createGroup(groupName, _currentUser.uid!);
      _currentUser.groupId = groupId;

      retVal = 'success';
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<String> joinGroup(String groupId) async {
    String retVal = "error";
    try {
      await OurDatabase().joinGroup(groupId, _currentUser.uid!);
      _currentUser.groupId = groupId;
      retVal = 'success';
    } catch (e) {
      print(e);
    }
    return retVal;
  }
}

//       if (_authResult.user != null) {
//         _currentUser.uid = _authResult.user!.uid;
//         _currentUser.email = _authResult.user!.email!;
//         retVal = true;
//       }
//     } catch (e) {
//       print(e);
//     }
//     return retVal;
//   }
// }
