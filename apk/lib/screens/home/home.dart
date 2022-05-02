import 'package:apk/screens/addNote/addNote.dart';
import 'package:apk/screens/calendar/calendar.dart';
import 'package:apk/screens/editNote/editNote.dart';
import 'package:apk/screens/login/login.dart';
import 'package:apk/screens/noGroup/noGroup.dart';
import 'package:apk/screens/root/root.dart';
import 'package:apk/screens/settings/settings.dart';
import 'package:apk/states/currentGroup.dart';
import 'package:apk/states/currentUser.dart';
import 'package:apk/translations/locale_keys.g.dart';
import 'package:apk/widgets/ourContainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class HomeScreen extends StatelessWidget {
  void _onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Calendar()));
        break;
      case 1:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => OurNoGroup()));
        break;
      case 2:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => SettingsScreen()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    CurrentUser _currentUser = Provider.of(context, listen: false);
    final ref = FirebaseFirestore.instance
        .collection("groups")
        .doc(_currentUser.getCurrentUser.groupId)
        .collection("task");

    return Scaffold(
      appBar: AppBar(
        title: Text(
          (LocaleKeys.notes.tr()),
        ),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<int>(
            onSelected: (item) => _onSelected(context, item),
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
                child: Text(LocaleKeys.calendar.tr()),
              ),
              PopupMenuItem<int>(
                value: 1,
                child: Text(LocaleKeys.joingroup.tr()),
              ),
              PopupMenuItem<int>(
                value: 2,
                child: Text(LocaleKeys.settings.tr()),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        foregroundColor: Colors.white,
        backgroundColor: Colors.green[400],
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => OurAddTask()));
        },
      ),
      body: StreamBuilder(
          stream: ref.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            return GridView.builder(
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0),
                itemCount: snapshot.hasData ? snapshot.data!.docs.length : 0,
                itemBuilder: (_, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => EditNote(
                                  docToEdit: snapshot.data!.docs[index])));
                    },
                    child: Container(
                      margin: EdgeInsets.all(5),
                      height: 15,
                      // color: Color(snapshot.data!.docs[index]['color']),
                      // transform: Matrix4.rotationZ(0.01),
                      decoration: BoxDecoration(
                          color: Color(snapshot.data!.docs[index]['color']),
                          borderRadius: BorderRadius.circular(15.0),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.grey,
                                blurRadius: 10.0,
                                offset: Offset(2.0, 2.0))
                          ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 12.0, top: 12.0),
                            child: Text(
                              snapshot.data!.docs[index]['name'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                  color: Colors.white),
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Text(
                              snapshot.data!.docs[index]['lenght'].length > 30
                                  ? snapshot.data!.docs[index]['lenght']
                                          .substring(0, 30) +
                                      '...'
                                  : snapshot.data!.docs[index]['lenght'],
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(left:12.0),
                          //   child: Text('Due in:',
                          //   style: TextStyle(
                          //       color: Colors.white
                          //   ),),
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Text(
                              DateFormat("H:mm").format(snapshot
                                  .data!.docs[index]['dateCompleted']
                                  .toDate()),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Text(
                              DateFormat("yyyy/MM/dd").format(snapshot
                                  .data!.docs[index]['dateCompleted']
                                  .toDate()),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 18.0,
                                ),
                                child: RaisedButton(
                                    child: Text(
                                      LocaleKeys.complete.tr(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                    onPressed: () {
                                      snapshot.data!.docs[index].reference
                                          .delete();
                                    }),
                              ),
                            ],
                          ) // Text(value.getCurrentGroup.),
                        ],
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
