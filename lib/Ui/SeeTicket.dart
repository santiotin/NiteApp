import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:niteapp/Backend/repository.dart';
import 'package:niteapp/Models/Event.dart';
import 'package:niteapp/Utils/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:niteapp/Utils/Messages.dart';
import 'package:fw_ticket/fw_ticket.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SeeTicketPage extends StatefulWidget {

  final String uid;
  final String eid;

  const SeeTicketPage({Key key, @required this.uid, @required this.eid}) : super(key: key);

  @override
  _SeeTicketPageState createState() => _SeeTicketPageState();

}
class _SeeTicketPageState extends State<SeeTicketPage> {

  var _repository = new Repository();
  Event event;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: _repository.getEvent(widget.eid),
        builder: (context, snapshot) {
          if(snapshot == null || snapshot.data == null || snapshot.connectionState == ConnectionState.waiting) return LoadingView();
          else if(snapshot.hasError) return ErrorView();
          else {
            event = Event.fromMap(snapshot.data.data, snapshot.data.documentID);
            return Scaffold(
              appBar: AppBar(
                title: Text('Entrada'),
              ),
              body: Center(
                child: Container(
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        width: 300,
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
                          child: Image.asset(
                            'assets/images/googlemaps.png',
                          ),
                        ),
                      ),
                      Ticket(
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
                          width: 300,
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
                                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                  child: Text(
                                    event.listDescr,
                                    style:
                                    TextStyle(color: Constants.main, fontSize: 14.0),
                                  ),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(bottom: 10),
                                child: Center(
                                  child: QrImage(
                                    data: "1234567890",
                                    version: QrVersions.auto,
                                    size: 200.0,
                                    embeddedImage: AssetImage('assets/images/barcelonaWhite.png'),
                                  ),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                color: Constants.main,
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Center(
                                  child: Text(
                                    'BUY TICKETS',
                                    style:
                                    TextStyle(color: Constants.main, fontSize: 16.0),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }
        }
    );
  }


}