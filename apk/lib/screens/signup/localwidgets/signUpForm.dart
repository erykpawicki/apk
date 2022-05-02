import 'package:apk/screens/signup/signuq.dart';
import 'package:apk/states/currentUser.dart';
import 'package:apk/translations/locale_keys.g.dart';
import 'package:apk/widgets/ourContainer.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OurSignUpForm extends StatefulWidget {
  const OurSignUpForm({Key? key}) : super(key: key);

  @override
  State<OurSignUpForm> createState() => _OurSignUpFormState();
}

class _OurSignUpFormState extends State<OurSignUpForm> {
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  void _signUpUser (String email, String password,BuildContext context, String fullName) async {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);

    try {
      String _returnString = await _currentUser.signUpUser(
          email, password, fullName);
      if (_returnString == "success") {
        Navigator.pop(context);
      } else {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(_returnString),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    return OurContainer(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
            child: Text(
              LocaleKeys.signup.tr(),
              style: TextStyle(
                color: Colors.green[400],
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextFormField(
            controller: _fullNameController,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.person_outline), hintText: LocaleKeys.fullname.tr()),
          ),
          SizedBox(
            height: 20.0,
          ),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.alternate_email), hintText: LocaleKeys.email.tr()),
          ),
          SizedBox(
            height: 20.0,
          ),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_outline), hintText: LocaleKeys.password.tr()),
            obscureText: true,
          ),
          SizedBox(
            height: 20.0,
          ),
          TextFormField(
            controller: _confirmPasswordController,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_open),
                hintText: LocaleKeys.confirmpassword.tr()),
            obscureText: true,
          ),
          SizedBox(height: 20.0),
          RaisedButton(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 80.0),
              child: Text(
                LocaleKeys.signup.tr(),
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
              ),
            ),
            onPressed: () {
              if (_passwordController.text == _confirmPasswordController.text) {
                _signUpUser(
                    _emailController.text, _passwordController.text, context, _fullNameController.text);
              } else {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("Password do not match"),
                  duration: Duration(seconds: 2),
                )
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
