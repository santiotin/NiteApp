import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:niteapp/Backend/repository.dart';
import 'package:niteapp/Models/User.dart';
import 'package:niteapp/Ui/FriendsPage.dart';
import 'package:niteapp/Ui/MyEventsPage.dart';
import 'package:niteapp/Ui/Widgets/CircularImage.dart';
import 'package:niteapp/Utils/AppLocalizations.dart';
import 'package:niteapp/Utils/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:niteapp/Utils/Messages.dart';

class UserProfilePage extends StatefulWidget {

  final String uid;

  const UserProfilePage({Key key, this.uid}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();

}
class _UserProfilePageState extends State<UserProfilePage> {

  var _repository = Repository();
  bool following;
  bool itsMe = true;

  User user;

  void unFollowUser() {
    _repository.unFollowUser(widget.uid).then((value) {
      isFollowing();
    });
  }
  void followUser() {
    _repository.followUser(user).then((value) {
      isFollowing();
    });
  }

  String getTextOfRelation() {
    if(following) return AppLocalizations.of(context).translate('following');
    else return AppLocalizations.of(context).translate('follow');
  }

  void onFollowBtnPressed(){
    if(following)  unFollowUser();
    else followUser();
  }

  void isFollowing() {
    _repository.isFollowing(widget.uid).then((value) {
      setState(() {
        following = value;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkIfItsMe();
    isFollowing();
  }

  void checkIfItsMe() {
    _repository.checkIfItsMe(widget.uid).then((value) {
      setState(() {
        itsMe = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: _repository.getUser(widget.uid),
        builder: (context, snapshot) {
          if(snapshot == null || snapshot.connectionState == ConnectionState.waiting || snapshot.data == null ) return LoadingView();
          else if (snapshot.hasError) return ErrorView();
          else {
            user = User.fromMap(snapshot.data.data, snapshot.data.documentID);
            return Profile();
          }
        }
    );
  }

  Widget Profile() {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('profile')),
      ),
      body: ListView(
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          Container(
            color: Constants.white,
            height: MediaQuery.of(context).size.height * 0.27,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                CircularImage(size: MediaQuery.of(context).size.height * 0.15,image: user.imageUrl,),
                Container(
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                  child: Column(
                    children: <Widget>[
                      Text(
                        user.name,
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 20,
                            color: Constants.main
                        ),
                      ),
                      Container(
                        height: 2,
                      ),
                      Text(
                        user.age + ' | ' + user.city,
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14,
                            color: Constants.grey
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            color: Constants.white,
            height: MediaQuery.of(context).size.height * 0.10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute<Null>(
                        builder: (context) => MyEventsPage(uid: widget.uid,),
                        settings: RouteSettings(name: 'MyEventsPage'),
                      ),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 5.0),
                            child: Text(
                              user.numEvents,
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Constants.main
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5.0),
                            child: Text(
                              AppLocalizations.of(context).translate('events'),
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                  color: Constants.main
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute<Null>(
                        builder: (context) => FriendsPage(uid: widget.uid, index: 0,),
                        settings: RouteSettings(name: 'FriendsPage'),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(0.0),
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 5.0),
                            child: Text(
                              user.numFollowers,
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Constants.main
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5.0),
                            child: Text(
                              AppLocalizations.of(context).translate('followers'),
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                  color: Constants.main
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute<Null>(
                        builder: (context) => FriendsPage(uid: widget.uid, index: 1,),
                        settings: RouteSettings(name: 'FriendsPage'),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(0.0),
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 5.0),
                            child: Text(
                              user.numFollowing,
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Constants.main
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5.0),
                            child: Text(
                              AppLocalizations.of(context).translate('following'),
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                  color: Constants.main
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if(!itsMe && following != null)Container(
            margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
            child:RawMaterialButton(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: following ? Constants.accent : Constants.accent)
                ),
                fillColor: following ? Constants.accent : Constants.white,
                highlightColor: following ? Constants.accent : Constants.white,
                splashColor: following ? Constants.accentLight : Constants.transparentWhite,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0),
                  child: Text(
                    getTextOfRelation(),
                    style: TextStyle(
                        color: following ? Constants.white : Constants.accent,
                        fontSize: 15.0,
                        fontFamily: "Roboto"
                    ),
                  ),
                ),
                onPressed: () {
                  onFollowBtnPressed();
                }
            ),
          ),
        ],
      ),
    );
  }


}