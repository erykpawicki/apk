import 'package:apk/models/event.dart';
import 'package:apk/models/task.dart';
import 'package:apk/models/group.dart';
import 'package:apk/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class CurrentGroup extends ChangeNotifier {
  OurGroup _currentGroup = OurGroup();
  OurTask _currentTask = OurTask();
  OurEvent _currentEvent = OurEvent();

  OurGroup get getCurrentGroup => _currentGroup;

  OurTask get getCurrentTask => _currentTask;

  OurEvent get getCurrentEvent => _currentEvent;

  void updateStateFromDatabase(String groupId) async {
    try{
      _currentGroup = OurDatabase().getGroupInfo(groupId) as OurGroup;
      _currentTask = OurDatabase().getCurrentTask(groupId, _currentGroup.currentTaskId!) as OurTask;
      _currentEvent = OurDatabase().getCurrentEvent(groupId, _currentGroup.currentEventId!) as OurEvent;
      notifyListeners();

    }
    catch (e){
      print (e);
    }

  }

}