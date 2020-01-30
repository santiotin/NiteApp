import 'package:flutter/material.dart';
import 'package:niteapp/Backend/repository.dart';
import 'package:niteapp/Utils/AppLocalizations.dart';
import 'package:niteapp/Utils/Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:diacritic/diacritic.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => new _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  var _repository = new Repository();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController registerNameContrl = new TextEditingController();
  TextEditingController registerEmailContrl = new TextEditingController();
  TextEditingController registerPasswdContrl = new TextEditingController();
  TextEditingController registerPasswd2Contrl = new TextEditingController();
  TextEditingController registerCityContrl = new TextEditingController();
  TextEditingController registerAgeContrl = new TextEditingController();
  TextEditingController registerPhoneContrl = new TextEditingController();

  bool isLoading = false;
  bool firstBuild = true;

  List<String> sexTypes;
  String sexType;

  @override
  Widget build(BuildContext context) {
    if(firstBuild) {
      iniSexTypes();
      firstBuild = false;
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('register')),
        elevation: 0,
      ),
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
      )
          :Container(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: TextField(
                controller: registerNameContrl,
                keyboardType: TextInputType.text,
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
                    Icons.person_outline,
                    color: Constants.main,
                  ),
                  labelText: AppLocalizations.of(context).translate('completeName*'),
                  labelStyle: TextStyle(
                    fontFamily: "Roboto",
                    fontSize: 14.0,
                    color: Constants.main,
                  ),
                ),
              ),
            ),
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
                  labelText: AppLocalizations.of(context).translate('email*'),
                  labelStyle: TextStyle(
                    fontFamily: "Roboto",
                    fontSize: 14.0,
                    color: Constants.main,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: TextField(
                controller: registerPasswdContrl,
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
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
                    Icons.lock_outline,
                    color: Constants.main,
                  ),
                  labelText: AppLocalizations.of(context).translate('password*'),
                  labelStyle: TextStyle(
                    fontFamily: "Roboto",
                    fontSize: 14.0,
                    color: Constants.main,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: TextField(
                controller: registerPasswd2Contrl,
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
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
                    Icons.lock_outline,
                    color: Constants.main,
                  ),
                  labelText: AppLocalizations.of(context).translate('confirmPassword*'),
                  labelStyle: TextStyle(
                    fontFamily: "Roboto",
                    fontSize: 14.0,
                    color: Constants.main,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Constants.main),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(Icons.face),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: DropdownButton<String>(
                                  hint:  Text(
                                    AppLocalizations.of(context).translate('sex*'),
                                    style: TextStyle(
                                      color: Constants.main,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  value: sexType,
                                  isExpanded: true,
                                  icon: Container(),
                                  onChanged: (String sex) {
                                    setState(() {
                                      sexType = sex;
                                    });
                                  },
                                  iconEnabledColor: Constants.main,
                                  iconDisabledColor: Constants.main,
                                  underline: Container(),
                                  items: sexTypes.map((String value) {
                                    return new DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value, style: TextStyle(color: Constants.main),),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        )
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.025,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: TextField(
                      controller: registerAgeContrl,
                      keyboardType: TextInputType.number,
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
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(bottom: 5.0),
                          child: Icon(
                            Icons.cake,
                            color: Constants.main,
                          ),
                        ),
                        labelText: AppLocalizations.of(context).translate('age*'),
                        labelStyle: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 14.0,
                          color: Constants.main,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: TextField(
                controller: registerCityContrl,
                keyboardType: TextInputType.text,
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
                    Icons.location_city,
                    color: Constants.main,
                  ),
                  labelText: AppLocalizations.of(context).translate('city*'),
                  labelStyle: TextStyle(
                    fontFamily: "Roboto",
                    fontSize: 14.0,
                    color: Constants.main,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: TextField(
                controller: registerPhoneContrl,
                keyboardType: TextInputType.phone,
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
                    Icons.phone,
                    color: Constants.main,
                  ),
                  labelText: AppLocalizations.of(context).translate('phone'),
                  labelStyle: TextStyle(
                    fontFamily: "Roboto",
                    fontSize: 14.0,
                    color: Constants.main,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
              child: Text(
                AppLocalizations.of(context).translate('warningPhone'),
                style: TextStyle(
                  color: Constants.accent,
                  fontFamily: 'Roboto',
                ),
              ),
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
                    AppLocalizations.of(context).translate('register'),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        fontFamily: "Roboto"
                    ),
                  ),
                ),
                onPressed: () => onSignUpButtonPressed(),
              ),
            )
          ],
        ),
      ),
    );
  }

  void iniSexTypes() {
    setState(() {
      sexTypes = [
        AppLocalizations.of(context).translate('man'),
        AppLocalizations.of(context).translate('women'),
        AppLocalizations.of(context).translate('other')
      ];
    });
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

  // Validate email and pwd format
  bool emailValidator(String value) {
    Pattern pattern = r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      setState(() {
        isLoading = false;
      });
      showInSnackBar(AppLocalizations.of(context).translate('emailFormat'));
      return false;
    } else {
      return true;
    }
  }

  bool pwdValidator(String value) {
    if (value.length < 8) {
      setState(() {
        isLoading = false;
      });
      showInSnackBar(AppLocalizations.of(context).translate('passwordLength'));
      return false;
    } else {
      return true;
    }
  }

  List<String> transformName(String name) {
    List<String> result = new List<String>();
    List<String> aux = name.split(" ");

    for(String s in aux) {
      result.add(s.toLowerCase());
      result.add(removeDiacritics(s.toLowerCase()));
    }
    return result;
  }

  List<String> transformPhone(String phone) {
    List<String> result = new List<String>();
    result.add(phone);
    String aux = "+34" + phone;
    result.add(aux);

    return result;
  }

  String getSex() {
    String result = sexType;
    if(sexType == 'Man') result = 'Hombre';
    else if(sexType == 'Women') result = 'Mujer';
    else if(sexType == 'Other') result = 'Otro';
    return result;
  }

  void signUp() async{
    int result =  await _repository.addUser(registerEmailContrl.text,
        registerPasswdContrl.text, registerNameContrl.text, registerCityContrl.text,
        registerAgeContrl.text, getSex(), transformName(registerNameContrl.text), transformPhone(registerPhoneContrl.text));

    if(result == 0) {
      registerNameContrl.clear();
      registerEmailContrl.clear();
      registerCityContrl.clear();
      registerAgeContrl.clear();
      registerPhoneContrl.clear();
      registerPasswdContrl.clear();
      registerPasswd2Contrl.clear();
      setState(() {
        isLoading = false;
      });
      showInSnackBar(AppLocalizations.of(context).translate('confirmationEmail'));
    } else if (result == -1){
      setState(() {
        isLoading = false;
      });
      showInSnackBar(AppLocalizations.of(context).translate('registeredEmail'));
    } else {
      setState(() {
        isLoading = false;
      });
      showInSnackBar(AppLocalizations.of(context).translate('errorOcurred'));
    }
  }

  void onSignUpButtonPressed() {
    if(!isSomethingEmpty()){
      setState(() {
        isLoading = true;
      });
      if(emailValidator(registerEmailContrl.text)){
        if(pwdValidator(registerPasswdContrl.text)){
          if (registerPasswdContrl.text == registerPasswd2Contrl.text) {
            signUp();
          }
          else {
            setState(() {
              isLoading = false;
            });
            showInSnackBar(AppLocalizations.of(context).translate('matchPasswords'));
          }
        }
      }
    }
  }

  bool isSomethingEmpty(){
    if(registerNameContrl.text.isEmpty) {
      showInSnackBar(AppLocalizations.of(context).translate('emptyName'));
      return true;
    }
    else if(registerEmailContrl.text.isEmpty) {
      showInSnackBar(AppLocalizations.of(context).translate('emptyEmail'));
      return true;
    }
    else if(registerPasswdContrl.text.isEmpty) {
      showInSnackBar(AppLocalizations.of(context).translate('emptyPassword'));
      return true;
    }
    else if(sexType == null || sexType.isEmpty) {
      showInSnackBar(AppLocalizations.of(context).translate('emptySex'));
      return true;
    }
    else if(registerAgeContrl.text.isEmpty) {
      showInSnackBar(AppLocalizations.of(context).translate('emptyAge'));
      return true;
    }
    else if(registerCityContrl.text.isEmpty) {
      showInSnackBar(AppLocalizations.of(context).translate('emptyCity'));
      return true;
    }
    else return false;
  }
}