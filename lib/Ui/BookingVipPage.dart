import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:niteapp/Backend/repository.dart';
import 'package:niteapp/Models/Event.dart';
import 'package:niteapp/Utils/AppLocalizations.dart';
import 'package:niteapp/Utils/Constants.dart';
import 'package:niteapp/Utils/Messages.dart';

class BookingVipPage extends StatefulWidget {

  final Event event;
  final bool going;

  const BookingVipPage({Key key, this.event, this.going}) : super(key: key);

  @override
  _BookingVipPageState createState() => _BookingVipPageState();

}
class _BookingVipPageState extends State<BookingVipPage> {

  var _repository = new Repository();

  @override
  Widget build(BuildContext context) {
    return widget.event.hasVip ?
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: ListView(
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
                    widget.event.vipDescriptions[0],
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
                    widget.event.vipPrices[0],
                    style: TextStyle(
                      fontSize: 14,
                      color: Constants.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.12,
            width: MediaQuery.of(context).size.width,
            child:FlatButton(
              color: Constants.accent,
              highlightColor: Constants.accent,
              splashColor: Constants.accentLight,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0),
                child: Text(
                  AppLocalizations.of(context).translate('buy'),
                  style: TextStyle(
                      color: Constants.white,
                      fontSize: 15.0,
                      fontFamily: "Roboto"
                  ),
                ),
              ),
            ),
          ),
        ],
      ) :
      EmptyNotifications(msg: AppLocalizations.of(context).translate('vipNotAvailable'));
  }


}