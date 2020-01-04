import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:niteapp/Backend/repository.dart';
import 'package:niteapp/Models/User.dart';
import 'package:niteapp/Ui/FavoriteClubsPage.dart';
import 'package:niteapp/Ui/FriendsPage.dart';
import 'package:niteapp/Ui/Login/SignInPage.dart';
import 'package:niteapp/Ui/SettingsPage.dart';
import 'package:niteapp/Ui/MyEventsPage.dart';
import 'package:niteapp/Ui/Widgets/CircularImage.dart';
import 'package:niteapp/Utils/Constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:niteapp/Utils/Messages.dart';

class ProfilePage extends StatefulWidget {

  const ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();

}
class _ProfilePageState extends State<ProfilePage> {

  var _repository = new Repository();
  FirebaseUser mUser;
  User user;

  @override
  initState() {
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance
        .collection("users")
        .document(mUser.uid)
        .snapshots(),
      builder: (context, snapshot) {
        if(snapshot == null || snapshot.connectionState == ConnectionState.waiting || snapshot.data == null ) return LoadingView();
        if(snapshot.hasError) return ErrorView();
        user = User.fromMap(snapshot.data.data, snapshot.data.documentID);
        return Scaffold(
          body: ListView(
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              Container(
                color: Constants.white,
                height: MediaQuery.of(context).size.height * 0.27,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height * 0.15,
                      child: Center(
                        child: CircularImage(size: MediaQuery.of(context).size.height*0.15, image: user.imageUrl,),
                      ),
                    ),
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
                    Container(
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
                                'Eventos',
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
                    Container(
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
                                'Seguidores',
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
                    Container(
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
                                'Seguidos',
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
                  ],
                ),
              ),

              Container(
                margin: EdgeInsets.only(top: 10),
                height: 1,
                color: Constants.background,
              ),
              Container(
                color: Constants.white,
                height: MediaQuery.of(context).size.height * 0.10,
                child: RawMaterialButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute<Null>(
                        builder: (context) => MyEventsPage(uid: mUser.uid,),
                        settings: RouteSettings(name: 'MyEventsPage'),
                      ),
                    );
                  },
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.18,
                        alignment: Alignment(1, 0),
                        child: Icon(
                          Icons.event,
                          size: MediaQuery.of(context).size.height * 0.03,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        padding: EdgeInsets.only(left: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Mis eventos',
                              style: TextStyle(
                                  color: Constants.main,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16
                              ),
                            ),
                            Text(
                              'Eventos a los que vas a ir',
                              style: TextStyle(
                                  color: Constants.grey,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.18,
                        alignment: Alignment(0, 0),
                        child: Icon(
                          Icons.keyboard_arrow_right,
                          color: Constants.accent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Container(
                height: 1,
                color: Constants.background,
              ),
              Container(
                color: Constants.white,
                height: MediaQuery.of(context).size.height * 0.10,
                child: RawMaterialButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute<Null>(
                        builder: (context) => FavoriteClubsPage(uid: user.id),
                        settings: RouteSettings(name: 'FavoriteClubsPage'),
                      ),
                    );
                  },
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.18,
                        alignment: Alignment(1, 0),
                        child: Icon(
                          Icons.favorite_border,
                          size: MediaQuery.of(context).size.height * 0.03,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.60,
                        padding: EdgeInsets.only(left: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Mis clubs favoritos',
                              style: TextStyle(
                                  color: Constants.main,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16
                              ),
                            ),
                            Text(
                              'Clubs que te gustan más',
                              style: TextStyle(
                                  color: Constants.grey,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.18,
                        alignment: Alignment(0, 0),
                        child: Icon(
                          Icons.keyboard_arrow_right,
                          color: Constants.accent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Container(
                height: 1,
                color: Constants.background,
              ),
              Container(
                color: Constants.white,
                height: MediaQuery.of(context).size.height * 0.10,
                child: RawMaterialButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute<Null>(
                        builder: (context) => FriendsPage(uid: user.id),
                        settings: RouteSettings(name: 'FriendsPage'),
                      ),
                    );
                  },
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.18,
                        alignment: Alignment(1, 0),
                        child: Icon(
                          Icons.people_outline,
                          size: MediaQuery.of(context).size.height * 0.03,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.60,
                        padding: EdgeInsets.only(left: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Mis amigos',
                              style: TextStyle(
                                  color: Constants.main,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16
                              ),
                            ),
                            Text(
                              'Personas que te siguen y sigues',
                              style: TextStyle(
                                  color: Constants.grey,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.18,
                        alignment: Alignment(0, 0),
                        child: Icon(
                          Icons.keyboard_arrow_right,
                          color: Constants.accent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Container(
                height: 1,
                color: Constants.background,
              ),
              Container(
                color: Constants.white,
                height: MediaQuery.of(context).size.height * 0.10,
                child: RawMaterialButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute<Null>(
                        builder: (context) => SettingsPage(),
                        settings: RouteSettings(name: 'SettingsPage'),
                      ),
                    );
                  },
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.18,
                        alignment: Alignment(1, 0),
                        child: Icon(
                          Icons.settings,
                          size: MediaQuery.of(context).size.height * 0.03,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.60,
                        padding: EdgeInsets.only(left: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Ajustes',
                              style: TextStyle(
                                  color: Constants.main,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16
                              ),
                            ),
                            Text(
                              'Editar perfil, contacto, cuenta, ...',
                              style: TextStyle(
                                  color: Constants.grey,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.18,
                        alignment: Alignment(0, 0),
                        child: Icon(
                          Icons.keyboard_arrow_right,
                          color: Constants.accent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            ],
          ),
        );
      }
    );
  }
}