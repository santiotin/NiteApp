import 'package:flutter/material.dart';
import 'package:niteapp/Ui/SearchPage.dart';
import 'package:niteapp/Ui/NotificationsPage.dart';
import 'package:niteapp/Ui/ProfilePage.dart';
import 'package:niteapp/Ui/TodayPage.dart';
import 'package:bottom_navigation_badge/bottom_navigation_badge.dart';
import 'package:niteapp/Utils/Constants.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  BottomNavigationBadge badger;
  List<BottomNavigationBarItem> items;
  TodayPage _todayPage;
  SearchPage _searchPage;
  NotificationsPage _notificationsPage;
  ProfilePage _profilePage;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if(index == 2) items = badger.removeBadge(items, 2);
    });
  }

  void createBadge() {
    setState(() {
      items = badger.setBadge(items, "", 2);
    });
  }

  @override
  void initState() {
    setState(() {
      _selectedIndex = 0;
    });
    iniItemsAndBadge();
    super.initState();
  }

  void iniItemsAndBadge() {
    badger = new BottomNavigationBadge(
        backgroundColor: Constants.accent,
        badgeShape: BottomNavigationBadgeShape.circle,
        textColor: Colors.white,
        position: BottomNavigationBadgePosition.topRight,
        textSize: 6);

    items = [
      BottomNavigationBarItem(
        icon: Icon(Icons.brightness_2),
        title: Text('Today'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.search),
        title: Text('Search'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.notifications_none),
        title: Text('Notifications'),
        activeIcon: Icon(Icons.notifications),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person_outline),
        title: Text('Profile'),
        activeIcon: Icon(Icons.person),
      ),
    ];

    _todayPage = new TodayPage();
    _searchPage = new SearchPage();
    _notificationsPage = new NotificationsPage(createBadge: createBadge,);
    _profilePage = new ProfilePage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: new Stack(
        children: <Widget>[
          new Offstage(
            offstage: _selectedIndex != 0,
            child: new TickerMode(
              enabled: _selectedIndex == 0,
              child: _todayPage,
            ),
          ),
          new Offstage(
            offstage: _selectedIndex != 1,
            child: new TickerMode(
              enabled: _selectedIndex == 1,
              child: _searchPage,
            ),
          ),
          new Offstage(
            offstage: _selectedIndex != 2,
            child: new TickerMode(
              enabled: _selectedIndex == 2,
              child: _notificationsPage,
            ),
          ),
          new Offstage(
            offstage: _selectedIndex != 3,
            child: new TickerMode(
              enabled: _selectedIndex == 3,
              child: _profilePage,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: items,
        currentIndex: _selectedIndex,
        selectedItemColor: Constants.main,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: false,
        showSelectedLabels: false,
      ),
    );
  }
}
