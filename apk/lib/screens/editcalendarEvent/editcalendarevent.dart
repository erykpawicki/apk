import 'package:apk/translations/locale_keys.g.dart';
import 'package:apk/widgets/ourContainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class EditEvent extends StatefulWidget {



  DocumentSnapshot docToEdit;
  EditEvent({required this.docToEdit});


  @override
  _EditEventState createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {


  TextEditingController _title = TextEditingController();
  TextEditingController _description = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked =
    await DatePicker.showDateTimePicker(context, showTitleActions: true);

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }



  @override
  void initState() {

    _title = TextEditingController(text: widget.docToEdit['title']);
    _description = TextEditingController(text: widget.docToEdit['description']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.edit.tr()),
        actions: [],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: OurContainer(
              child: Column(
                children: [
                  TextFormField(
                    controller: _title,
                    decoration: InputDecoration(
                      // prefixIcon: Icon(Icons.list),
                      hintText: LocaleKeys.title.tr(),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: _description,
                    cursorHeight: 20.0,
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
                  FlatButton(
                    onPressed: () => _selectDate(context),
                    child: Text(LocaleKeys.changedate.tr()),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  RaisedButton(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 100),
                      child: Text(
                        LocaleKeys.save.tr(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    onPressed: () {
                      widget.docToEdit.reference.update({
                        'name': _title.text,
                        'lenght': _description.text,
                        'dateCompleted': Timestamp.fromDate(_selectedDate),
                      }).whenComplete(() => Navigator.pop(context));
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  RaisedButton(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 93),
                      child: Text(
                        LocaleKeys.delete.tr(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    onPressed: () {
                      widget.docToEdit.reference
                          .delete()
                          .whenComplete(() => Navigator.pop(context));
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
}

