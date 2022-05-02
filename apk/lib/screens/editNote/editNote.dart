import 'package:apk/translations/locale_keys.g.dart';
import 'package:apk/widgets/ourContainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class EditNote extends StatefulWidget {
  DocumentSnapshot docToEdit;
  EditNote({required this.docToEdit});

  @override
  _EditNoteState createState() => _EditNoteState(docToEdit);
}


class _EditNoteState extends State<EditNote> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  int _selectedColor = 0;
  DateTime _selectedDate = DateTime.now();

  _EditNoteState(DocumentSnapshot docToEdit){
    _selectedColor = docToEdit['color'];
  }



  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked =
        await DatePicker.showDateTimePicker(context, showTitleActions: true);

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
  // TextEditingController _name = TextEditingController();
  // TextEditingController _lenght = TextEditingController();

  var _colorspalette = [Colors.yellow[400], Colors.orange[300], Colors.red[300]];

  @override
  void initState() {
    _titleController = TextEditingController(text: widget.docToEdit['name']);
    _contentController =
        TextEditingController(text: widget.docToEdit['lenght']);
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [_colorsPallete()],
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
                        'name': _titleController.text,
                        'lenght': _contentController.text,
                        'dateCompleted': Timestamp.fromDate(_selectedDate),
                        'color': _selectedColor,
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

  _colorsPallete() {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(LocaleKeys.color.tr()),
        SizedBox(
          height: 5.0,
        ),
        Wrap(
          children: List<Widget>.generate(3, (int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = index == 0
                      ? Colors.yellow[400]!.value
                      : index == 1
                          ? Colors.orange[300]!.value
                          : Colors.red[300]!.value;
                  print("$index");
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: _colorspalette[index],
                  child:
                      _colorspalette[index]!.value == _selectedColor
                          ? Icon(
                              Icons.done,
                              color: Colors.white,
                              size: 16,
                            )
                          : Container(),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
