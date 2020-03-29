import 'package:flutter/material.dart';
import 'package:niteapp/Backend/repository.dart';
import 'package:niteapp/Models/Event.dart';
import 'package:niteapp/Ui/BookingListPage.dart';
import 'package:niteapp/Ui/BookingTicketPage.dart';
import 'package:niteapp/Ui/BookingVipPage.dart';
import 'package:niteapp/Utils/AppLocalizations.dart';
import 'package:niteapp/Utils/Constants.dart';

class BookingPage extends StatefulWidget {
  final Event event;
  final bool going;

  const BookingPage({Key key, this.event, this.going}) : super(key: key);

  _BookingPageState createState() => _BookingPageState();
}


class _BookingPageState  extends State<BookingPage> with SingleTickerProviderStateMixin{

  var _repository = new Repository();
  TabController tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = new TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context).translate('bookInfo'),
            style: TextStyle(
              color: Constants.main,
            ),
          ),
          bottom: TabBar(
            controller: tabController,
            tabs: [
              Tab(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                    child: Text(
                      AppLocalizations.of(context).translate('niteList'),
                      style: TextStyle(
                          fontSize: 16,
                          color: Constants.main
                      ),
                    ),
                  )
              ),
              Tab(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                    child: Text(
                      AppLocalizations.of(context).translate('tickets'),
                      style: TextStyle(
                          fontSize: 16,
                          color: Constants.main
                      ),
                    ),
                  )
              ),
              Tab(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                    child: Text(
                      AppLocalizations.of(context).translate('vips'),
                      style: TextStyle(
                          fontSize: 16,
                          color: Constants.main
                      ),
                    ),
                  )
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            BookingListPage(event: widget.event, going: widget.going,),
            BookingTicketPage(event: widget.event, going: widget.going,),
            BookingVipPage(event: widget.event, going: widget.going,)
          ],
        ),
      ),
    );
  }
}