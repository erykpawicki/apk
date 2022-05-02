import 'package:apk/screens/home/home.dart';
import 'package:apk/screens/root/root.dart';
import 'package:apk/services/database.dart';
import 'package:apk/states/currentUser.dart';
import 'package:apk/translations/locale_keys.g.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:apk/widgets/ourContainer.dart';
import 'package:provider/provider.dart';

class OurJoinGroup extends StatefulWidget {
  const OurJoinGroup({Key? key}) : super(key: key);

  @override
  _OurJoinGroupState createState() => _OurJoinGroupState();
}

class _OurJoinGroupState extends State<OurJoinGroup> {
  void _joinGroup(BuildContext context, String groupId) async {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    String _returnString = await _currentUser.joinGroup(groupId);
    if (_returnString == 'success') {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
              (route) => false);
    }
  }

  TextEditingController _groupIdController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [BackButton()],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: OurContainer(
              child: Column(
                children: [
                  TextFormField(
                    controller: _groupIdController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.group),
                      hintText: LocaleKeys.groupid.tr(),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  RaisedButton(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 100),
                      child: Text(
                        LocaleKeys.join.tr(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    onPressed: () => _joinGroup(context, _groupIdController.text),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
