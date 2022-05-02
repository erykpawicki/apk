import 'package:apk/models/event.dart';
import 'package:apk/models/task.dart';
import 'package:apk/screens/calendar/calendar.dart';
import 'package:apk/screens/home/home.dart';
import 'package:apk/services/database.dart';
import 'package:apk/states/currentUser.dart';
import 'package:apk/translations/locale_keys.g.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:apk/widgets/ourContainer.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';


class OurAddEvent extends StatefulWidget {

  final bool? onGroupCreation;
  final String? groupName;

  OurAddEvent({
    this.onGroupCreation,
    this.groupName,
  });


  @override
  _OurAddEventState createState() => _OurAddEventState();
}

class _OurAddEventState extends State<OurAddEvent> {

  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  final _formKey = GlobalKey<FormBuilderState>();

  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate (BuildContext context) async {
    final DateTime? picked = await DatePicker.showDateTimePicker(context, showTitleActions: true);

    if ( picked != null && picked != _selectedDate){
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _createEvent(BuildContext context, OurEvent event ) async {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    if(_currentUser.getCurrentUser.groupId == null)     {       throw "Not implemented exception";     }
    String _returnString = await OurDatabase().addEvent(_currentUser.getCurrentUser.groupId!, event);
    if (_returnString == "success")
    {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Calendar(),
          ),
              (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) =>
    Scaffold(


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
                      // prefixIcon: Icon(Icons.list, color: Colors.green[400]),
                      hintText: LocaleKeys.title.tr(),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    cursorHeight: 20.0,
                    controller: _contentController,
                    decoration: InputDecoration(
                      // prefixIcon: Icon(Icons.title, color: Colors.green[400] ,),
                      hintText: LocaleKeys.content.tr(),
                    ),
                    maxLines: 5,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  // Text('FROM'),
                  // Text(DateFormat.yMMMMd('en_US').format(_selectedDate)),
                  // Text(DateFormat("H:mm").format(_selectedDate)),
                  // FlatButton(onPressed: () => _selectDate(context), child: Text('Change Date'),
                  // ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(LocaleKeys.to.tr()),
                  Text(DateFormat.yMMMMd('en_US').format(_selectedDate)),
                  Text(DateFormat("H:mm").format(_selectedDate)),
                  FlatButton(onPressed: () => _selectDate(context), child: Text(LocaleKeys.changedate.tr()),
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
                      OurEvent event = OurEvent();
                      event.title = _titleController.text;
                      event.description = _contentController.text;
                      // event.from = Timestamp.fromDate(_selectedDate);
                      event.to = Timestamp.fromDate(_selectedDate);

                      _createEvent(context , event);
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