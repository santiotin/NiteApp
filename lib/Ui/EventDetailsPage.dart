import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:niteapp/Backend/repository.dart';
import 'package:niteapp/Models/Event.dart';
import 'package:niteapp/Ui/AssistantsPage.dart';
import 'package:niteapp/Ui/BuyListPage.dart';
import 'package:niteapp/Ui/ContactsPage.dart';
import 'package:niteapp/Ui/GoogleMapsPage.dart';
import 'package:niteapp/Ui/TicketsWebView.dart';
import 'package:niteapp/Utils/Messages.dart';
import 'package:niteapp/Utils/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';


class EventDetailsPage extends StatefulWidget {
  final String eid;
  final String uid;

  EventDetailsPage({this.eid, this.uid});

  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {

  var _repository = new Repository();
  bool going = false;
  Event event;
  bool favoriteClub;


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
                          'Chicos +',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Constants.main,
                          ),
                        ),
                        Text(
                          event.ageM,
                          style: TextStyle(
                            fontSize: 14.0,
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
                          'Chicas +',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Constants.main,
                          ),
                        ),
                        Text(
                          event.ageF,
                          style: TextStyle(
                            fontSize: 14.0,
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
                'Edad',
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
                        fontSize: 14.0,
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
                        fontSize: 14.0,
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
                'Horario',
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
                        fontSize: 14.0,
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
                'Vestimenta',
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
                if(going)TextSpan(text: '¿Quieres dejar de asistir al evento?')
                else TextSpan(text: '¿Quieres asistir al evento?'),
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: new Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
                SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                  statusBarColor: Colors.white,
                ));
              },
            ),
            FlatButton(
              child: new Text("Aceptar"),
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
          title: Text('Club favorito'),
          content: RichText(
            text: new TextSpan(
              style: new TextStyle(
                color: Constants.main,
                fontSize: 16,
              ),
              children: <TextSpan>[
                if(favoriteClub)TextSpan(text: '¿Quieres borrar ')
                else TextSpan(text: '¿Quieres añadir '),
                TextSpan(text: event.clubName, style: new TextStyle(fontWeight: FontWeight.bold)),
                if(favoriteClub) TextSpan(text: ' de tu lista de clubs favoritos? ')
                else TextSpan(text: ' a tu lista de clubs favoritos? ')
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: new Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
                SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                  statusBarColor: Colors.white,
                ));
              },
            ),
            FlatButton(
              child: new Text("Aceptar"),
              onPressed: () {
                Navigator.of(context).pop();
                if(favoriteClub) deleteGoing();
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
          return Scaffold(
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
                if(favoriteClub != null)IconButton(
                  icon: favoriteClub ?
                  Icon(Icons.favorite, color: Constants.main,) :
                  Icon(Icons.favorite_border, color: Constants.main,),
                  onPressed: () {
                    _showDialogFavTheClub();
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
                                  event.clubName + ': ' + event.name,
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
                        Padding(
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
                          Hero(
                            tag: 'maps',
                            child: Image.asset(
                              'assets/images/googlemaps.png',
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover,
                            ),
                          ),

                          Positioned(
                            left: 20.0,
                            bottom: 15.0,
                            child: FlatButton(
                              color: Constants.white,
                              onPressed: (){},
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
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
                  if(event.hasList)Padding(
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
                            "Lista Nite",
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
                  if(event.hasList)Padding(
                    padding: EdgeInsets.fromLTRB(25, 15, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.65,
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
                                        'Precio: ',
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
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute<Null>(
                                      builder: (context) => ContactsPage(),
                                      settings: RouteSettings(name: 'ContactsPage'),
                                    )
                                );
                              },
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Constants.accent,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //title tickets
                  if(event.hasTicket)Padding(
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
                            "Entradas",
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
                  if(event.hasTicket)Padding(
                    padding: EdgeInsets.fromLTRB(25, 15, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.65,
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
                                        'Precio: ',
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
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute<Null>(
                                      builder: (context) => TicketWebView(),
                                      settings: RouteSettings(name: 'TicketWebView'),
                                    )
                                );
                              },
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Constants.accent,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //title vips
                  if(event.hasVip)Padding(
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
                            "VIP",
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
                  if(event.hasVip)Padding(
                    padding: EdgeInsets.fromLTRB(25, 15, 10, 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.65,
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
                                        'Precio: ',
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
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute<Null>(
                                      builder: (context) => GoogleMapsPage(),
                                      settings: RouteSettings(name: 'GoogleMapsPage'),
                                    )
                                );
                              },
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Constants.accent,
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



