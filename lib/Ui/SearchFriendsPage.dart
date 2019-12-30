import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:niteapp/Backend/repository.dart';
import 'package:niteapp/Models/BasicUser.dart';
import 'package:niteapp/Ui/UserProfilePage.dart';
import 'package:niteapp/Utils/Messages.dart';
import 'package:niteapp/Utils/Constants.dart';
import 'package:flutter/cupertino.dart';

class SearchFriendsPage extends StatefulWidget {

  final List<BasicUser> basicUsers;
  final String uid;

  const SearchFriendsPage({Key key, @required this.basicUsers, @required this.uid}) : super(key: key);

  @override
  _SearchFriendsPageState createState() => _SearchFriendsPageState();

}
class _SearchFriendsPageState extends State<SearchFriendsPage> {

  var _repository = new Repository();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.white,
      appBar: AppBar(
        title: Text('Buscar Amigos'),
      ),
      body: Container(
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
                                    ClipRRect(
                                      borderRadius: new BorderRadius.circular(MediaQuery.of(context).size.width * 0.10),
                                      child: Image.network(
                                        basicUser.imageUrl,
                                        width: MediaQuery.of(context).size.width * 0.16,
                                        height: MediaQuery.of(context).size.width * 0.16,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
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

      ),
    );
  }
}