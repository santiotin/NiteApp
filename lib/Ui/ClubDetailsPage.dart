import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:niteapp/Backend/repository.dart';
import 'package:niteapp/Models/Club.dart';
import 'package:niteapp/Models/Event.dart';
import 'package:niteapp/Ui/Login/SignInPage.dart';
import 'package:niteapp/Ui/Widgets/HorizontalSlider.dart';
import 'package:niteapp/Utils/AppLocalizations.dart';
import 'package:niteapp/Utils/Messages.dart';
import 'package:niteapp/Utils/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class ClubDetailsPage extends StatefulWidget {
  final String cid;

  ClubDetailsPage({this.cid});

  @override
  _ClubDetailsPageState createState() => _ClubDetailsPageState();
}

class _ClubDetailsPageState extends State<ClubDetailsPage> {

  var _repository = new Repository();
  Club club;
  bool favoriteClub;
  FirebaseUser mUser;

  CameraPosition _initialPosition = CameraPosition(target: LatLng(26.8206, 30.8025));
  Completer<GoogleMapController> _controller = Completer();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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

  void isFavoriteClub() {
    _repository.isFavoriteClub(club.id).then((value) {
      setState(() {
        favoriteClub = value;
      });
    });
  }
  void addFavoriteClub() {
    _repository.addFavoriteClub(club.id).then((value) {
      isFavoriteClub();
    });
  }
  void deleteFavoriteClub() {
    _repository.deleteFavoriteClub(club.id).then((value) {
      isFavoriteClub();
    });
  }

  void iniCameraPosition() {
    _initialPosition = CameraPosition(target: LatLng(double.parse(club.latitude), double.parse(club.longitude)));
  }
  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void checkAndGetCurrentUser() async {
    FirebaseUser currentUser = await _repository.getCurrentUser();
    if(currentUser != null ) {
      setState(() {
        mUser = currentUser;
      });
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute<Null>(
          builder: (context) => SignInPage(),
          settings: RouteSettings(name: 'SignInPage'),
        ),
            (_) => false,
      );
    }
  }

  void _showDialogFavTheClub() {
    // flutter defined function
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(AppLocalizations.of(context).translate('favoriteClub')),
          content: RichText(
            text: new TextSpan(
              style: new TextStyle(
                color: Constants.main,
                fontSize: 16,
              ),
              children: <TextSpan>[
                if(favoriteClub)TextSpan(text: AppLocalizations.of(context).translate('wantDelete'))
                else TextSpan(text: AppLocalizations.of(context).translate('wantAdd')),
                TextSpan(text: club.name, style: new TextStyle(fontWeight: FontWeight.bold)),
                if(favoriteClub) TextSpan(text: AppLocalizations.of(context).translate('wantDeleteFavClub'))
                else TextSpan(text: AppLocalizations.of(context).translate('wantAddFavClub'))
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text(
                AppLocalizations.of(context).translate('cancel'),
                style: TextStyle(color: Constants.accent),
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
                style: TextStyle(color: Constants.accent),),
              onPressed: () {
                Navigator.of(context).pop();
                if(favoriteClub) deleteFavoriteClub();
                else addFavoriteClub();
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

  List<Event> documentsToEvents(List<DocumentSnapshot> documents) {
    List<Event> events = new List<Event>();
    for(int i = 0; i < documents.length; i++) {
      events.add(Event.fromMap(documents[i].data, documents[i].documentID));
    }
    return events;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkAndGetCurrentUser();
    if(club != null)isFavoriteClub();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: _repository.getClubStream(widget.cid),
        builder: (context, snapshot) {
          //falta waiting porque no funciona
          if(snapshot == null || snapshot.data == null) return LoadingView();
          else if(snapshot.hasError) return ErrorView();
          else {
            club = Club.fromMap(snapshot.data.data, snapshot.data.documentID);
            isFavoriteClub();
            iniCameraPosition();
            return Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                elevation: 0,
                title: Text(AppLocalizations.of(context).translate('club')),
              ),
              body: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (OverscrollIndicatorNotification overscroll) {
                  overscroll.disallowGlow();
                  return true;
                },
                child: ListView(
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
                                club.imageUrl,
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
                                    club.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 25.0, top: 10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Icon(
                                        Icons.star,
                                        color: Constants.main,
                                        size: 15,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5.0),
                                        child: Text(club.stars),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if(favoriteClub != null)Padding(
                            padding: const EdgeInsets.only(right: 25.0),
                            child:  FloatingActionButton(
                              onPressed: () {
                                // Add your onPressed code here!
                                _showDialogFavTheClub();
                              },
                              child: favoriteClub ? Icon(Icons.favorite, color: Constants.white,) : Icon(Icons.favorite_border, color: Constants.accent,),
                              backgroundColor: favoriteClub ? Constants.accent: Constants.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    //descr text
                    Padding(
                      padding: EdgeInsets.fromLTRB(25,25,25,0),
                      child: Text(
                        club.description,
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
                                      child: Text(club.address),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    //next events
                    Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: StreamBuilder<QuerySnapshot>(
                          stream: _repository.getClubEvents(widget.cid),
                          builder: (context, snapshot) {
                            if(snapshot == null || snapshot.data == null || snapshot.data.documents == null ) return LoadingView();
                            else if(snapshot.hasError) return ErrorView();
                            else if(snapshot.data.documents.isEmpty) return EmptyTodayAndSearch(msg: AppLocalizations.of(context).translate('noEventsForThisDay'),);
                            else return Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          AppLocalizations.of(context).translate('nextEvents'),
                                          style: TextStyle(
                                            color: Constants.main,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  HorizontalSlider(
                                    events: documentsToEvents(snapshot.data.documents),
                                    uid: mUser.uid,
                                    showDay: true,
                                  ),
                                ],
                              );
                          }
                      ),
                    ),
                    SizedBox(height: 20.0),

                  ],
                ),
              ),
            );
          }
        }
    );
  }


}