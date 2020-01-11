import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:niteapp/Backend/repository.dart';
import 'package:niteapp/Models/Activity.dart';
import 'package:niteapp/Models/Request.dart';
import 'package:niteapp/Models/User.dart';
import 'package:niteapp/Ui/Lists/ActivityList.dart';
import 'package:niteapp/Ui/Lists/RequestList.dart';
import 'package:niteapp/Ui/Login/SignInPage.dart';
import 'package:niteapp/Utils/Messages.dart';
import 'package:niteapp/Utils/Constants.dart';

class NotificationsPage extends StatefulWidget {

  final Function createBadge;

  const NotificationsPage({Key key, this.createBadge}) : super(key: key);

  @override
  _NotificationsPageState createState() => _NotificationsPageState();

}

class _NotificationsPageState extends State<NotificationsPage> {

  var _repository = new Repository();
  FirebaseUser mUser;
  User user;
  Timestamp lastRequestTime;
  Timestamp lastActivityTime;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkAndGetCurrentUser();
  }

  bool detectChanges(int changes) {
    if(changes > 0) return true;
    else return false;
  }

  void checkAndGetCurrentUser() async {
    FirebaseUser currentUser = await _repository.getCurrentUser();
    if(currentUser != null ) {
      setState(() {
        mUser = currentUser;
      });
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute<Null>(
          builder: (context) => SignInPage(),
          settings: RouteSettings(name: 'SignInPage'),
        ),
            (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TabBar(
                tabs: [
                  Tab(
                      child: Text(
                        'Actividad',
                        style: TextStyle(
                            fontSize: 16,
                            color: Constants.main
                        ),
                      ),
                  ),
                  Tab(
                      child: Text(
                        'Solicitudes',
                        style: TextStyle(
                            fontSize: 16,
                            color: Constants.main
                        ),
                      ),
                  ),
                ],
              ),
            ],
          ),
          ),

        body: TabBarView(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: _repository.getActivity(mUser.uid),
              builder: (context, snapshot) {
                if(snapshot == null || snapshot.connectionState == ConnectionState.waiting || snapshot.data == null ) return LoadingView();
                else if(snapshot.hasError) return ErrorView();
                else if(snapshot.data.documents.isEmpty) return EmptyNotifications(msg: 'No hay actividad reciente',);
                else {

                  List<Activity> activities = new List<Activity>();
                  for(int i = 0; i < snapshot.data.documents.length; i++){
                    activities.add(Activity.fromMap(snapshot.data.documents[i].data, snapshot.data.documents[i].documentID));
                  }

                  if(activities.length > 0) {
                    print("lastTime: " + lastActivityTime.toString());
                    print("time: " + activities[0].time.toString());
                    if(lastActivityTime == null) lastActivityTime = activities[0].time;
                    else if(lastActivityTime != activities[0].time){
                      lastActivityTime = lastActivityTime = activities[0].time;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        widget.createBadge();
                      });
                    }
                  }

                  return ActivityList(activities: activities);
                }
              }
            ),
            StreamBuilder<QuerySnapshot>(
                stream: _repository.getRequests(mUser.uid),
                builder: (context, snapshot) {
                  if(snapshot == null || snapshot.connectionState == ConnectionState.waiting || snapshot.data == null ) return LoadingView();
                  else if(snapshot.hasError) return ErrorView();
                  else if(snapshot.data.documents.isEmpty) return EmptyNotifications(msg: 'No hay solicitudes',);
                  else {

                    List<Request> requests = new List<Request>();
                    for(int i = 0; i < snapshot.data.documents.length; i++){
                      requests.add(Request.fromMap(snapshot.data.documents[i].data, snapshot.data.documents[i].documentID));
                    }

                    if(requests.length > 0) {
                      if(lastRequestTime == null) lastRequestTime = requests[0].time;
                      else if(lastRequestTime != requests[0].time){
                        lastRequestTime = requests[0].time;
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          widget.createBadge();
                        });
                      }
                    }

                    return RequestList(requests: requests);
                  }
                }
            ),
          ],
        ),
      ),
    );
  }
}