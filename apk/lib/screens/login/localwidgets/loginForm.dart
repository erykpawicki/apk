import 'package:apk/screens/home/home.dart';
import 'package:apk/screens/signup/signuq.dart';
import 'package:apk/states/currentUser.dart';
import 'package:apk/widgets/ourContainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum LoginType {
  email,

}

class OurLoginForm extends StatefulWidget {
  const OurLoginForm({Key? key}) : super(key: key);

  @override
  State<OurLoginForm> createState() => _OurLoginFormState();
}

class _OurLoginFormState extends State<OurLoginForm> {
  TextEditingController _emailControler = TextEditingController();
  TextEditingController _passwordControler = TextEditingController();

  void _loginUser(String email, String password, BuildContext context) async {
    CurrentUser _currentUser = Provider.of(context, listen: false);

    try{
      if(await _currentUser.loginUser(email, password, context)) {
        Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => HomeScreen(),
        ),
        );
    }else {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Incorrect login info!"),
          duration: Duration(seconds: 2),
        ));

      }
    }catch(e){}



  }



  @override
  Widget build(BuildContext context) {
    return OurContainer(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
            child: Text(
              "Log In",
              style: TextStyle(
                color: Theme.of(context).secondaryHeaderColor,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextFormField(
            controller: _emailControler,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.alternate_email), hintText: "Email"),
          ),
          SizedBox(
            height: 20.0,
          ),
          TextFormField(
            controller: _passwordControler,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_outline), hintText: "Password"),
            obscureText: true,
          ),
          SizedBox(height: 20.0),
          RaisedButton(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 100.0),
              child: Text(
                'Log in',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
              ),
            ),
            onPressed: () {
              _loginUser(_emailControler.text, _passwordControler.text, context);
            },
          ),
          FlatButton(
            child: Text("Don't have an account? Sign up here"),
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
