import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:niteapp/Backend/repository.dart';
import 'package:niteapp/Models/Event.dart';
import 'package:niteapp/Utils/AppLocalizations.dart';
import 'package:niteapp/Utils/Constants.dart';
import 'package:niteapp/Utils/Messages.dart';

class BookingTicketPage extends StatefulWidget {

  final Event event;
  final bool going;

  const BookingTicketPage({Key key, this.event, this.going}) : super(key: key);

  @override
  _BookingTicketPageState createState() => _BookingTicketPageState();

}
class _BookingTicketPageState extends State<BookingTicketPage> {

  var _repository = new Repository();

  List<String> textDescrs = ['Entrada + 1 Copa', 'Entrada + 2 Copas', 'Entrada + 3 Copas'];
  List<String> textPrices = ['12', '15', '20'];

  int selectedOption = -1;

  int quanty = 0;

  bool isSelected(int index) {
    return index == selectedOption;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.event.hasTicket = true;
    widget.event.ticketDescriptions = textDescrs;
    widget.event.ticketPrices = textPrices;
  }

  void incrementQuanty() {
    setState(() {
      ++quanty;
    });
  }
  void decrementQuanty() {
    if(quanty > 0) setState(() {
      --quanty;
    });
  }

  String getTotalAmount() {
    if(selectedOption == -1) return '0';
    else return (quanty * int.parse(textPrices[selectedOption])).toString();
  }

  @override
  Widget build(BuildContext context) {
    return widget.event.hasTicket ?
      Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 30, top: 30),
              child: Text(
                AppLocalizations.of(context).translate('selectOption'),
                style: TextStyle(
                  fontSize: 18,
                  color: Constants.main,
                ),
              ),
            ),
            ListView.builder(
              padding: EdgeInsets.only(left: 15.0, top: 10.0, right: 15.0),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: widget.event.ticketDescriptions.length,
              itemBuilder: (BuildContext context, int index) {
                return CheckboxListTile(
                  title: Text(widget.event.ticketDescriptions[index]),
                  subtitle: Text(AppLocalizations.of(context).translate('price') + ': ' + widget.event.ticketPrices[index] + '€'),
                  value: isSelected(index),
                  onChanged: (value) {
                    if(value) setState(() {
                      selectedOption = index;
                    });
                    else setState(() {
                      selectedOption = -1;
                    });
                  },
                );
              },
            ),
            Container(
              padding: EdgeInsets.only(left: 30, top: 40, right: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context).translate('quantity'),
                    style: TextStyle(
                      fontSize: 18,
                      color: Constants.main,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Transform.scale(
                          scale: 0.75,
                          child: FloatingActionButton(
                            onPressed: decrementQuanty,
                            backgroundColor: Constants.accent,
                            child: Icon(
                              Icons.remove,
                              color: Constants.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Text(
                            quanty.toString(),
                            style: TextStyle(
                              color: Constants.main,
                              fontSize: 16.0,
                              fontFamily: "Roboto"
                            ),
                          ),
                        ),
                        Transform.scale(
                          scale: 0.75,
                          child: FloatingActionButton(
                            onPressed: incrementQuanty,
                            backgroundColor: Constants.accent,
                            child: Icon(
                              Icons.add,
                              color: Constants.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FloatingActionButton.extended(
                backgroundColor: Constants.white,
                elevation: 0,
                label: Text(
                  AppLocalizations.of(context).translate('total') + ': ' + getTotalAmount() + '€',
                  style: TextStyle(
                      color: Constants.main,
                      fontSize: 22.0,
                      fontFamily: "Roboto"
                  ),
                ),
              ),
              FloatingActionButton.extended(
                backgroundColor: Constants.accent,
                label: Text(
                  AppLocalizations.of(context).translate('buy'),
                  style: TextStyle(
                      color: Constants.white,
                      fontSize: 15.0,
                      fontFamily: "Roboto"
                  ),
                ),
              ),
            ],
          ),
        )
      ) :
      EmptyNotifications(msg: AppLocalizations.of(context).translate('buyNotAvailable'));
  }

}