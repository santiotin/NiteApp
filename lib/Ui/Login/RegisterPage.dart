import 'package:flutter/material.dart';
import 'package:niteapp/Backend/repository.dart';
import 'package:niteapp/Ui/HomePage.dart';
import 'package:niteapp/Utils/Constants.dart';
import 'package:flutter/cupertino.dart';

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

  List<String> sexTypes = ['Hombre' , 'Mujer', 'Otro'];
  String sexType;

  @override
  Widget build(BuildContext context) {
    //iniFields();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Registrarse'),
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
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: TextField(
                    controller: registerNameContrl,
                    keyboardType: TextInputType.text,
                    cursorColor: Constants.accent,
                    style: TextStyle(
                        fontFamily: "WorkSansSemiBold",
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
                      labelText: 'Nombre completo',
                      labelStyle: TextStyle(
                        fontFamily: "WorkSansSemiBold",
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
                        fontFamily: "WorkSansSemiBold",
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
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        fontFamily: "WorkSansSemiBold",
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
                        fontFamily: "WorkSansSemiBold",
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
                      labelText: 'Contraseña',
                      labelStyle: TextStyle(
                        fontFamily: "WorkSansSemiBold",
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
                        fontFamily: "WorkSansSemiBold",
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
                      labelText: 'Confirmar Contraseña',
                      labelStyle: TextStyle(
                        fontFamily: "WorkSansSemiBold",
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
                                      "Sexo",
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
                              fontFamily: "WorkSansSemiBold",
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
                            labelText: 'Edad',
                            labelStyle: TextStyle(
                              fontFamily: "WorkSansSemiBold",
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
                        fontFamily: "WorkSansSemiBold",
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
                      labelText: 'Ciudad',
                      labelStyle: TextStyle(
                        fontFamily: "WorkSansSemiBold",
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
                        fontFamily: "WorkSansSemiBold",
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
                      labelText: 'Teléfono',
                      labelStyle: TextStyle(
                        fontFamily: "WorkSansSemiBold",
                        fontSize: 14.0,
                        color: Constants.main,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
                  child: Text(
                    '* El teléfono no sera visible para otros usuarios',
                    style: TextStyle(
                      color: Constants.accent,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 50.0),
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
                        "Registrarse",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontFamily: "WorkSansBold"
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

  void iniFields() {
    sexType = sexTypes[0];
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
            fontFamily: "WorkSansSemiBold"),
      ),
      backgroundColor: Constants.main,
      duration: Duration(seconds: 2),
    ));
  }

  // Validate email and pwd format
  bool emailValidator(String value) {
    Pattern pattern =
        r'(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      setState(() {
        isLoading = false;
      });
      showInSnackBar('El formato del correo no es válido');
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
      showInSnackBar('La contraseña ha de ser mas larga que 8');
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

  void signUp() async{
    bool result =  await _repository.addUser(registerEmailContrl.text,
        registerPasswdContrl.text, registerNameContrl.text, registerCityContrl.text,
        registerAgeContrl.text, sexType, transformName(registerNameContrl.text), transformPhone(registerPhoneContrl.text));

    if(result) {
      registerNameContrl.clear();
      registerEmailContrl.clear();
      registerCityContrl.clear();
      registerAgeContrl.clear();
      registerPhoneContrl.clear();
      registerPasswdContrl.clear();
      registerPasswd2Contrl.clear();
      Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute<Null>(
            builder: (context) => HomePage(),
            settings: RouteSettings(name: 'HomePage'),
          ),
              (_) => false
      );
    } else {
      setState(() {
        isLoading = false;
      });
      showInSnackBar('Este correo ya ha sido registrado');
    }
  }

  void onSignUpButtonPressed() {
    setState(() {
      isLoading = true;
    });
    if(emailValidator(registerEmailContrl.text)){
      if(pwdValidator(registerPasswdContrl.text)){
        if (registerPasswdContrl.text ==
            registerPasswd2Contrl.text) {
          signUp();
        }
        else {
          setState(() {
            isLoading = false;
          });
          showInSnackBar('La contraseñas no coinciden');
        }
      }
    }

  }
}