import 'package:flutter/material.dart';
import 'package:niteapp/Models/BasicUser.dart';
import 'package:niteapp/Ui/UserProfilePage.dart';
import 'package:niteapp/Utils/Constants.dart';
import 'package:flutter/cupertino.dart';

class BasicUserList extends StatefulWidget {

  final List<BasicUser> basicUsers;

  const BasicUserList({Key key, @required this.basicUsers}) : super(key: key);

  @override
  _BasicUserListState createState() => _BasicUserListState();

}
class _BasicUserListState extends State<BasicUserList> {


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
          itemCount: widget.basicUsers.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () =>
                  Navigator.push(
                      context,
                      CupertinoPageRoute<Null>(
                        builder: (context) => UserProfilePage(uid: widget.basicUsers[index].id,),
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
                        widget.basicUsers[index].imageUrl,
                        width: MediaQuery.of(context).size.width * 0.16,
                        height: MediaQuery.of(context).size.width * 0.16,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Text(
                        widget.basicUsers[index].name,
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