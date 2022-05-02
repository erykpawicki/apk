import 'package:apk/screens/createGroup/createGroup.dart';
import 'package:apk/screens/joinGroup/joinGroup.dart';
import 'package:apk/translations/locale_keys.g.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OurNoGroup extends StatelessWidget {
  const OurNoGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _goToJoin(BuildContext context) { Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OurJoinGroup(),
        )
    );}
    void _goToCreate(BuildContext context) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OurCreateGroup(),
          )
      );
    }
    return Scaffold(
        body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              BackButton(),
            ],
          ),
        ),
        Spacer(
          flex: 1,
        ),
        Padding(
          padding: EdgeInsets.all(80),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Text(
            LocaleKeys.welcome.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 40.0, color: Colors.grey[600]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            LocaleKeys.youcanjoinorcreateyourgroup.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20.0, color: Colors.grey[600]),
          ),
        ),
        Spacer(
          flex: 1,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RaisedButton(
                  child: Text(
                    LocaleKeys.create.tr(),
                    style: TextStyle(color: Colors.white),
                  ),
                  // color: Theme.of(context).canvasColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    // side: BorderSide(
                    //   color: Theme.of(context).secondaryHeaderColor,
                    //   width: 2,
                    // ),
                  ),
                  onPressed: () => _goToCreate(context)),
              RaisedButton(
                  child: Text(
                    LocaleKeys.join.tr(),
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => _goToJoin(context)),
            ],
          ),
        )
      ],
    ));
  }
}
