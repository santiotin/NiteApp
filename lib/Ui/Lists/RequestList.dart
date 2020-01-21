import 'package:flutter/material.dart';
import 'package:niteapp/Models/Request.dart';
import 'package:niteapp/Ui/UserProfilePage.dart';
import 'package:niteapp/Ui/Widgets/CircularImage.dart';
import 'package:niteapp/Utils/AppLocalizations.dart';
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
                padding: const EdgeInsets.fromLTRB(15, 20, 0 , 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircularImage(size: MediaQuery.of(context).size.width * 0.16,image: request.userImageUrl,),
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
                              TextSpan(text: AppLocalizations.of(context).translate('startedFollowing')),
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