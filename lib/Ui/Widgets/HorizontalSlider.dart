import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:niteapp/Models/Event.dart';
import 'package:niteapp/Ui/AssistantsPage.dart';
import 'package:niteapp/Ui/EventDetailsPage.dart';
import 'package:niteapp/Utils/Constants.dart';

class HorizontalSlider extends StatelessWidget {
  final List<Event> events;
  final String uid;
  bool showDay;

  HorizontalSlider({
    this.events,
    this.uid,
    this.showDay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: ListView.builder(
        shrinkWrap: false,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        scrollDirection: Axis.horizontal,
        itemCount: events.length,
        itemBuilder: (BuildContext context, int index) {
          Event event = events[index];
          String subTitle;
          if(showDay) subTitle = event.day + '/' + event.month + '/' + event.year;
          else subTitle = event.clubName;
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute<Null>(
                    builder: (context) => EventDetailsPage(eid: event.id, uid: uid,),
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
                          width: 40,
                          height: 40,
                          right: -0.5,
                          top: -0.5,
                          child: FlatButton(
                              color: Constants.white,
                              onPressed: (){
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute<Null>(
                                      builder: (context) => AssistantsPage(uid: uid, eid: event.id,),
                                      settings: RouteSettings(name: 'AssistantsPage'),
                                    )
                                );
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomLeft: Radius.circular(30))
                              ),
                              padding: EdgeInsets.all(0),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(5,0,0,2),
                                child: Icon(
                                  Icons.people_outline,
                                  color: Constants.accent,
                                  size: 15,
                                ),
                              )
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
                            subTitle,
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
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(
                                Icons.people,
                                size: 12,),
                              Padding(
                                padding: const EdgeInsets.only(left: 2.5),
                                child: Text(
                                  event.numAssists,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      color: Constants.grey
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

              ],
            ),
          );
        },
      ),
    );
  }
}

