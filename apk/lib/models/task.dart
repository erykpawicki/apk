import 'package:cloud_firestore/cloud_firestore.dart';

class OurTask{
  String? id;
  String? name;
  String? length;
  Timestamp? dateCompleted;
  int? color;


  OurTask({
    this.id,
    this.name,
    this.length,
    this.dateCompleted,
    this.color,
}
);

}