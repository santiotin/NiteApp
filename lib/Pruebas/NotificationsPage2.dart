import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:niteapp/Backend/repository.dart';
import 'package:niteapp/Models/Activity.dart';
import 'package:niteapp/Models/Notif.dart';
import 'package:niteapp/Models/Request.dart';
import 'package:niteapp/Models/User.dart';
import 'package:niteapp/Ui/Lists/NotifList.dart';
import 'package:niteapp/Ui/Lists/RequestList.dart';
import 'package:niteapp/Ui/Login/SignInPage.dart';
import 'package:niteapp/Utils/AppLocalizations.dart';
import 'package:niteapp/Utils/Messages.dart';
import 'package:niteapp/Utils/Constants.dart';

class NotificationsPage2 extends StatefulWidget {

  final Function createBadge;

  const NotificationsPage2({Key key, this.createBadge}) : super(key: key);

  @override
  _NotificationsPage2State createState() => _NotificationsPage2State();

}

class _NotificationsPage2State extends State<NotificationsPage2> {

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
                      AppLocalizations.of(context).translate('activity'),
                      style: TextStyle(
                          fontSize: 16,
                          color: Constants.main
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      AppLocalizations.of(context).translate('requests'),
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
                  else if(snapshot.data.documents.isEmpty) return EmptyNotifications(msg: AppLocalizations.of(context).translate('noActivity'),);
                  else {

                    List<Notif> notifs = new List<Notif>();
                    for(int i = 0; i < snapshot.data.documents.length; i++){
                      notifs.add(Activity.fromMap(snapshot.data.documents[i].data, snapshot.data.documents[i].documentID));
                    }

                    if(notifs.length > 0) {
                      if(lastActivityTime == null) lastActivityTime = notifs[0].getTime();
                      else if(lastActivityTime != notifs[0].getTime()){
                        lastActivityTime = lastActivityTime = notifs[0].getTime();
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          widget.createBadge();
                        });
                      }
                    }

                    return NotifList(notifs: notifs);
                  }
                }
            ),
            StreamBuilder<QuerySnapshot>(
                stream: _repository.getRequests(mUser.uid),
                builder: (context, snapshot) {
                  if(snapshot == null || snapshot.connectionState == ConnectionState.waiting || snapshot.data == null ) return LoadingView();
                  else if(snapshot.hasError) return ErrorView();
                  else if(snapshot.data.documents.isEmpty) return EmptyNotifications(msg: AppLocalizations.of(context).translate('noRequests'),);
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