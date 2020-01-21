import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:niteapp/Backend/repository.dart';
import 'package:niteapp/Models/Event.dart';
import 'package:niteapp/Ui/AssistantsPage.dart';
import 'package:niteapp/Ui/BuyListPage.dart';
import 'package:niteapp/Ui/ClubDetailsPage.dart';
import 'package:niteapp/Ui/TicketsWebView.dart';
import 'package:niteapp/Utils/AppLocalizations.dart';
import 'package:niteapp/Utils/Messages.dart';
import 'package:niteapp/Utils/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class EventDetailsPage extends StatefulWidget {
  final String eid;
  final String uid;

  EventDetailsPage({this.eid, this.uid});

  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {

  var _repository = new Repository();
  bool going;
  Event event;
  bool favoriteClub;

  CameraPosition _initialPosition = CameraPosition(target: LatLng(26.8206, 30.8025));
  Completer<GoogleMapController> _controller = Completer();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Widget _AgeCard() {
    return Container(
      margin: EdgeInsets.all(5.0),
      width: 100.0,
      decoration: BoxDecoration(
          color: Constants.white,
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(
              color: Constants.background
          )
      ),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: FractionalOffset.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(Icons.remove_circle_outline,
                    size: 14,
                    color: Constants.main,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context).translate('boysPlus'),
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: Constants.main,
                          ),
                        ),
                        Text(
                          event.ageM,
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: Constants.main,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context).translate('girlsPlus'),
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: Constants.main,
                          ),
                        ),
                        Text(
                          event.ageF,
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: Constants.main,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: FractionalOffset.bottomLeft,
              child: Text(
                AppLocalizations.of(context).translate('age'),
                style: TextStyle(
                  fontSize: 12.0,
                  color: Constants.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _ScheduleCard() {
    return Container(
      margin: EdgeInsets.all(5.0),
      width: 100.0,
      decoration: BoxDecoration(
          color: Constants.white,
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(
              color: Constants.background
          )
      ),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: FractionalOffset.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(Icons.schedule,
                    size: 14,
                    color: Constants.main,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: Text(
                      event.day + '/' + event.month + '/' + event.year,
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: Constants.main,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: Text(
                      event.startHour + ' - ' + event.endHour,
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: Constants.main,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: FractionalOffset.bottomLeft,
              child: Text(
                AppLocalizations.of(context).translate('schedule'),
                style: TextStyle(
                  fontSize: 12.0,
                  color: Constants.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _DressCodeCard() {
    return Container(
      margin: EdgeInsets.all(5.0),
      width: 100.0,
      decoration: BoxDecoration(
          color: Constants.white,
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(
              color: Constants.background
          )
      ),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: FractionalOffset.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(Icons.person_outline,
                    size: 14,
                    color: Constants.main,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: Text(
                      event.dressCode,
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: FractionalOffset.bottomLeft,
              child: Text(
                AppLocalizations.of(context).translate('dressCode'),
                style: TextStyle(
                  fontSize: 12.0,
                  color: Constants.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  String music (List<dynamic> musicTypes) {
    String total = '';
    for(int i = 0; i < musicTypes.length; i++) {
      String aux = musicTypes[i];
      if(i == 0) {
        aux = capitalize(aux) + ', ';
      }
      else if(i != musicTypes.length -1) {
        aux = aux.toLowerCase() + ', ';
      }else {
        aux = aux.toLowerCase();
      }
      total = total + aux;
    }
    return total;
  }

  void isGoing() {
    _repository.isGoing(widget.eid).then((value) {
      setState(() {
        going = value;
      });
    });
  }
  void addGoing() {
    _repository.addGoingEvent(event).then((value) {
      isGoing();
    });
  }
  void deleteGoing() {
    _repository.deleteGoingEvent(event.id).then((value) {
      isGoing();
    });
  }

  void isFavoriteClub() {
    _repository.isFavoriteClub(event.clubId).then((value) {
      setState(() {
        favoriteClub = value;
      });
    });
  }
  void addFavoriteClub() {
    _repository.addFavoriteClub(event.clubId).then((value) {
      isFavoriteClub();
    });
  }
  void deleteFavoriteClub() {
    _repository.deleteFavoriteClub(event.clubId).then((value) {
      isFavoriteClub();
    });
  }

  void iniCameraPosition() {
    _initialPosition = CameraPosition(target: LatLng(double.parse(event.latitude), double.parse(event.longitude)));
  }
  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isGoing();
    if(event != null)isFavoriteClub();
  }

  void _showDialogAssistToEvent() {
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
                if(going)TextSpan(text: AppLocalizations.of(context).translate('unAssistEvent'))
                else TextSpan(text: AppLocalizations.of(context).translate('assistEvent')),
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
                if(going) deleteGoing();
                else addGoing();
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
      backgroundColor: Constants.accent,
      duration: Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _repository.getEvent(widget.eid),
      builder: (context, snapshot) {
        //falta waiting porque no funciona
        if(snapshot == null || snapshot.data == null) return LoadingView();
        else if(snapshot.hasError) return ErrorView();
        else {
          event = Event.fromMap(snapshot.data.data, snapshot.data.documentID);
          isFavoriteClub();
          iniCameraPosition();
          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              elevation: 0,
              title: Text(event.clubName),
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.people,
                    color: Constants.main,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute<Null>(
                          builder: (context) => AssistantsPage(eid: widget.eid, uid: widget.uid,),
                          settings: RouteSettings(name: 'AssistantsPage'),
                        )
                    );
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.business,
                    color: Constants.main,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute<Null>(
                          builder: (context) => ClubDetailsPage(cid: event.clubId,),
                          settings: RouteSettings(name: 'ClubDetailsPage'),
                        )
                    );
                  },
                ),
                SizedBox(
                  width: 15,
                )
              ],
            ),
            body: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (OverscrollIndicatorNotification overscroll) {
                overscroll.disallowGlow();
                return true;
              },
              child: ListView(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(
                  parent: FixedExtentScrollPhysics(),
                ),
                children: <Widget>[
                  //photo
                  Padding(
                    padding: EdgeInsets.fromLTRB(25,10,25,0),
                    child: Container(
                      height: 240,
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        children: <Widget>[
                          Center(
                            child: CircularProgressIndicator(),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              event.imageUrl,
                              height: 240,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //title
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,30,0,0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.72,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 25),
                                child: Text(
                                  event.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 25),
                                child: Text(
                                  music(event.musicType),
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      color: Constants.accent
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 25.0, top: 10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.people,
                                      color: Constants.main,
                                      size: 15,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: Text(event.numAssists),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if(going != null)Padding(
                          padding: const EdgeInsets.only(right: 25.0),
                          child:  FloatingActionButton(
                            onPressed: () {
                              // Add your onPressed code here!
                              _showDialogAssistToEvent();
                            },
                            child: going ? Icon(Icons.check, color: Constants.white,) : Icon(Icons.add, color: Constants.accent,),
                            backgroundColor: going ? Constants.accent: Constants.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  //boxes
                  Padding(
                    padding: EdgeInsets.fromLTRB(10,20,10,0),
                    child: Container(
                      height: 120.0,
                      child: Row(
                        children: <Widget>[
                          Expanded(child: _ScheduleCard()),
                          Expanded(child: _DressCodeCard()),
                          Expanded(child: _AgeCard()),


                        ],
                      ),
                    ),
                  ),
                  //descr text
                  Padding(
                    padding: EdgeInsets.fromLTRB(25,25,25,0),
                    child: Text(
                      event.description,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  //localization
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,40,0,0),
                    child: Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        children: <Widget>[
                          GoogleMap(
                            onMapCreated: _onMapCreated,
                            initialCameraPosition: _initialPosition,
                            scrollGesturesEnabled: false,
                            zoomGesturesEnabled: false,
                            rotateGesturesEnabled: false,
                            minMaxZoomPreference: MinMaxZoomPreference(15,15),
                            myLocationButtonEnabled: false,
                          ),
                          Positioned(
                            left: 5.0,
                            bottom: 5.0,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Constants.white,
                              ),
                              padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.location_on,
                                    color: Constants.main,
                                    size: 15,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: Text(event.address),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  //title nite list
                  Padding(
                    padding: EdgeInsets.fromLTRB(25,40,0,0),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.content_paste,
                          color: Constants.main,
                          size: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            AppLocalizations.of(context).translate('niteList'),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //descr, price list
                  Padding(
                    padding: EdgeInsets.fromLTRB(25, 15, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.62,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                event.listDescr,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              //price vips
                              Padding(
                                  padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        AppLocalizations.of(context).translate('priceDoubleDots'),
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      Text(
                                        event.listPrice,
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Constants.accent,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      Text(
                                        '€',
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Constants.accent,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  )
                              ),],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 0.0),
                          child: Center(
                            child: FlatButton(
                              color: Constants.white,
                              onPressed: (){
                                if(event.hasList){
                                  if(going) {
                                    Navigator.push(
                                        context,
                                        CupertinoPageRoute<Null>(
                                          builder: (context) => BuyListPage(eid: event.id,),
                                          settings: RouteSettings(name: 'BuyListPage'),
                                        )
                                    );
                                  } else {
                                    showInSnackBar(AppLocalizations.of(context).translate('joinToConfirm'));
                                  }
                                } else {
                                  showInSnackBar(AppLocalizations.of(context).translate('niteListNotAvailable'));
                                }
                              },
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: event.hasList ? Constants.accent : Constants.grey,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //title tickets
                  Padding(
                      padding: EdgeInsets.fromLTRB(25,40,0,0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.ticketAlt,
                            color: Constants.main,
                            size: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              AppLocalizations.of(context).translate('tickets'),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  //descr, price ticket
                  Padding(
                    padding: EdgeInsets.fromLTRB(25, 15, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.62,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                event.ticketDescr,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              //price vips
                              Padding(
                                  padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        AppLocalizations.of(context).translate('priceDoubleDots'),
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      Text(
                                        event.ticketPrice,
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Constants.accent,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      Text(
                                        '€',
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Constants.accent,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  )
                              ),],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 0.0),
                          child: Center(
                            child: FlatButton(
                              color: Constants.white,
                              onPressed: (){
                                if(event.hasTicket){
                                  if(going){
                                    Navigator.push(
                                        context,
                                        CupertinoPageRoute<Null>(
                                          builder: (context) => TicketWebView(),
                                          settings: RouteSettings(name: 'TicketWebView'),
                                        )
                                    );
                                  }else {
                                    showInSnackBar(AppLocalizations.of(context).translate('joinToBuy'));
                                  }
                                } else {
                                  showInSnackBar(AppLocalizations.of(context).translate('buyNotAvailable'),);
                                }
                              },
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: event.hasTicket ? Constants.accent : Constants.grey,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //title vips
                  Padding(
                    padding: EdgeInsets.fromLTRB(25,40,0,0),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.weekend,
                          color: Constants.main,
                          size: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            AppLocalizations.of(context).translate('vip'),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //descr, price vips
                  Padding(
                    padding: EdgeInsets.fromLTRB(25, 15, 0, 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.62,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                event.vipDescr,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              //price vips
                              Padding(
                                  padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        AppLocalizations.of(context).translate('priceDoubleDots'),
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      Text(
                                        event.vipPrice,
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Constants.accent,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      Text(
                                        '€',
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Constants.accent,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  )
                              ),],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 0.0),
                          child: Center(
                            child: FlatButton(
                              color: Constants.white,
                              onPressed: (){
                                showInSnackBar(AppLocalizations.of(context).translate('soonDots'));
                              },
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: event.hasVip ? Constants.accent : Constants.grey,
                                size: 20,
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
      }
    );
  }


}



