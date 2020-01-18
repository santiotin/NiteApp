import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:niteapp/Backend/repository.dart';
import 'package:niteapp/Models/BasicUser.dart';
import 'package:niteapp/Ui/Lists/BasicUserFriendList.dart';
import 'package:niteapp/Ui/Lists/BasicUserList.dart';
import 'package:niteapp/Ui/Login/SignInPage.dart';
import 'package:niteapp/Utils/AppLocalizations.dart';
import 'package:niteapp/Utils/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:niteapp/Utils/Messages.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AssistantsPage extends StatefulWidget {

  final String eid, uid;

  const AssistantsPage({Key key, this.eid, this.uid}) : super(key: key);

  @override
  _AssistantsPageState createState() => _AssistantsPageState();

}

class _AssistantsPageState extends State<AssistantsPage> {

  var _repository = new Repository();

  List<DocumentSnapshot> result = new List<DocumentSnapshot>();

  bool isLoading = true;

  FirebaseUser mUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkAndGetCurrentUser();
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

  List<BasicUser> documentsToBasicUsers(List<DocumentSnapshot> documents) {
    List<BasicUser> basicUsers = new List<BasicUser>();
    for(int i = 0; i < documents.length; i++) {
      basicUsers.add(BasicUser.fromMap(documents[i].data, documents[i].documentID));
    }
    return basicUsers;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context).translate('assistants'),
            style: TextStyle(
              color: Constants.main,
            ),
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                    child: Text(
                      AppLocalizations.of(context).translate('all'),
                      style: TextStyle(
                          fontSize: 16,
                          color: Constants.main
                      ),
                    ),
                  )
              ),
              Tab(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                    child: Text(
                      AppLocalizations.of(context).translate('friends'),
                      style: TextStyle(
                          fontSize: 16,
                          color: Constants.main
                      ),
                    ),
                  )
              ),
            ],
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _repository.getGoingUsers(widget.eid),
          builder: (context, snapshot) {
            if(snapshot.hasError) return TabBarView(
              children: <Widget>[
                ErrorView(),
                ErrorView(),
              ],
            );
            else if(snapshot.connectionState == ConnectionState.waiting) return TabBarView(
              children: <Widget>[
                LoadingView(),
                LoadingView(),
              ],
            );
            else if(snapshot.data.documents.isEmpty) return TabBarView(
              children: <Widget>[
                EmptyFriends(msg: AppLocalizations.of(context).translate('noAssistants'),),
                EmptyFriends(msg: AppLocalizations.of(context).translate('noAssistants'),),
              ],
            );
            else return TabBarView(
                children: <Widget>[
                  BasicUserList(basicUsers: documentsToBasicUsers(snapshot.data.documents)),
                  if(mUser == null) BasicUserFriendList(uid: " ", basicUsers: documentsToBasicUsers(snapshot.data.documents),)
                  else BasicUserFriendList(uid: mUser.uid, basicUsers: documentsToBasicUsers(snapshot.data.documents),)
                ],
              );
          }
        ),
      ),
    );
  }
}