import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {

  String id;
  String eventClub;
  String eventId;
  String eventImageUrl;
  String eventName;
  String userId;
  String userName;
  String userImageUrl;
  Timestamp time;

  Activity({
    this.id,
    this.eventClub,
    this.eventId,
    this.eventImageUrl,
    this.eventName,
    this.userId,
    this.userName,
    this.userImageUrl,
    this.time,
  });


  Activity.fromMap(Map<String, dynamic> mapData, String documentId) {
    this.id = documentId;
    this.eventClub = mapData['eventClub'];
    this.eventId = mapData['eventId'];
    this.eventImageUrl = mapData['eventImageUrl'];
    this.eventName = mapData['eventName'];
    this.userId = mapData['userId'];
    this.userName = mapData['userName'];
    this.userImageUrl = mapData['userImageUrl'];
    this.time = mapData['time'];
  }
}