import 'package:apk/models/user.dart';
import 'package:apk/screens/home/home.dart';
import 'package:apk/screens/signup/signuq.dart';
import 'package:apk/services/database.dart';
import 'package:apk/states/currentUser.dart';
import 'package:apk/translations/locale_keys.g.dart';
import 'package:apk/widgets/ourContainer.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum LoginType {
  email,
}

enum log {uid, }

class OurLoginForm extends StatefulWidget {
  const OurLoginForm({Key? key}) : super(key: key);

  @override
  State<OurLoginForm> createState() => _OurLoginFormState();
}

class _OurLoginFormState extends State<OurLoginForm> {
  TextEditingController _emailControler = TextEditingController();
  TextEditingController _passwordControler = TextEditingController();

  void _loginUser(LoginType type, String email, String password,
      BuildContext context) async {
    CurrentUser _currentUser = Provider.of(context, listen: false);

    try {
      String? _returnString;
      OurUser _returnUser;

      switch (type) {
        case LoginType.email:
          _returnString = await _currentUser.loginUser(email, password);
          _returnUser  = await OurDatabase().getUserInfo(_currentUser.getCurrentUser.uid!);
          _currentUser.getCurrentUser.groupId = _returnUser.groupId;
          _currentUser.getCurrentUser.fullName = _returnUser.fullName;
          break;
        default:
      }

      if (_returnString == 'success') {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      } else {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(_returnString!),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print(e);
    }

    // try{
    //   if(await _currentUser.loginUser(email, password)) {
    //     Navigator.of(context).push(
    //     MaterialPageRoute(
    //         builder: (context) => HomeScreen(),
    //     ),
    //     );
    // }else {
    //     Scaffold.of(context).showSnackBar(SnackBar(
    //       content: Text("Incorrect login info!"),
    //       duration: Duration(seconds: 2),
    //     ));
    //
    //   }
    // }catch(e){}
  }

  @override
  Widget build(BuildContext context) {
    return OurContainer(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
            child: Text(
              LocaleKeys.login.tr(),
              style: TextStyle(
                color: Colors.green[400],
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextFormField(
            controller: _emailControler,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.alternate_email), hintText: LocaleKeys.email.tr()),
          ),
          SizedBox(
            height: 20.0,
          ),
          TextFormField(
            controller: _passwordControler,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_outline), hintText: LocaleKeys.password.tr()),
            obscureText: true,
          ),
          SizedBox(height: 20.0),
          RaisedButton(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 100.0),
              child: Text(
                LocaleKeys.login.tr(),
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
              ),
            ),
            onPressed: () {
              _loginUser(
                  LoginType.email,
                  _emailControler.text,
                  _passwordControler.text,
                  context
              );
            },
          ),
          FlatButton(
            child: Text(LocaleKeys.dont.tr()),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => OurSignUp(),
                ),
              );
            },
          ),
          // _googleButton()
        ],
      ),
    );
  }
}
