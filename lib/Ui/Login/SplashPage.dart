import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:niteapp/Backend/repository.dart';
import 'package:niteapp/Ui/HomePage.dart';
import 'package:niteapp/Ui/Login/SignInPage.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  var _repository = new Repository();

  @override
  initState() {
    super.initState();
    checkAndGetCurrentUserDetails();
  }

  void checkAndGetCurrentUserDetails() async {
    FirebaseUser currentUser = await _repository.getCurrentUser();
    if(currentUser != null && currentUser.isEmailVerified) {
      Navigator.pushReplacement(
          context,
          CupertinoPageRoute<Null>(
            builder: (context) => HomePage(),
            settings: RouteSettings(name: 'HomePage'),
          )
      );
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Stack(
        children: <Widget>[
          Center(
            child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.width * 0.4,
                child: CircularProgressIndicator(),
            ),
          ),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.width * 0.3,
              child: Image(
                  image: AssetImage('assets/images/barcelona.png')
              ),
            ),
          ),
        ],
      ),
    );
  }
}