import 'package:cloud_firestore/cloud_firestore.dart';

class Request {

  String id;
  String userId;
  String userName;
  String userImageUrl;
  Timestamp time;

  Request({
    this.id,
    this.userId,
    this.userName,
    this.userImageUrl,
    this.time,
  });
  

  Request.fromMap(Map<String, dynamic> mapData, String documentId) {
    this.id = documentId;
    this.userId = documentId;
    this.userName = mapData['userName'];
    this.userImageUrl = mapData['userImageUrl'];
    this.time = mapData['time'];
  }
}