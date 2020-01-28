import 'package:flutter/material.dart';
import 'package:niteapp/Models/Event.dart';
import 'package:niteapp/Ui/EventDetailsPage.dart';
import 'package:niteapp/Ui/Widgets/CircularImage.dart';
import 'package:niteapp/Utils/Constants.dart';
import 'package:flutter/cupertino.dart';

class EventList extends StatefulWidget {

  final List<Event> events;

  const EventList({Key key, @required this.events}) : super(key: key);

  @override
  _EventListState createState() => _EventListState();

}
class _EventListState extends State<EventList> {


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
          itemCount: widget.events.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () =>
                  Navigator.push(
                      context,
                      CupertinoPageRoute<Null>(
                        builder: (context) => EventDetailsPage(eid: widget.events[index].id,),
                        settings: RouteSettings(name: 'EventDetailsPage'),
                      )
                  ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 10 , 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircularImage(size: MediaQuery.of(context).size.width * 0.16,image: widget.events[index].imageUrl,),
                    Container(
                      padding: const EdgeInsets.only(left: 25.0),
                      width: MediaQuery.of(context).size.width * 0.65,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.events[index].clubName +': ' + widget.events[index].name,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Constants.main,
                              fontSize: 16
                            ),
                          ),
                          Text(
                            widget.events[index].day + '/' + widget.events[index].month+ '/' + widget.events[index].year,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Constants.grey,
                              fontSize: 12
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        )

    );
  }
}