import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/services.dart';
import 'package:niteapp/Backend/repository.dart';
import 'package:niteapp/Models/Event.dart';
import 'package:niteapp/Ui/GoogleMapsPage.dart';
import 'package:niteapp/Ui/EventDetailsPage.dart';
import 'package:niteapp/Ui/Login/SignInPage.dart';
import 'package:niteapp/Utils/AppLocalizations.dart';
import 'package:niteapp/Utils/Constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:niteapp/Ui/Widgets/HorizontalSlideFavorites.dart';
import 'package:niteapp/Ui/Widgets/HorizontalSlider.dart';
import 'package:niteapp/Utils/Messages.dart';

class TodayPage extends StatefulWidget {

  const TodayPage({Key key}) : super(key: key);

  @override
  _TodayPageState createState() => _TodayPageState();

}

class _TodayPageState extends State<TodayPage> {
  var _repository = Repository();
  var _dateText;
  int day, month, year;
  bool firstBuild = true;

  FirebaseUser mUser;

  List<DocumentSnapshot> favoriteEvents = new List<DocumentSnapshot>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkAndGetCurrentUser();
    initializeDateFormatting();

    day = DateTime.now().day;
    month = DateTime.now().month;
    year = DateTime.now().year;
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

  String retDateString(DateTime now, BuildContext context) {
    String locale = AppLocalizations.of(context).translate('locale');
    if(locale == 'es') return DateFormat.yMMMEd('es').format(now).toString();
    else return DateFormat.yMMMEd().format(now).toString();
  }

  void onDatePressed() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    Future<DateTime> selectedDate = showDatePicker(
        context: context,
        initialDate: DateTime(year,month,day),
        firstDate: DateTime(year-1),
        lastDate: DateTime(2025),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData(
              primaryColor: Constants.main,
              primarySwatch: Colors.pink,
              accentColor: Constants.accent,
              buttonColor: Constants.accent,
            ),
            child: child,
          );
        });

    selectedDate.then((value) {
      setState(() {
        _dateText = retDateString(value, context);
        day = value.day;
        month = value.month;
        year = value.year;
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.white,
        ));
      });
    });


  }

  List<Event> documentsToEvents(List<DocumentSnapshot> documents) {
    List<Event> events = new List<Event>();
    for(int i = 0; i < documents.length; i++) {
      events.add(Event.fromMap(documents[i].data, documents[i].documentID));
    }
    return events;
  }


  @override
  Widget build(BuildContext context) {
    if(firstBuild) {
      firstBuild = false;
      setState(() {
        _dateText = retDateString(DateTime.now(), context);
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 4,
        title: GestureDetector(
          child: Text(_dateText),
          onTap: onDatePressed,
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            padding: EdgeInsets.only(right: 10),
            icon: Icon(
              Icons.map,
              color: Constants.main,
            ),
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute<Null>(
                  builder: (context) => GoogleMapsPage(day: day, month: month, year: year, uid: mUser.uid,),
                  settings: RouteSettings(name: 'GoogleMapsPage'),
                ),
              );
            })
        ],
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(
              parent: FixedExtentScrollPhysics()),
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
                stream: _repository.getSponsoredEvents(day.toString(), month.toString(), year.toString()),
                builder: (context, snapshot) {
                  if(snapshot == null || snapshot.data == null || snapshot.data.documents == null
                      || snapshot.data.documents.isEmpty || snapshot.connectionState == ConnectionState.waiting) return EmptyView();
                  else if(snapshot.hasError) return ErrorView();
                  else return Container(
                    width: double.infinity,
                    child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute<Null>(
                              builder: (context) => EventDetailsPage(eid: snapshot.data.documents[0].documentID, uid: mUser.uid,),
                              settings: RouteSettings(name: 'EventDetailsPage'),
                            ),
                          );
                        },
                        child: Stack(
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.3,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.3,
                              child: Image.network(
                                snapshot.data.documents[0]["imageUrl"],
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              left: 20.0,
                              top: 15.0,
                              child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Constants.white,
                                  ),
                                  padding: EdgeInsets.all(10),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                      child: Text(AppLocalizations.of(context).translate('recommendation')),
                                    ),
                                  )
                              ),
                            ),
                          ],
                        )
                    ),
                  );
                }
            ),
            SizedBox(height: 20.0),
            StreamBuilder<QuerySnapshot>(
                stream: _repository.getEvents(day.toString(), month.toString(), year.toString()),
                builder: (context, snapshot) {
                  if(snapshot == null || snapshot.data == null || snapshot.data.documents == null ) return EmptyView();
                  else if(snapshot.hasError) return ErrorView();
                  else if(snapshot.connectionState == ConnectionState.waiting) return LoadingView();
                  else if(snapshot.data.documents.isEmpty) return EmptyTodayAndSearch(msg: AppLocalizations.of(context).translate('noEventsForThisDay'),);
                  else return Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                AppLocalizations.of(context).translate('eventsOfTheDay'),
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
                          showDay: false,
                        ),
                        SizedBox(height: 5),
                        Padding(
                          padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                AppLocalizations.of(context).translate('todayFavorites'),
                                style: TextStyle(
                                  color: Constants.main,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        HorizontalSliderFavorites(
                          events: documentsToEvents(snapshot.data.documents),
                          uid: mUser.uid,
                        ),
                      ],
                    );
                }
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }


}