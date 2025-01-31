import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:niteapp/Models/FavoriteClub.dart';
import 'package:niteapp/Ui/ClubDetailsPage.dart';
import 'package:niteapp/Ui/Widgets/CircularImage.dart';
import 'package:niteapp/Utils/AppLocalizations.dart';
import 'package:niteapp/Utils/Constants.dart';
import 'package:flutter/services.dart';

class FavoriteClubList extends StatefulWidget {

  final List<FavoriteClub> favoriteClubs;
  final String uid;

  const FavoriteClubList({Key key, @required this.favoriteClubs, @required this.uid}) : super(key: key);

  @override
  _FavoriteClubListState createState() => _FavoriteClubListState();

}
class _FavoriteClubListState extends State<FavoriteClubList> {

  void deleteFavClub(String cid) {
    Firestore.instance
        .collection('users')
        .document(widget.uid)
        .collection('favoriteClubs')
        .document(cid)
        .delete();
  }

  void _showDialogAssistToEvent(String cid, String clubName) {
    // flutter defined function
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: null,
          content: RichText(
            text: new TextSpan(
              style: new TextStyle(
                color: Constants.main,
                fontSize: 16,
              ),
              children: <TextSpan>[
                TextSpan(text: AppLocalizations.of(context).translate('wantDelete')),
                TextSpan(text: clubName, style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: AppLocalizations.of(context).translate('wantDeleteFavClub')),
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text(
                AppLocalizations.of(context).translate('cancel'),
                style: TextStyle(
                  color: Constants.accent,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                  statusBarColor: Colors.white,
                ));
              },
            ),
            FlatButton(
              child: Text(
                AppLocalizations.of(context).translate('accept'),
                style: TextStyle(
                    color: Constants.accent,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                deleteFavClub(cid);
                SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                  statusBarColor: Colors.white,
                ));
              },
            ),
          ],
        );
      },
    );
  }


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
          itemCount: widget.favoriteClubs.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute<Null>(
                      builder: (context) => ClubDetailsPage(cid: widget.favoriteClubs[index].id,),
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
                    CircularImage(size: MediaQuery.of(context).size.width * 0.16,image: widget.favoriteClubs[index].imageUrl,),
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: Text(
                        widget.favoriteClubs[index].name,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Constants.main,
                            fontSize: 16
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 0.0),
                      child: IconButton(
                        icon: Icon(Icons.favorite),
                        color: Constants.main,
                        onPressed: () {
                          _showDialogAssistToEvent(widget.favoriteClubs[index].id, widget.favoriteClubs[index].name);
                        } ,
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