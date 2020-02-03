import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:niteapp/Backend/repository.dart';
import 'package:niteapp/Models/Event.dart';
import 'package:niteapp/Ui/AssistantsPage.dart';
import 'package:niteapp/Ui/EventDetailsPage.dart';
import 'package:niteapp/Utils/Messages.dart';
import 'package:niteapp/Utils/Constants.dart';

class HorizontalSliderFavorites extends StatefulWidget {

  final List<Event> events;
  final String uid;

  const HorizontalSliderFavorites({Key key, @required this.events, @required this.uid}) : super(key: key);

  @override
  _HorizontalSliderFavoritesState createState() => _HorizontalSliderFavoritesState();
}

class _HorizontalSliderFavoritesState extends State<HorizontalSliderFavorites> {

  var _repository = new Repository();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Stack(
        children: <Widget>[
          EmptyFavoriteEvents(msg: 'Empty',),
          ListView.builder(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            scrollDirection: Axis.horizontal,
            itemCount: widget.events.length,
            itemBuilder: (BuildContext context, int index) {
              Event event = widget.events[index];
              return StreamBuilder<DocumentSnapshot>(
                  stream: _repository.getFavoriteClub(widget.uid, event.clubId),
                  builder: (context, snapshot) {
                    if(snapshot == null || snapshot.hasError || snapshot.data == null || !snapshot.data.exists) return Container();
                    else return Container(
                        color: Constants.white,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute<Null>(
                                  builder: (context) => EventDetailsPage(eid: event.id, uid: widget.uid,),
                                  settings: RouteSettings(name: 'EventDetailsPage'),
                                )
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  width: 150,
                                  height: 200,
                                  margin: EdgeInsets.fromLTRB(10.0,20.0,10.0,10.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black54,
                                        offset: Offset(4, 2),
                                        spreadRadius: -4,
                                        blurRadius: 8.0,
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    children: <Widget>[
                                      Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10.0),
                                        child: Image.network(
                                          event.imageUrl,
                                          height: 190,
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                      Positioned(
                                        height: 40,
                                        right: -0.5,
                                        top: -0.5,
                                        child: FlatButton(
                                            color: Constants.white,
                                            onPressed: (){
                                              Navigator.push(
                                                  context,
                                                  CupertinoPageRoute<Null>(
                                                    builder: (context) => AssistantsPage(uid: widget.uid, eid: event.id,),
                                                    settings: RouteSettings(name: 'AssistantsPage'),
                                                  )
                                              );
                                            },
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomLeft: Radius.circular(30))
                                            ),
                                            padding: EdgeInsets.all(0),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Icon(
                                                  Icons.people_outline,
                                                  size: 15,
                                                  color: Constants.accent,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 2.5),
                                                  child: Text(
                                                    event.numAssists,
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.normal,
                                                        color: Constants.accent
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                        ),
                                      ),
                                    ],
                                  )
                              ),
                              //title
                              Container(
                                height: 70,
                                width: 170,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                                        child: Text(
                                          event.name,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                                        child: Text(
                                          event.clubName,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal,
                                              color: Constants.grey
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                      );
                  }
              );
            },
          ),
        ],
      )
    );
  }
}

