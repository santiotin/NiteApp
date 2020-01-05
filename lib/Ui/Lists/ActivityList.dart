import 'package:flutter/material.dart';
import 'package:niteapp/Models/Activity.dart';
import 'package:niteapp/Ui/EventDetailsPage.dart';
import 'package:niteapp/Ui/UserProfilePage.dart';
import 'package:niteapp/Ui/Widgets/CircularImage.dart';
import 'package:niteapp/Ui/Widgets/RoundedImage.dart';
import 'package:niteapp/Utils/Constants.dart';
import 'package:flutter/cupertino.dart';

class ActivityList extends StatefulWidget {

  final List<Activity> activities;

  const ActivityList({Key key, @required this.activities}) : super(key: key);

  @override
  _ActivityListState createState() => _ActivityListState();

}
class _ActivityListState extends State<ActivityList> {


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
          itemCount: widget.activities.length,
          itemBuilder: (BuildContext context, int index) {
            Activity activity = widget.activities[index];
            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () =>
                  Navigator.push(
                      context,
                      CupertinoPageRoute<Null>(
                        builder: (context) => UserProfilePage(uid: activity.userId,),
                        settings: RouteSettings(name: 'UserProfilePage'),
                      )
                  ),
              child: Container(
                padding: EdgeInsets.fromLTRB(5, 20, 10 , 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircularImage(size: MediaQuery.of(context).size.width * 0.16,image: activity.userImageUrl,),
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      width: MediaQuery.of(context).size.width * 0.50,
                      child: RichText(
                        text: new TextSpan(
                          style: new TextStyle(
                            color: Constants.main,
                            fontSize: 14,
                          ),
                          children: <TextSpan>[
                            TextSpan(text: activity.userName),
                            TextSpan(text: ' ha indicado que asistirá a '),
                            TextSpan(
                              text: activity.eventName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () =>
                          Navigator.push(
                              context,
                              CupertinoPageRoute<Null>(
                                builder: (context) => EventDetailsPage(eid: activity.eventId,),
                                settings: RouteSettings(name: 'EventDetailsPage'),
                              )
                          ),
                      child: RoundedImage(
                        size: MediaQuery.of(context).size.width * 0.16,
                        image: activity.eventImageUrl,
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