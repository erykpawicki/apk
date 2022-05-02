import 'package:apk/models/group.dart';
import 'package:apk/models/user.dart';
import 'package:apk/screens/home/home.dart';
import 'package:apk/screens/root/root.dart';
import 'package:apk/services/database.dart';
import 'package:apk/states/currentGroup.dart';
import 'package:apk/states/currentUser.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:apk/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  // final ref = FirebaseFirestore.instance.collection("users").doc(_currentUser.getCurrentUser.groupId);

  void _leaveGroup(BuildContext context) async {
    CurrentUser user = Provider.of<CurrentUser>(context, listen: false);
    user.leaveGroup();
    // if (_returnString == "success") {
    //   Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => HomeScreen(),
    //     ),
    //         (route) => false,
    //   );
    // }
  }

  void _copyGroupId(BuildContext context) {
    CurrentUser group = Provider.of<CurrentUser>(context, listen: false);
    Clipboard.setData(ClipboardData(text: group.getCurrentUser.groupId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.settings.tr()),
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
            ),
            SizedBox(
              height: 250.0,
            ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RaisedButton(
                      onPressed: () async {
                        await context.setLocale(Locale('en'));
                      },
                      child: Text(
                        'English',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ),

                RaisedButton(
                  onPressed: () async{
                    await context.setLocale(Locale('pl'));
                  },
                  child: Text(
                    'Polski',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                  ],
                ),

            SizedBox(
              height: 20.0,
            ),


            RaisedButton(
              child: Text(
                LocaleKeys.copyidgroup.tr(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () => _copyGroupId(context),
            ),
            SizedBox(
              height: 20.0,
            ),
            RaisedButton(
                child: Text(
                  LocaleKeys.leavegroup.tr(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                onPressed: () {
                  _leaveGroup(context);
                }),
            SizedBox(
              height: 20.0,
            ),

            RaisedButton(
              child: Text(
                LocaleKeys.signout.tr(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => OurRoot(),
                ),
              ),
            ),
          ],
        ),
      ),

      // body: Column(
      //   children: [
      //     RaisedButton(
      //       child: Padding(
      //         padding: EdgeInsets.symmetric(horizontal: 100),
      //         child: Text(
      //           "Sign Out",
      //           style: TextStyle(
      //             color: Colors.white,
      //             fontWeight: FontWeight.bold,
      //             fontSize: 20.0,
      //           ),
      //         ),
      //       ),
      //       onPressed: () =>
      //           Navigator.of(context).push(
      //             MaterialPageRoute(builder: (context) => OurRoot()
      //               ,
      //             ),
      //           ),
      //     ),
      //   ],
      // ),
    );
  }
}
