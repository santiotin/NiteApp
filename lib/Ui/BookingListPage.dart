import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:niteapp/Backend/repository.dart';
import 'package:niteapp/Models/Event.dart';
import 'package:niteapp/Utils/AppLocalizations.dart';
import 'package:niteapp/Utils/Constants.dart';
import 'package:niteapp/Utils/Messages.dart';
import 'package:flutter/services.dart';

class BookingListPage extends StatefulWidget {

  final Event event;
  final bool going;

  const BookingListPage({Key key, this.event, this.going}) : super(key: key);

  @override
  _BookingListPageState createState() => _BookingListPageState();

}
class _BookingListPageState extends State<BookingListPage> {

  var _repository = new Repository();
  bool inList;
  bool loading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  //Show snack bar message
  void showInSnackBar(String value) {
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontFamily: "Roboto"),
      ),
      backgroundColor: Constants.main,
      duration: Duration(seconds: 3),
    ));
  }
  void showAssistListMsg() {
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
                if(inList)TextSpan(text: AppLocalizations.of(context).translate('unJoinNiteList'))
                else TextSpan(text: AppLocalizations.of(context).translate('joinNiteList')),
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
                if(inList) deleteOfList();
                else addToList();
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


  void isInList() {
    _repository.isInList(widget.event.id).then((value) {
      setState(() {
        inList = value;
        loading = false;
      });
    });
  }
  void addToList() {
    setState(() {
      loading = true;
    });
    _repository.addToList(widget.event).then((value) {
      isInList();
    });
  }
  void deleteOfList() {
    setState(() {
      loading = true;
    });
    _repository.deleteOfList(widget.event.id).then((value) {
      isInList();
    });
  }

  String getTextOfRelation() {
    if(inList) return AppLocalizations.of(context).translate('unJoin');
    else return AppLocalizations.of(context).translate('join');
  }

  String getTextOfRelationState() {
    if(inList == null) return AppLocalizations.of(context).translate('???');
    else if(inList) return AppLocalizations.of(context).translate('joinedNiteList');
    else return AppLocalizations.of(context).translate('unJoinedNiteList');
  }

  void onGoingBtnPressed(){
    if(widget.going) showAssistListMsg();
    else showInSnackBar(AppLocalizations.of(context).translate('joinToConfirm'));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isInList();
  }

  @override
  Widget build(BuildContext context) {
    return widget.event.hasList ?
      Scaffold(
        key: _scaffoldKey,
        body: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            //evento
            Padding(
              padding: EdgeInsets.only(left: 30, top: 30),
              child: Text(
                AppLocalizations.of(context).translate('event'),
                style: TextStyle(
                  fontSize: 18,
                  color: Constants.main,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 30, top: 5),
              child: Text(
                widget.event.name + AppLocalizations.of(context).translate('by') + widget.event.clubName,
                style: TextStyle(
                  fontSize: 14,
                  color: Constants.grey,
                ),
              ),
            ),
            //horario
            Padding(
              padding: EdgeInsets.only(left: 30, top: 20),
              child: Text(
                AppLocalizations.of(context).translate('schedule'),
                style: TextStyle(
                  fontSize: 18,
                  color: Constants.main,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 30, top: 5),
              child: Text(
                AppLocalizations.of(context).translate('the') + widget.event.day + '/' + widget.event.month+ '/'+ widget.event.year + AppLocalizations.of(context).translate('from') + widget.event.startHour + AppLocalizations.of(context).translate('to') + widget.event.endHour,
                style: TextStyle(
                  fontSize: 14,
                  color: Constants.grey,
                ),
              ),
            ),
            //descr
            Padding(
              padding: EdgeInsets.only(left: 30, top: 20),
              child: Text(
                AppLocalizations.of(context).translate('description'),
                style: TextStyle(
                  fontSize: 18,
                  color: Constants.main,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 30, top: 5, right: 30),
              child: Text(
                widget.event.listDescription,
                style: TextStyle(
                  fontSize: 14,
                  color: Constants.grey,
                ),
              ),
            ),
            //Precio
            Padding(
              padding: EdgeInsets.only(left: 30, top: 20),
              child: Text(
                AppLocalizations.of(context).translate('price'),
                style: TextStyle(
                  fontSize: 18,
                  color: Constants.main,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 30, top: 5),
              child: Text(
                AppLocalizations.of(context).translate('free'),
                style: TextStyle(
                  fontSize: 14,
                  color: Constants.grey,
                ),
              ),
            ),
            //estado
            Padding(
              padding: EdgeInsets.only(left: 30, top: 20),
              child: Text(
                AppLocalizations.of(context).translate('state'),
                style: TextStyle(
                  fontSize: 18,
                  color: Constants.main,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 30, top: 5),
              child: Text(
                getTextOfRelationState(),
                style: TextStyle(
                  fontSize: 14,
                  color: Constants.grey,
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: inList != null ? FloatingActionButton.extended(
          backgroundColor: loading ? Constants.white : Constants.accent,
          onPressed: onGoingBtnPressed,
          label: loading ?
            Center(
              child: Container(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            ) :
            Text(
              getTextOfRelation(),
              style: TextStyle(
                color: Constants.white,
                fontSize: 15.0,
                fontFamily: "Roboto"
              ),
            ),
        ) : null,
      ) :
      EmptyNotifications(msg: AppLocalizations.of(context).translate('niteListNotAvailable'));
  }


}