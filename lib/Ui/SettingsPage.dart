import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:niteapp/Ui/EditPhotoPage.dart';
import 'package:niteapp/Ui/EditProfilePage.dart';
import 'package:niteapp/Ui/Login/SignInPage.dart';
import 'package:niteapp/Pruebas/SearchFriendsPage.dart';
import 'package:niteapp/Utils/Constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajustes'),
      ),
      body: ListView(
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          RawMaterialButton(
            padding: EdgeInsets.only(top: 10),
            onPressed: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute<Null>(
                    builder: (context) => EditProfilePage(),
                    settings: RouteSettings(name: 'UserProfilePage'),
                  )
              );
            },
            child: Container(
              height: MediaQuery.of(context).size.height * 0.07,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 30.0, right: 20.0),
                    child: Icon(
                      Icons.edit,
                    ),
                  ),
                  Text(
                    'Editar perfil',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Constants.main,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
          RawMaterialButton(
            onPressed: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute<Null>(
                    builder: (context) => EditPhotoPage(),
                    settings: RouteSettings(name: 'EditPhotoPage'),
                  )
              );
            },
            child: Container(
              height: MediaQuery.of(context).size.height * 0.07,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 30.0, right: 20.0),
                    child: Icon(
                      Icons.face,
                    ),
                  ),
                  Text(
                    'Editar foto',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Constants.main,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
          RawMaterialButton(
            onPressed: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute<Null>(
                    builder: (context) => SearchFriendsPage(),
                    settings: RouteSettings(name: 'SearchFriendsPage'),
                  )
              );
            },
            child: Container(
              height: MediaQuery.of(context).size.height * 0.07,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 30.0, right: 20.0),
                    child: Icon(
                      Icons.people_outline,
                    ),
                  ),
                  Text(
                    'Buscar Amigos',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Constants.main,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
          RawMaterialButton(
            onPressed: () {},
            child: Container(
              height: MediaQuery.of(context).size.height * 0.07,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 30.0, right: 20.0),
                    child: Icon(
                      Icons.content_paste,
                    ),
                  ),
                  Text(
                    'Términos y Condiciones',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Constants.main,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
          RawMaterialButton(
            onPressed: () {},
            child: Container(
              height: MediaQuery.of(context).size.height * 0.07,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 30.0, right: 20.0),
                    child: Icon(
                      Icons.account_circle,
                    ),
                  ),
                  Text(
                    'Sobre nosotros',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Constants.main,
                      fontSize: 18,
                    ),
                  )
                ],
              ),
            ),
          ),
          RawMaterialButton(
            onPressed: () {},
            child: Container(
              height: MediaQuery.of(context).size.height * 0.07,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 30.0, right: 20.0),
                    child: Icon(
                      Icons.email,
                    ),
                  ),
                  Text(
                    'Contáctanos',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Constants.main,
                      fontSize: 18,
                    ),
                  )
                ],
              ),
            ),
          ),
          RawMaterialButton(
            onPressed: () {
              FirebaseAuth.instance
                  .signOut()
                  .then((result) =>
                    Navigator.pushAndRemoveUntil(
                      context,
                      CupertinoPageRoute<Null>(
                        builder: (context) => SignInPage(),
                        settings: RouteSettings(name: 'SignInPage'),
                      ),
                          (_) => false,
                    )
                  )
                  .catchError((err) => print(err));
            },
            child: Container(
              height: MediaQuery.of(context).size.height * 0.07,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 30.0, right: 20.0),
                    child: Icon(
                      Icons.exit_to_app,
                    ),
                  ),
                  Text(
                    'Cerrar sesión',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Constants.main,
                      fontSize: 18,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}