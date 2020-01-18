import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:niteapp/Backend/repository.dart';
import 'package:niteapp/Models/Club.dart';
import 'package:niteapp/Models/Event.dart';
import 'package:niteapp/Models/User.dart';
import 'package:niteapp/Ui/Lists/EventList.dart';
import 'package:niteapp/Ui/Lists/ClubList.dart';
import 'package:niteapp/Ui/Lists/UserList.dart';
import 'package:niteapp/Utils/AppLocalizations.dart';
import 'package:niteapp/Utils/Constants.dart';
import 'package:niteapp/Utils/Messages.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => new _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  var _repository = new Repository();

  Stream streamQueryEvents;
  Stream streamQueryUsers;
  Stream streamQueryClubs;

  int searchType = 0; //0 para eventos, 1 para personas, 2 para clubs

  Icon actionIcon = new Icon(Icons.search, color: Constants.main,);
  bool _isSearching;
  String _searchText = "";
  final FocusNode _searchFocus = FocusNode();
  TextEditingController _searchController = new TextEditingController();

  Widget SearchTypeIcon() {
    if(searchType == 1) return Icon(Icons.person_outline, color: Constants.white, size: 20,);
    else if(searchType == 2) return Icon(Icons.business, color: Constants.white, size: 20,);
    else return Icon(Icons.event, color: Constants.white, size: 20,);
  }

  String searchTypeText() {
    if(searchType == 1) return AppLocalizations.of(context).translate('people');
    else if(searchType == 2) return AppLocalizations.of(context).translate('clubs');
    else return AppLocalizations.of(context).translate('events');
  }

  void changeSearch() {
    setState(() {
      searchType++;
      if(searchType == 3) searchType = 0;
    });
  }

  void _handleSearchStart() {
    setState(() {
      this.actionIcon = new Icon(Icons.arrow_back, color: Constants.main,);
      _isSearching = true;
      if(!_searchFocus.hasFocus)_searchFocus.requestFocus();
    });
  }
  void _handleSearchEnd() {
    setState(() {
      this.actionIcon = new Icon(Icons.search, color: Constants.main,);
      _isSearching = false;
      _searchController.clear();
      _searchFocus.unfocus();
    });
  }

  @override
  void initState() {
    super.initState();
    _isSearching = false;

    _searchController.addListener(() {
      if (_searchController.text.isEmpty) {
        setState(() {
          _isSearching = false;
          _searchText = "";
        });
      }
      else {
        setState(() {
          _isSearching = true;
          _searchText = _searchController.text;
        });
      }
    });
    _searchFocus.addListener(() {
      if(_searchFocus.hasFocus) _handleSearchStart();
    });

  }

  Widget buildBar(BuildContext context) {
    return new AppBar(
        title: TextField(
          focusNode: _searchFocus,
          controller: _searchController,
          cursorColor: Constants.accent,
          onChanged: (text) {
            createStreamWithText(text);
          },
          style: new TextStyle(
            color: Constants.main,
          ),
          decoration: new InputDecoration(
              border: InputBorder.none,
              hintText: AppLocalizations.of(context).translate('searchDots'),
              hintStyle: new TextStyle(color: Constants.grey)
          ),
        ),
        leading: IconButton(
            icon: actionIcon,
            onPressed: () {
            setState(() {
                if (this.actionIcon.icon == Icons.search) {
                  _handleSearchStart();
                }
                else {
                  _handleSearchEnd();
                }
              });
            },
        ),
        actions: <Widget>[
          Padding(
          padding: EdgeInsets.symmetric(vertical: 7.5, horizontal: 10),
          child: FlatButton(
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),
            ),
            color: Constants.main,
            textColor: Constants.white,
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            onPressed: () {
              changeSearch();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 0.0),
                  child: Text(
                    searchTypeText(),
                    style: TextStyle(
                      fontSize: 12,
                      color: Constants.white
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      appBar: buildBar(context),
      body: StreamBuilder<QuerySnapshot>(
          stream: getQuery(),
          builder: (context, snapshot) {
            if(snapshot == null || snapshot.connectionState == ConnectionState.waiting) return LoadingView();
            else if(snapshot.hasError) return ErrorView();
            else if(snapshot.data == null || snapshot.data.documents.isEmpty) return Center(child: EmptyTodayAndSearch(msg: 'No hay resultados',));
            else {
              if (searchType == 1) return UserList(users: documentsToUsers(snapshot.data.documents));
              else if (searchType == 2) return SearchClubList(clubs: documentsToClubs(snapshot.data.documents));
              else return EventList(events: documentsToEvents(snapshot.data.documents) );
            }
          }
      ),
    );
  }

  void createStreamWithText(String text) {
    setState(() {
      streamQueryEvents = _repository.getSearchEvents(text.toLowerCase());
      streamQueryUsers = _repository.getSearchUsers(text.toLowerCase());
      streamQueryClubs = _repository.getSearchClubs(text.toLowerCase());
    });
  }

  Stream getQuery() {
    if(searchType == 1) return streamQueryUsers;
    else if(searchType == 2) return streamQueryClubs;
    else return streamQueryEvents;
  }

  List<Event> documentsToEvents(List<DocumentSnapshot> documents) {
    List<Event> events = new List<Event>();
    for(int i = 0; i < documents.length; i++) {
      events.add(Event.fromMap(documents[i].data, documents[i].documentID));
    }
    return events;
  }

  List<Club> documentsToClubs(List<DocumentSnapshot> documents) {
    List<Club> clubs = new List<Club>();
    for(int i = 0; i < documents.length; i++) {
      clubs.add(Club.fromMap(documents[i].data, documents[i].documentID));
    }
    return clubs;
  }

  List<User> documentsToUsers(List<DocumentSnapshot> documents) {
    List<User> users = new List<User>();
    for(int i = 0; i < documents.length; i++) {
      users.add(User.fromMap(documents[i].data, documents[i].documentID));
    }
    return users;
  }


}
