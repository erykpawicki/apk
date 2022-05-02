// import 'package:apk/models/task.dart';
// import 'package:apk/services/database.dart';
// import 'package:apk/states/currentUser.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// class OurAddTask extends StatefulWidget {
//
//   final String? groupName;
//
//   OurAddTask({
//     this.groupName
// })
//
//   {}@override
//   _OurAddTaskState createState() => _OurAddTaskState();
// }
//
// class _OurAddTaskState extends State<OurAddTask> {
//   void _goToAddTask(BuildContext context, String groupName, OurTask task ) async {
//     CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
//
//     await OurDatabase().createGroup(groupName, _currentUser.getCurrentUser.uid!, task  );
//   }
//
//   TextEditingController name = TextEditingController();
//   TextEditingController length = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//
//           FlatButton(
//             child: Text('Save'),
//             onPressed: () { OurTask task = OurTask();
//                     _goToAddTask(context, widget.groupName!, task);
//                     },
//                     ),
//         ],
//       ),
//       body: Container(
//         margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         child: Column(
//           children: [
//             Container(
//               decoration: BoxDecoration(border: Border.all()),
//               child: TextField(
//                 controller: name,
//                 decoration: InputDecoration(hintText: 'Title'),
//               ),
//             ),
//             SizedBox(
//               height: 10
//             ),
//             Expanded(
//               child: Container(
//                 decoration: BoxDecoration(border: Border.all()),
//                 child: TextField(
//                   controller: length,
//                   maxLines: null,
//                   expands: true,
//                   decoration: InputDecoration(hintText: 'Content'),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//
//
//     );
//   }
// }
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// class OurAddTask extends StatelessWidget {
//
//   TextEditingController _name = TextEditingController();
//   TextEditingController _lenght = TextEditingController();
//
//   CollectionReference ref = FirebaseFirestore.instance.collection('task');
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//           FlatButton(onPressed: () {
//             ref.add({
//               'title': _name.text,
//               'content': _lenght.text,
//             }).whenComplete(() => Navigator.pop(context));
//           }, child: Text('Save'),
//                     ),
//         ],
//       ),
//       body: Container(
//         margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         child: Column(
//           children: [
//             Container(
//               decoration: BoxDecoration(border: Border.all()),
//               child: TextField(
//                 controller: _name,
//                 decoration: InputDecoration(hintText: 'Title'),
//               ),
//             ),
//             SizedBox(
//               height: 10
//             ),
//             Expanded(
//               child: Container(
//                 decoration: BoxDecoration(border: Border.all()),
//                 child: TextField(
//                   controller: _lenght,
//                   maxLines: null,
//                   expands: true,
//                   decoration: InputDecoration(hintText: 'Content'),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:math';

import 'package:apk/models/task.dart';
import 'package:apk/screens/home/home.dart';
import 'package:apk/screens/root/root.dart';
import 'package:apk/services/database.dart';
import 'package:apk/states/currentUser.dart';
import 'package:apk/translations/locale_keys.g.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:apk/widgets/ourContainer.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OurAddTask extends StatefulWidget {

  final bool? onGroupCreation;
  final String? groupName;

  OurAddTask({
    this.onGroupCreation,
    this.groupName,
});


  @override
  _OurAddTaskState createState() => _OurAddTaskState();
}

class _OurAddTaskState extends State<OurAddTask> {

  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  int _selectedColor = 0;

  var _colorspalette = [Colors.yellow[300], Colors.orange[300], Colors.red[300]];

  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate (BuildContext context) async {
    final DateTime? picked = await DatePicker.showDateTimePicker(context, showTitleActions: true);

    if ( picked != null && picked != _selectedDate){
      setState(() {
        _selectedDate = picked;
      });
    }
  }



  void _createTask(BuildContext context, OurTask task ) async {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    if(_currentUser.getCurrentUser.groupId == null)     {       throw "Not implemented exception";     }
    String _returnString = await OurDatabase().addTask(_currentUser.getCurrentUser.groupId!, task);
    if (_returnString == "success")
    {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
          (route) => false);

    }

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [BackButton()],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: OurContainer(
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      // prefixIcon: Icon(Icons.list),
                      hintText: LocaleKeys.title.tr(),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: _contentController,
                    decoration: InputDecoration(
                      // prefixIcon: Icon(Icons.title),
                      hintText: LocaleKeys.content.tr(),
                    ),
                    maxLines: 5,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(DateFormat.yMMMMd('en_US').format(_selectedDate)),
                  Text(DateFormat("H:mm").format(_selectedDate)),
                  FlatButton(onPressed: () => _selectDate(context), child: Text(LocaleKeys.changedate.tr()),),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _colorsPallete()
                    ],
                  ),

                  SizedBox(
                    height: 20.0,
                  ),

                  RaisedButton(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 100),
                      child: Text(
                        LocaleKeys.create.tr(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    onPressed: () {
                      OurTask task = OurTask();
                      task.name = _titleController.text;
                      task.length = _contentController.text;
                      task.dateCompleted = Timestamp.fromDate(_selectedDate);
                      task.color = _selectedColor;

                        _createTask(context , task);
                        },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _colorsPallete(){
    return
      Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(LocaleKeys.color.tr()),
          SizedBox(
            height: 5.0,
          ),
          Wrap(
            children: List<Widget>.generate(
                3,
                    (int index){
                  return GestureDetector(
                    onTap: (){
                      setState(() {
                        _selectedColor= index==0?Colors.yellow[400]!.value:index==1?Colors.orange[300]!.value:Colors.red[300]!.value;
                        print("$index");
                      });


                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: CircleAvatar (
                        radius:  14,
                        backgroundColor: Color(index==0?Colors.yellow[400]!.value:index==1?Colors.orange[300]!.value:Colors.red[300]!.value),
                        child: _colorspalette[index]!.value == _selectedColor?Icon(Icons.done,
                          color: Colors.white,
                          size: 16,
                        ): Container(),
                      ),
                    ),
                  );
                }
            ),
          ),
        ],
      );

  }
}
