import 'package:apk/models/event.dart';
import 'package:apk/screens/editNote/editNote.dart';
import 'package:apk/screens/editcalendarEvent/editcalendarevent.dart';
import 'package:apk/screens/noGroup/noGroup.dart';
import 'package:apk/screens/root/root.dart';
import 'package:apk/screens/settings/settings.dart';
import 'package:apk/states/currentUser.dart';
import 'package:apk/translations/locale_keys.g.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:apk/screens/calendarEvent/calendarEvent.dart';
import 'package:apk/screens/home/home.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:apk/services/database.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  CalendarController _calendarController = CalendarController();

  void _onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => HomeScreen()));
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

  // late Map<DateTime, List<Event>> selectedEvents;
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    CurrentUser _currentUser = Provider.of(context, listen: false);
    final events = FirebaseFirestore.instance
        .collection("groups")
        .doc(_currentUser.getCurrentUser.groupId)
        .collection("event");
    //
    // List<Event> _getEventsfromDay(DateTime date) {
    //   return selectedEvents[date] ?? [];
    // }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          (LocaleKeys.calendar.tr()),
        ),
        //   leading: IconButton(
        //   icon: Icon(Icons.arrow_back, color: Colors.black),
        //   onPressed: () => Navigator.of(context).pop(),
        // ),

        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<int>(
            onSelected: (item) => _onSelected(context, item),
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
                child: Text(LocaleKeys.notes.tr()),
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
              context, MaterialPageRoute(builder: (_) => OurAddEvent()));
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              clipBehavior: Clip.antiAlias,
              margin: const EdgeInsets.all(8.0),
              child: TableCalendar(
                focusedDay: focusedDay,
                firstDay: DateTime(1990),
                lastDay: DateTime(2050),
                calendarFormat: format,
                onFormatChanged: (CalendarFormat _format) {
                  setState(() {
                    format = _format;
                  });
                },
                startingDayOfWeek: StartingDayOfWeek.monday,
                daysOfWeekVisible: true,
                onDaySelected: (DateTime selectDay, DateTime focusDay) {
                  setState(() {
                    selectedDay = selectDay;
                    focusedDay = focusDay;
                  });
                },
                selectedDayPredicate: (DateTime date) {
                  return isSameDay(selectedDay, date);
                },

                // eventLoader: _getEventsfromDay,

                calendarStyle: CalendarStyle(
                  isTodayHighlighted: true,
                  selectedDecoration: BoxDecoration(
                    color: Colors.green[400],
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: TextStyle(color: Colors.white),
                  todayDecoration: BoxDecoration(
                    color: Colors.teal[400],
                    shape: BoxShape.circle,
                  ),
                  defaultDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  weekendDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                ),
                calendarBuilders: CalendarBuilders(),
                headerStyle: HeaderStyle(
                  formatButtonVisible: true,
                  titleCentered: true,
                  formatButtonShowsNext: false,
                  formatButtonDecoration: BoxDecoration(
                    color: Colors.green[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  formatButtonTextStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            StreamBuilder(
              stream: events.snapshots(),
              builder: (context, AsyncSnapshot snapshot) {

                var list = [];

                for(var a = 0; a < snapshot.data!.docs.length; a++)
                {
                  Timestamp eventTimestamp = snapshot.data!.docs[a]['to'];
                  DateTime eventDate = eventTimestamp.toDate();
                  if(selectedDay.day == eventDate.day && selectedDay.month == eventDate.month && selectedDay.year == eventDate.year)
                  {
                    list.add(snapshot.data!.docs[a]);
                  }
                }

                if (snapshot.hasData) {
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: list.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 25.0),
                              child: Text(
                                list[index]['title'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 25.0),
                              child: Text(list[index]['description'],),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.only(left: 25.0),
                            //   child: Text('Due in:'),
                            // ),
                            Padding(
                              padding: const EdgeInsets.only(left: 25.0),
                              child: Text(DateFormat("H:mm").format(list[index]['to'].toDate())),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [

                                 RaisedButton(
                                      child: Text(
                                        LocaleKeys.complete.tr(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0,
                                        ),
                                      ),
                                      onPressed: () {
                                        list[index].reference
                                            .delete();
                                      }),

                              ],
                            ) // Text(value.getCurrentGroup.),
                          ],

                        );
                      });
                  // return Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //
                  //     SizedBox(
                  //       height: 10.0,
                  //     ),
                  //
                  //     Text(list[index]['title']),
                  //     Text(list[index]['description']),
                  //     Text('Due in:'),
                  //     Text(DateFormat("H:mm").format(list[index]['to'].toDate())),
                  //     Text(DateFormat("yyyy/MM/dd").format(list[index]['to'].toDate())),
                  //   ],
                  // );

                  // });
                } else {
                  return Text('Brak');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
