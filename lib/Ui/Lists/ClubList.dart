import 'package:flutter/material.dart';
import 'package:niteapp/Models/Club.dart';
import 'package:niteapp/Ui/ClubDetailsPage.dart';
import 'package:niteapp/Ui/Widgets/CircularImage.dart';
import 'package:niteapp/Utils/Constants.dart';
import 'package:flutter/cupertino.dart';

class ClubList extends StatefulWidget {

  final List<Club> clubs;

  const ClubList({Key key, @required this.clubs}) : super(key: key);

  @override
  _ClubListState createState() => _ClubListState();

}
class _ClubListState extends State<ClubList> {


  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView.builder(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(
            parent: FixedExtentScrollPhysics(),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          scrollDirection: Axis.vertical,
          itemCount: widget.clubs.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute<Null>(
                      builder: (context) => ClubDetailsPage(cid: widget.clubs[index].id,),
                      settings: RouteSettings(name: 'ClubDetailsPage'),
                    )
                );
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 10 , 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircularImage(size: MediaQuery.of(context).size.width * 0.16,image: widget.clubs[index].imageUrl,),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      padding: EdgeInsets.only(left: 25),
                      child: Text(
                        widget.clubs[index].name,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Constants.main,
                            fontSize: 16
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