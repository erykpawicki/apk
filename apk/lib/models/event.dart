import 'package:cloud_firestore/cloud_firestore.dart';

class OurEvent{
  String? id;
  String? title;
  String? description;
  // Timestamp? from;
  Timestamp? to;
  bool? isAllDay;


  OurEvent({
    this.id,
    this.title,
    this.description,
    // this.from,
    this.to,
    this.isAllDay = false,

  }
      );

}