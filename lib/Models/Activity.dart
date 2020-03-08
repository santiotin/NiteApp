import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:niteapp/Models/Notif.dart';
import 'package:flutter/cupertino.dart';
import 'package:niteapp/Ui/Widgets/CircularImage.dart';
import 'package:niteapp/Ui/Widgets/RoundedImage.dart';
import 'package:niteapp/Utils/Constants.dart';
import 'package:niteapp/Utils/AppLocalizations.dart';
import 'package:niteapp/Ui/EventDetailsPage.dart';
import 'package:niteapp/Ui/UserProfilePage.dart';

class Activity extends Notif{

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

  Timestamp getTime() {
    return time;
  }

  Widget print(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () =>
          Navigator.push(
              context,
              CupertinoPageRoute<Null>(
                builder: (context) => UserProfilePage(uid: userId,),
                settings: RouteSettings(name: 'UserProfilePage'),
              )
          ),
      child: Container(
        padding: EdgeInsets.fromLTRB(5, 20, 10 , 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircularImage(size: MediaQuery.of(context).size.width * 0.16,image: userImageUrl,),
            Container(
              padding: EdgeInsets.only(left: 10),
              width: MediaQuery.of(context).size.width * 0.50,
              child: RichText(
                text: new TextSpan(
                  style: new TextStyle(
                    color: Constants.main,
                    fontSize: 14,
                  ),
                  children: <TextSpan>[
                    TextSpan(text: userName),
                    TextSpan(text: AppLocalizations.of(context).translate('startedGoing')),
                    TextSpan(
                      text: eventName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () =>
                  Navigator.push(
                      context,
                      CupertinoPageRoute<Null>(
                        builder: (context) => EventDetailsPage(eid: eventId,),
                        settings: RouteSettings(name: 'EventDetailsPage'),
                      )
                  ),
              child: RoundedImage(
                size: MediaQuery.of(context).size.width * 0.16,
                image: eventImageUrl,
              ),
            ),
          ],
        ),
      ),
    );
  }
}