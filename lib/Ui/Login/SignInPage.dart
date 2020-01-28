import 'package:flutter/material.dart';
import 'package:niteapp/Backend/repository.dart';
import 'package:niteapp/Ui/HomePage.dart';
import 'package:niteapp/Ui/Login/ForgotPasswordPage.dart';
import 'package:niteapp/Ui/Login/RegisterPage.dart';
import 'package:niteapp/Utils/AppLocalizations.dart';
import 'package:niteapp/Utils/Constants.dart';
import 'package:flutter/cupertino.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key key}) : super(key: key);

  @override
  _SignInPageState createState() => new _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  var _repository = new Repository();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController signInEmailContrl = new TextEditingController();
  TextEditingController signInPasswdContrl = new TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: null,
      resizeToAvoidBottomPadding: true,
      resizeToAvoidBottomInset: true,
      body: isLoading ?
        Stack(
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
          ) :
        Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.30,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.04),
                  child: Image(
                    image: AssetImage('assets/images/barcelona.png'),
                    height: MediaQuery.of(context).size.height * 0.16,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.30),
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.76,
                child:  ListView(
                  physics: NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 0),
                      child: Text(
                        AppLocalizations.of(context).translate('niteApp'),
                        style: TextStyle(
                            fontFamily: "Roboto",
                            fontSize: 35.0,
                            fontWeight: FontWeight.bold,
                            color: Constants.main
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 30.0, bottom: 5.0),
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: signInEmailContrl,
                        cursorColor: Constants.accent,
                        style: TextStyle(
                            fontFamily: "Roboto",
                            fontSize: 16.0,
                            color: Constants.main
                        ),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                              width: 1,
                              color: Constants.main,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                              width: 1,
                              color: Constants.main,
                            ),
                          ),
                          contentPadding: EdgeInsets.all(25.0),
                          prefixIcon: Icon(
                            Icons.email,
                            color: Constants.main,
                          ),
                          labelText: AppLocalizations.of(context).translate('email'),
                          labelStyle: TextStyle(
                            fontFamily: "Roboto",
                            fontSize: 14.0,
                            color: Constants.main,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0, bottom: 5.0),
                      child: TextField(
                        controller: signInPasswdContrl,
                        obscureText: true,
                        cursorColor: Constants.accent,
                        style: TextStyle(
                            fontFamily: "Roboto",
                            fontSize: 16.0
                        ),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                              width: 1,
                              color: Constants.main,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                              width: 1,
                              color: Constants.main,
                            ),
                          ),
                          contentPadding: EdgeInsets.all(25.0),
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: Constants.main,
                          ),
                          labelText: AppLocalizations.of(context).translate('password'),
                          labelStyle: TextStyle(
                            fontFamily: "Roboto",
                            fontSize: 15.0,
                            color: Constants.main,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.38,
                          margin: EdgeInsets.only(top: 20.0),
                          child:OutlineButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            highlightedBorderColor: Constants.white,
                            borderSide: BorderSide(color: Constants.white),
                            color: Constants.white,
                            highlightColor: Constants.white,
                            splashColor: Constants.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20.0, horizontal: 15.0),
                              child: Text(
                                AppLocalizations.of(context).translate('register'),
                                style: TextStyle(
                                    color: Constants.accent,
                                    fontSize: 14.0,
                                    fontFamily: "Roboto"
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute<Null>(
                                    builder: (context) => RegisterPage(),
                                    settings: RouteSettings(name: 'RegisterPage'),
                                  )
                              );
                            },
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.38,
                          margin: EdgeInsets.only(top: 20.0),
                          child:RawMaterialButton(
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            fillColor: Constants.accent,
                            highlightColor: Constants.accent,
                            splashColor: Constants.accentLight,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20.0),
                              child: Text(
                                AppLocalizations.of(context).translate('signIn'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                    fontFamily: "Roboto"
                                ),
                              ),
                            ),
                            onPressed: () =>
                                onSignInButtonPressed(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.90),
              child: Padding(
                padding: EdgeInsets.only(top: 0),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute<Null>(
                            builder: (context) => ForgotPasswordPage(),
                            settings: RouteSettings(name: 'ForgotPasswordPage'),
                          )
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(
                                text: AppLocalizations.of(context).translate('forgotPassword'),
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  color: Constants.main,
                                  fontSize: 15,
                                )
                            ),
                          ]
                      ),
                    ),
                  ),
                ),
              )
          )
        ],
      ),
    );
  }

  //Show snack bar message
  void showInSnackBar(String value) {
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontFamily: "Roboto"),
      ),
      backgroundColor: Constants.main,
      duration: Duration(seconds: 3),
    ));
  }

  void signIn() async {
    int result = await _repository.signIn(signInEmailContrl.text, signInPasswdContrl.text);
    if(result == 0) {
      Navigator.pushReplacement(
          context,
          CupertinoPageRoute<Null>(
            builder: (context) => HomePage(),
            settings: RouteSettings(name: 'HomePage'),
          )
      );
    } else if(result == -2) {
      setState(() {
        isLoading = false;
      });
      signInPasswdContrl.clear();
      showInSnackBar(AppLocalizations.of(context).translate('notValidatedEmail'));
    }else{
      setState(() {
        isLoading = false;
      });
      signInPasswdContrl.clear();
      showInSnackBar(AppLocalizations.of(context).translate('incorrectUserOrPassword'));
    }
  }

  // Actions to do when login and register
  void onSignInButtonPressed() {
    setState(() {
      isLoading = true;
    });
    signIn();
  }



}