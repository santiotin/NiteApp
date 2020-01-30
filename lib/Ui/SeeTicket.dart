import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:niteapp/Backend/repository.dart';
import 'package:niteapp/Models/Event.dart';
import 'package:niteapp/Utils/AppLocalizations.dart';
import 'package:niteapp/Utils/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:niteapp/Utils/Messages.dart';
import 'package:fw_ticket/fw_ticket.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SeeTicketPage extends StatefulWidget {

  final String uid;
  final String eid;
  final bool listWinner;

  const SeeTicketPage({Key key, @required this.uid, @required this.eid, @required this.listWinner}) : super(key: key);

  @override
  _SeeTicketPageState createState() => _SeeTicketPageState();

}
class _SeeTicketPageState extends State<SeeTicketPage> {

  var _repository = new Repository();
  Event event;

  CameraPosition _initialPosition = CameraPosition(target: LatLng(26.8206, 30.8025));
  Completer<GoogleMapController> _controller = Completer();

  void iniCameraPosition() {
    _initialPosition = CameraPosition(target: LatLng(double.parse(event.latitude), double.parse(event.longitude)));
  }
  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: _repository.getEvent(widget.eid),
        builder: (context, snapshot) {
          if(snapshot == null || snapshot.data == null || snapshot.connectionState == ConnectionState.waiting) return LoadingView();
          else if(snapshot.hasError) return ErrorView();
          else {
            event = Event.fromMap(snapshot.data.data, snapshot.data.documentID);
            iniCameraPosition();
            return Scaffold(
              appBar: AppBar(
                title: Text(AppLocalizations.of(context).translate('ticket')),
              ),
              body: Center(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Ticket(
                          innerRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0)
                          ),
                          outerRadius: BorderRadius.all(Radius.circular(10.0)),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 4.0),
                              blurRadius: 2.0,
                              spreadRadius: 2.0,
                              color: Color.fromRGBO(196, 196, 196, .76),
                            )
                          ],
                          child: GoogleMap(
                            onMapCreated: _onMapCreated,
                            initialCameraPosition: _initialPosition,
                            scrollGesturesEnabled: false,
                            zoomGesturesEnabled: false,
                            rotateGesturesEnabled: false,
                            minMaxZoomPreference: MinMaxZoomPreference(16,16),
                            myLocationButtonEnabled: false,
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        color: Constants.white,
                        child: Ticket(
                          innerRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0)
                          ),
                          outerRadius: BorderRadius.all(Radius.circular(10.0)),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 4),
                              blurRadius: 2.0,
                              spreadRadius: 2.0,
                              color: Color.fromRGBO(196, 196, 196, .76),
                            )
                          ],
                          child: Container(
                            color: Colors.white,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Center(
                                    child: Text(
                                      'Lista Nite: ' + event.name,
                                      style: TextStyle(fontSize: 18.0),
                                    ),
                                  ),
                                ),
                                Divider(height: 0.0),
                                Padding(
                                  padding: const EdgeInsets.only(top:10),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text('Fecha'),
                                              FittedBox(
                                                child: Text(
                                                  event.day + '/' + event.month,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 18.0),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text('Empieza'),
                                                FittedBox(
                                                  child: Text(
                                                    event.startHour,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 18.0),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )),
                                      Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text('Acaba'),
                                                FittedBox(
                                                  child: Text(
                                                    event.endHour,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 18.0),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.only(top: 20.0, left: 10, right: 10, bottom: 20),
                                  child: Center(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          event.listDescr,
                                          style: TextStyle(
                                              color: Constants.main,
                                              fontSize: 14.0,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 5.0),
                                          child: Text(
                                            AppLocalizations.of(context).translate('showThisTicket'),
                                            style: TextStyle(
                                              color: Constants.main,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: Center(
                                    child: QrImage(
                                      data: 'Nite list' + widget.uid + widget.eid,
                                      version: QrVersions.auto,
                                      size: 150.0,
                                      embeddedImage: AssetImage('assets/images/barcelonaWhite.png'),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  color: widget.listWinner ? Colors.amber : Constants.main,
                                  padding: EdgeInsets.symmetric(
                                      vertical: widget.listWinner ? 15.0 : 10.0,
                                      horizontal: 15.0),
                                  child: Center(
                                    child: Text(
                                      widget.listWinner ? AppLocalizations.of(context).translate('listWinner') : '',
                                      style: TextStyle(
                                         color: Constants.main,
                                         fontSize: 14
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
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