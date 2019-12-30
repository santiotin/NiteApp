import 'package:flutter/material.dart';
import 'package:niteapp/Models/User.dart';
import 'package:niteapp/Ui/UserProfilePage.dart';
import 'package:niteapp/Utils/Constants.dart';
import 'package:flutter/cupertino.dart';

class UserList extends StatefulWidget {

  final List<User> users;

  const UserList({Key key, @required this.users}) : super(key: key);

  @override
  _UserListState createState() => _UserListState();

}
class _UserListState extends State<UserList> {


  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: ListView.builder(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(
            parent: FixedExtentScrollPhysics(),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          scrollDirection: Axis.vertical,
          itemCount: widget.users.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () =>
                  Navigator.push(
                      context,
                      CupertinoPageRoute<Null>(
                        builder: (context) => UserProfilePage(uid: widget.users[index].id,),
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
                        widget.users[index].imageUrl,
                        width: MediaQuery.of(context).size.width * 0.16,
                        height: MediaQuery.of(context).size.width * 0.16,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Text(
                        widget.users[index].name,
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
          },
        )

    );
  }
}