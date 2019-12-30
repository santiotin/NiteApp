import 'package:flutter/material.dart';
import 'package:niteapp/Models/Request.dart';
import 'package:niteapp/Ui/UserProfilePage.dart';
import 'package:niteapp/Utils/Constants.dart';
import 'package:flutter/cupertino.dart';

class RequestList extends StatefulWidget {

  final List<Request> requests;

  const RequestList({Key key, @required this.requests}) : super(key: key);

  @override
  _RequestListState createState() => _RequestListState();

}
class _RequestListState extends State<RequestList> {

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
          itemCount: widget.requests.length,
          itemBuilder: (BuildContext context, int index) {
            Request request = widget.requests[index];
            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () =>
                  Navigator.push(
                      context,
                      CupertinoPageRoute<Null>(
                        builder: (context) => UserProfilePage(uid: request.userId,),
                        settings: RouteSettings(name: 'UserProfilePage'),
                      )
                  ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 20, 10 , 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: new BorderRadius.circular(MediaQuery.of(context).size.width * 0.10),
                      child: Image.network(
                        request.userImageUrl,
                        width: MediaQuery.of(context).size.width * 0.16,
                        height: MediaQuery.of(context).size.width * 0.16,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.70,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: RichText(
                          text: new TextSpan(
                            style: new TextStyle(
                              color: Constants.main,
                              fontSize: 14,
                            ),
                            children: <TextSpan>[
                              TextSpan(text: request.userName, style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: ' ha empezado a seguirte'),
                            ],
                          ),
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