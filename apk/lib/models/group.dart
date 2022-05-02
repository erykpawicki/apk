import 'package:cloud_firestore/cloud_firestore.dart';

class OurGroup{
  String? id;
  String? name;
  String? leader;
  List<String>? members;
  String? currentTaskId;
  Timestamp? currentTaskDue;
  String? currentEventId;

  OurGroup({
   this.id,
   this.name,
   this.leader,
   this.members,
   this.currentTaskId,
   this.currentTaskDue,
    this.currentEventId,
});
}