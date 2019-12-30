import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:niteapp/Backend/repository.dart';
import 'package:niteapp/Models/GoingEvent.dart';
import 'package:niteapp/Ui/SeeTicket.dart';
import 'package:niteapp/Utils/Messages.dart';
import 'package:niteapp/Utils/Constants.dart';
import 'package:niteapp/Ui/Widgets/timeline_node.dart';
import 'package:flutter/cupertino.dart';

class MyEventsPage extends StatefulWidget {

  final String uid;

  MyEventsPage({this.uid, Key key}) : super(key: key);

  _MyEventsPageState createState() => _MyEventsPageState();
}

class _MyEventsPageState extends State<MyEventsPage> {
  var _repository = new Repository();

  TimelineNodeStyle getTimeLineNodeStyle(int i, int total) {
    if(i == total) return TimelineNodeStyle(
        pointType: TimelineNodePointType.Circle,
        pointColor: Constants.main,
        lineType: TimelineNodeLineType.TopHalf,
        lineColor: Constants.main);

    if(i == 0 && i != total) return TimelineNodeStyle(
        pointType: TimelineNodePointType.Circle,
        pointColor: Constants.main,
        lineType: TimelineNodeLineType.BottomHalf,
        lineColor: Constants.main);

    if(i == 0 && i == total) return TimelineNodeStyle(
        pointType: TimelineNodePointType.Circle,
        pointColor: Constants.main,
        lineType: TimelineNodeLineType.None,
        lineColor: Constants.main);

    else return TimelineNodeStyle(
        pointType: TimelineNodePointType.Circle,
        pointColor: Constants.main,
        lineType: TimelineNodeLineType.Full,
        lineColor: Constants.main);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis eventos'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _repository.getGoingEvents(widget.uid),
        builder: (context, snapshot) {
          if(snapshot == null ||snapshot.connectionState == ConnectionState.waiting || snapshot.data == null) return LoadingView();
          else if(snapshot.hasError) return ErrorView();
          else if(snapshot.data.documents.isEmpty) return Center(child: EmptyTodayAndSearch(msg: "No asistes a ningun evento",));
          else return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              GoingEvent goingEvent = GoingEvent.fromMap(snapshot.data.documents[index].data, snapshot.data.documents[index].documentID);
              return TimelineNode(
                style: getTimeLineNodeStyle(index, snapshot.data.documents.length - 1),
                child: Padding(
                  padding: const EdgeInsets.only(top: 15.0, left: 5),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.48,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(goingEvent.day + '/' + goingEvent.month + '/' + goingEvent.year,
                            style: TextStyle(
                              fontSize: 12,
                            ),),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                  goingEvent.name,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Constants.main,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0, bottom: 20),
                              child: Text(
                                goingEvent.clubName,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Constants.grey
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.35,
                        child: RawMaterialButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute<Null>(
                                  builder: (context) => SeeTicketPage(uid: widget.uid, eid: goingEvent.id,),
                                  settings: RouteSettings(name: 'SeeTicketPage'),
                                )
                            );
                          },
                          child: Center(
                            child: Text(
                              'Ver entrada',
                              style: TextStyle(
                                fontSize: 14,
                                color: Constants.accent,
                              ),
                            ),
                          ),
                        )
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      ),
    );
  }
}