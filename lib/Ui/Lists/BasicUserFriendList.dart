import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:niteapp/Backend/repository.dart';
import 'package:niteapp/Models/BasicUser.dart';
import 'package:niteapp/Ui/UserProfilePage.dart';
import 'package:niteapp/Ui/Widgets/CircularImage.dart';
import 'package:niteapp/Utils/Messages.dart';
import 'package:niteapp/Utils/Constants.dart';
import 'package:flutter/cupertino.dart';

class BasicUserFriendList extends StatefulWidget {

  final List<BasicUser> basicUsers;
  final String uid;

  const BasicUserFriendList({Key key, @required this.basicUsers, @required this.uid}) : super(key: key);

  @override
  _BasicUserFriendListState createState() => _BasicUserFriendListState();

}
class _BasicUserFriendListState extends State<BasicUserFriendList> {

  var _repository = new Repository();

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            EmptyFriends(msg: 'No tienes amigos que asistan a este evento',),
            Container(
              color: Constants.white,
              child: ListView.builder(
                physics: BouncingScrollPhysics(
                  parent: FixedExtentScrollPhysics(),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 10.0,
                ),
                scrollDirection: Axis.vertical,
                itemCount: widget.basicUsers.length,
                itemBuilder: (BuildContext context, int index) {
                  BasicUser basicUser = widget.basicUsers[index];
                  return StreamBuilder<DocumentSnapshot>(
                      stream: _repository.getFollowing(widget.uid, basicUser.id),
                      builder: (context, snapshot) {
                        if(snapshot == null || snapshot.hasError || snapshot.data == null || !snapshot.data.exists) return Container();
                        else
                          return GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () =>
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute<Null>(
                                      builder: (context) => UserProfilePage(uid: basicUser.id,),
                                      settings: RouteSettings(name: 'UserProfilePage'),
                                    )
                                ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 20, 10 , 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  CircularImage(size: MediaQuery.of(context).size.width * 0.16,image: basicUser.imageUrl,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 25.0),
                                    child: Text(
                                      basicUser.name,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Constants.main
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                      }
                  );
                },
              ),
            )
          ],
        )

    );
  }
}