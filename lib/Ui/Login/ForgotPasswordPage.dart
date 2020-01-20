import 'package:flutter/material.dart';
import 'package:niteapp/Backend/repository.dart';
import 'package:niteapp/Utils/AppLocalizations.dart';
import 'package:niteapp/Utils/Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:diacritic/diacritic.dart';

class ForgotPasswordPage extends StatefulWidget {
  ForgotPasswordPage({Key key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => new _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

  var _repository = new Repository();

  final GlobalKey<ScaffoldState> _scaffoldKeyF = new GlobalKey<ScaffoldState>();

  TextEditingController registerEmailContrl = new TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKeyF,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('forgotPassword')),
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: TextField(
                controller: registerEmailContrl,
                keyboardType: TextInputType.emailAddress,
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
            Expanded(
              child: Container(),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30.0, bottom: 20),
              child: RawMaterialButton(
                elevation: 4.0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                fillColor: Constants.accent,
                highlightColor: Constants.accent,
                splashColor: Constants.accentLight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 25.0, horizontal: 30.0),
                  child: Text(
                    AppLocalizations.of(context).translate('resetPassword'),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        fontFamily: "Roboto"
                    ),
                  ),
                ),
                onPressed: () => onForgotPasswordButtonPressed(),
              ),
            )
          ],
        ),
      ),
    );
  }

  //Show snack bar message
  void showInSnackBar(String value) {
    _scaffoldKeyF.currentState?.removeCurrentSnackBar();
    _scaffoldKeyF.currentState.showSnackBar(new SnackBar(
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

  // Validate email and pwd format
  bool emailValidator(String value) {
    Pattern pattern =
        r'(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      showInSnackBar(AppLocalizations.of(context).translate('emailFormat'));
      return false;
    } else {
      return true;
    }
  }

  void resetPassword() async {
    await _repository.resetPassword(registerEmailContrl.text);
  }

  void onForgotPasswordButtonPressed() {
    if(!isSomethingEmpty()){
      if(emailValidator(registerEmailContrl.text)){
        resetPassword();
        showInSnackBar(AppLocalizations.of(context).translate('confirmationEmail'));
      }
    }
  }

  bool isSomethingEmpty(){
    if(registerEmailContrl.text.isEmpty) {
      showInSnackBar(AppLocalizations.of(context).translate('emptyEmail'));
      return true;
    }
    else return false;
  }
}