import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:niteapp/Utils/Constants.dart';

class LoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: Constants.white,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class ErrorView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: Constants.white,
      child: Center(
        child: Text('Error'),
      ),
    );
  }
}

class EmptyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container();
  }
}

Widget loadingAsyncSnapshot(AsyncSnapshot asyncSnapshot) {
  if(asyncSnapshot == null || asyncSnapshot.data == null || asyncSnapshot.connectionState == ConnectionState.waiting) return LoadingView();
  else return Container();
}

Widget errorStream(AsyncSnapshot asyncSnapshot) {
  if(asyncSnapshot.hasError) return ErrorView();
  else return Container();
}

class EmptyTodayAndSearch extends StatelessWidget {

  final String msg;

  const EmptyTodayAndSearch({Key key, this.msg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image(
            width: MediaQuery.of(context).size.width * 0.4,
            fit: BoxFit.cover,
            image: AssetImage(
                'assets/images/no_data.png',
            ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 40.0),
          child: Text(msg),
        ),
      ],
    );
  }
}

class EmptyNotifications extends StatelessWidget {

  final String msg;

  const EmptyNotifications({Key key, this.msg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image(
          width: MediaQuery.of(context).size.width * 0.7,
          fit: BoxFit.cover,
          image: AssetImage(
            'assets/images/alone.png',
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 30.0),
          child: Text(msg),
        ),
      ],
    );
  }
}

class EmptyFriends extends StatelessWidget {

  final String msg;

  const EmptyFriends({Key key, this.msg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image(
            width: MediaQuery.of(context).size.width * 0.7,
            fit: BoxFit.cover,
            image: AssetImage(
              'assets/images/friends.png',
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 30.0),
            child: Text(msg),
          ),
        ],
      ),
    );
  }
}

class FirebaseEmptyUsersView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(child: Text('No hay usuarios'));
  }
}

class EmptyFavoriteEvents extends StatelessWidget {

  final String msg;

  const EmptyFavoriteEvents({Key key, this.msg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          GestureDetector(
            onTap: () {

            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    width: 150,
                    height: 190,
                    margin: EdgeInsets.fromLTRB(10.0,20.0,10.0,10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: Constants.main
                      ),
                      color: Constants.white
                    ),
                    child: Icon(
                      Icons.add,
                      color: Constants.main,
                    )
                ),
                Container(
                  width: 150,
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Text(
                        'Añade clubs a favoritos para que sus eventos aparezcan aquí',
                      style: TextStyle(
                        color: Constants.grey
                      ),
                    ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EmptyFavoriteClubs extends StatelessWidget {

  final String msg;

  const EmptyFavoriteClubs({Key key, this.msg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image(
            width: MediaQuery.of(context).size.width * 0.7,
            fit: BoxFit.cover,
            image: AssetImage(
              'assets/images/no_clubs.png',
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 30.0),
            child: Text(msg),
          ),
        ],
      ),
    );
  }
}