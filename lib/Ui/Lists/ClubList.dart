import 'package:flutter/material.dart';
import 'package:niteapp/Models/Club.dart';
import 'package:niteapp/Utils/Constants.dart';

class SearchClubList extends StatefulWidget {

  final List<Club> clubs;

  const SearchClubList({Key key, @required this.clubs}) : super(key: key);

  @override
  _SearchClubListState createState() => _SearchClubListState();

}
class _SearchClubListState extends State<SearchClubList> {


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
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 10 , 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: new BorderRadius.circular(MediaQuery.of(context).size.width * 0.10),
                      child: Image.network(
                        widget.clubs[index].imageUrl,
                        width: MediaQuery.of(context).size.width * 0.16,
                        height: MediaQuery.of(context).size.width * 0.16,
                        fit: BoxFit.cover,
                      ),
                    ),
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