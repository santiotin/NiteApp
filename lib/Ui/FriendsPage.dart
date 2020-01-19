import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:niteapp/Backend/repository.dart';
import 'package:niteapp/Models/BasicUser.dart';
import 'package:niteapp/Ui/Lists/BasicUserList.dart';
import 'package:niteapp/Utils/AppLocalizations.dart';
import 'package:niteapp/Utils/Constants.dart';
import 'package:niteapp/Utils/Messages.dart';

class FriendsPage extends StatefulWidget {
  final String uid;
  final int index;

  const FriendsPage({Key key, this.uid, this.index}) : super(key: key);

  _FriendsPageState createState() => _FriendsPageState();
}


class _FriendsPageState  extends State<FriendsPage> with SingleTickerProviderStateMixin{

  var _repository = new Repository();
  TabController tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = new TabController(length: 2, vsync: this);
    tabController.index = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context).translate('friends'),
            style: TextStyle(
              color: Constants.main,
            ),
          ),
          bottom: TabBar(
            controller: tabController,
            tabs: [
              Tab(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                    child: Text(
                      AppLocalizations.of(context).translate('followers'),
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
                      AppLocalizations.of(context).translate('following'),
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
        body: TabBarView(
          controller: tabController,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: _repository.getFollowers(widget.uid),
              builder: (context, snapshot) {
                if(snapshot == null ||snapshot.connectionState == ConnectionState.waiting || snapshot.data == null) return LoadingView();
                else if(snapshot.hasError) return ErrorView();
                else if(snapshot.data.documents.isEmpty) return EmptyFriends(msg: AppLocalizations.of(context).translate('notFollowed'),);
                else return BasicUserList(basicUsers: documentsToBasicUsers(snapshot.data.documents));
              }
            ),
            StreamBuilder<QuerySnapshot>(
              stream: _repository.getFollowings(widget.uid),
              builder: (context, snapshot) {
                if (snapshot == null || snapshot.connectionState == ConnectionState.waiting || snapshot.data == null) return LoadingView();
                else if (snapshot.hasError) return ErrorView();
                else if (snapshot.data.documents.isEmpty) return EmptyFriends(msg: AppLocalizations.of(context).translate('notFollowing'),);
                else return BasicUserList(basicUsers: documentsToBasicUsers(snapshot.data.documents));
              }
            ),
          ],
        ),
      ),
    );
  }

  List<BasicUser> documentsToBasicUsers(List<DocumentSnapshot> documents) {
    List<BasicUser> basicUsers = new List<BasicUser>();
    for(int i = 0; i < documents.length; i++) {
      basicUsers.add(BasicUser.fromMap(documents[i].data, documents[i].documentID));
    }
    return basicUsers;
  }
}