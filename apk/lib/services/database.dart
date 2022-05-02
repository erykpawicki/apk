import 'package:apk/models/event.dart';
import 'package:apk/models/group.dart';
import 'package:apk/models/task.dart';
import 'package:apk/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OurDatabase{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<String> createUser(OurUser user) async {
    String retVal = 'error';
    try{
      await _firestore.collection("users").doc(user.uid).set({
        'fullName' : user.fullName,
        'email' : user.email,
      });
      retVal = 'success';
    } catch (e){
      print (e);
    }
    return retVal;
  }



  Future<OurUser> getUserInfo(String uid) async{
    OurUser retVal = OurUser();

    try{
      DocumentSnapshot _docSnapshot = await _firestore.collection("users").doc(uid).get();
      retVal.uid = uid;
      retVal.fullName = _docSnapshot["fullName"];
      retVal.email = _docSnapshot['email'];
      retVal.groupId = _docSnapshot['groupId'];
    } catch (e){
      print (e);
    }
    return retVal;
  }


  Future<String> createGroup(String groupName, String userUid,) async {
    String retVal = 'error';

    List <String> members = <String>[];

    try {
      members.add(userUid);
      DocumentReference _docRef = await _firestore.collection('groups').add({
        'name' : groupName,
        'leader': userUid,
        'members' : members,
      });
      await _firestore.collection("users").doc(userUid).update({
        'groupId': _docRef.id,
      });
      retVal = _docRef.id;
    } catch (e) {
      print(e);
    }
    return retVal;
  }


  Future<String> joinGroup(String groupId, String userUid) async {
    String retVal = 'error';
    List <String> members = <String>[];
    try {
      members.add(userUid);

      await _firestore.collection("groups").doc(groupId).update({
        'members': FieldValue.arrayUnion(members),

      });
      await _firestore.collection("users").doc(userUid).update({
        'groupId': groupId,
      });

      retVal = 'success';
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<String> leaveGroup(String groupId, String userUid) async {
    String retVal = "error";
    List <String> members = <String>[];
    try {
      members.add(userUid);
      await _firestore.collection("groups").doc(groupId).update({
        'members': FieldValue.arrayRemove(members),
      });

      await _firestore.collection("users").doc(userUid).update({
        'groupId': null,
      });
      retVal = 'success';
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<OurGroup> getGroupInfo(String groupId) async{
    OurGroup retVal = OurGroup();

    try{
      DocumentSnapshot _docSnapshot = await _firestore.collection("groups").doc(groupId).get();
      retVal.id = groupId;
      retVal.name = _docSnapshot["name"];
      retVal.leader = List<String>.from(_docSnapshot['leader']) as String?;
      retVal.members = _docSnapshot['members'];
      retVal.currentTaskId = _docSnapshot['currentTaskId'];
      retVal.currentTaskDue = _docSnapshot['currentTaskDue'];
    } catch (e){
      print (e);
    }
    return retVal;
  }

  Future<String> addTask(String groupId, OurTask task) async {
    String retVal = 'error';
    try{
      DocumentReference _docRef = await _firestore.collection("groups").doc(groupId).collection("task").add({
        'name' : task.name,
        'lenght' : task.length,
        'dateCompleted': task.dateCompleted,
        'color': task.color,
      });
      
      await _firestore.collection("groups").doc(groupId).update({
        "currnetTaskId" : _docRef.id,
        "currentTaskDue": task.dateCompleted,

      });
      
      retVal = 'success';
    } catch (e){
      print (e);
    }
    return retVal;
  }


  Future<OurTask> getCurrentTask(String groupId, String taskId) async{
    OurTask retVal = OurTask();

    try{
      DocumentSnapshot _docSnapshot = await _firestore.collection("groups").doc(groupId).collection("task").doc(taskId).get();
      retVal.id = taskId;
      retVal.name = _docSnapshot["name"];
      retVal.length = _docSnapshot["length"];
      retVal.dateCompleted = _docSnapshot["dateCompleted"];
      retVal.color = _docSnapshot["dateCompleted"];
    } catch (e){
      print (e);
    }
    return retVal;
  }


  Future<String> addEvent(String groupId, OurEvent event) async {
    String retVal = 'error';
    try{
      DocumentReference _docRef = await _firestore.collection("groups").doc(groupId).collection("event").add({
        'title' : event.title,
        'description' : event.description,
        // 'from': event.from,
        'to': event.to,
        'isAllDay': event.isAllDay
      });

      await _firestore.collection("groups").doc(groupId).update({
        "currnetEventId" : _docRef.id,
        "currentEventDue": event.to,

      });

      retVal = 'success';
    } catch (e){
      print (e);
    }
    return retVal;
  }

  Future<OurEvent> getCurrentEvent(String groupId, String eventId) async{
    OurEvent retVal = OurEvent();

    try{
      DocumentSnapshot _docSnapshot = await _firestore.collection("groups").doc(groupId).collection("event").doc(eventId).get();
      retVal.id = eventId;
      retVal.title = _docSnapshot["title"];
      retVal.description = _docSnapshot["description"];
      // retVal.from = _docSnapshot["from"];
      retVal.to = _docSnapshot["to"];
      retVal.isAllDay = _docSnapshot["isAllDay"];
    } catch (e){
      print (e);
    }
    return retVal;
  }
}