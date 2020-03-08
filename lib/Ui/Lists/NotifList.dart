import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:niteapp/Models/Notif.dart';

class NotifList extends StatefulWidget {

  final List<Notif> notifs;

  const NotifList({Key key, @required this.notifs}) : super(key: key);

  @override
  _NotifListState createState() => _NotifListState();

}
class _NotifListState extends State<NotifList> {


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
          itemCount: widget.notifs.length,
          itemBuilder: (BuildContext context, int index) {
            Notif notif = widget.notifs[index];
            return notif.print(context);
          },
        )

    );
  }
}