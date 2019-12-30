import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:niteapp/Backend/repository.dart';
import 'package:niteapp/Models/Event.dart';
import 'package:niteapp/Utils/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:niteapp/Utils/Messages.dart';

class BuyListPage extends StatefulWidget {

  final String eid;

  const BuyListPage({Key key, this.eid}) : super(key: key);

  @override
  _BuyListPageState createState() => _BuyListPageState();

}
class _BuyListPageState extends State<BuyListPage> {

  var _repository = new Repository();
  Event event;
  bool inList;

  void isInList() {
    _repository.isInList(widget.eid).then((value) {
      setState(() {
        inList = value;
      });
    });
  }
  void addToList() {
    _repository.addToList(event).then((value) {
      isInList();
    });
  }
  void deleteOfList() {
    _repository.deleteOfList(widget.eid).then((value) {
      isInList();
    });
  }

  String getTextOfRelation() {
    if(inList) return 'Desapuntarse';
    else return 'Apuntarse';
  }

  void onGoingBtnPressed(){
    if(inList)  deleteOfList();
    else addToList();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isInList();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: _repository.getEvent(widget.eid),
        builder: (context, snapshot) {
          if(snapshot == null || snapshot.data == null ) return LoadingView();
          else if(snapshot.hasError) return ErrorView();
          else {
            event = Event.fromMap(snapshot.data.data, snapshot.data.documentID);
            return Scaffold(
              appBar: AppBar(
                title: Text('Lista Nite'),
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: ListView(
                      physics: NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        //datos de la reserva
                        Padding(
                          padding: EdgeInsets.only(left: 30, top: 30),
                          child: Text(
                            'Datos de la reserva',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Constants.main,
                            ),
                          ),
                        ),
                        //evento
                        Padding(
                          padding: EdgeInsets.only(left: 30, top: 30),
                          child: Text(
                            'Evento',
                            style: TextStyle(
                              fontSize: 18,
                              color: Constants.main,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 30, top: 5),
                          child: Text(
                            event.name + " by " + event.clubName,
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
                            'Horario',
                            style: TextStyle(
                              fontSize: 18,
                              color: Constants.main,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 30, top: 5),
                          child: Text(
                            'El ' + event.day + '/' + event.month+ '/'+ event.year + " de " + event.startHour + ' a ' + event.endHour,
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
                            'Descripción',
                            style: TextStyle(
                              fontSize: 18,
                              color: Constants.main,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 30, top: 5),
                          child: Text(
                            event.listDescr,
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
                            'Precio',
                            style: TextStyle(
                              fontSize: 18,
                              color: Constants.main,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 30, top: 5),
                          child: Text(
                            'Gratis',
                            style: TextStyle(
                              fontSize: 14,
                              color: Constants.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if(inList != null)Container(
                    height: MediaQuery.of(context).size.height * 0.12,
                    width: MediaQuery.of(context).size.width,
                    child:FlatButton(
                        color: Constants.accent,
                        highlightColor: inList ? Constants.accent: Constants.white,
                        splashColor: inList ? Constants.accentLight : Constants.transparentWhite,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20.0),
                          child: Text(
                            getTextOfRelation(),
                            style: TextStyle(
                                color: Constants.white,
                                fontSize: 15.0,
                                fontFamily: "WorkSansBold"
                            ),
                          ),
                        ),
                        onPressed: () {
                          onGoingBtnPressed();
                        }
                    ),
                  ),
                ],
              ),
            );
          }

        }
    );
  }


}