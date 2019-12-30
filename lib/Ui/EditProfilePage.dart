import 'package:flutter/material.dart';
import 'package:niteapp/Backend/repository.dart';
import 'package:niteapp/Models/User.dart';
import 'package:niteapp/Utils/Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:niteapp/Utils/Messages.dart';

class EditProfilePage extends StatefulWidget {
  EditProfilePage({Key key}) : super(key: key);

  @override
  _EditProfilePageState createState() => new _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  var _repository = new Repository();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController registerNameContrl = new TextEditingController();
  TextEditingController registerCityContrl = new TextEditingController();
  TextEditingController registerAgeContrl = new TextEditingController();
  TextEditingController registerPhoneContrl = new TextEditingController();

  bool isLoading;
  User user;

  List<String> sexTypes = ['Hombre' , 'Mujer', 'Otro'];
  String sexType;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = true;
    getUser();
  }

  void getUser() async {
    user = await _repository.getCurrentUserDetails();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    //iniFields();
    if(isLoading) return Scaffold(
      appBar: AppBar(
        title: Text('Editar Perfil'),
      ),
      body: LoadingView(),
    );
    else return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Editar Perfil'),
      ),
      body: Container(
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
                  labelText: user.name,
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
                                    getSex(),
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
                        labelText: user.age,
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
                  labelText: user.city,
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
                  labelText: user.phones[0],
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit, color: Constants.white,),
        onPressed: () {
          onUpdateButtonPressed();
        },
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
            fontFamily: "WorkSansSemiBold"),
      ),
      backgroundColor: Constants.main,
      duration: Duration(seconds: 2),
    ));
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

  void onUpdateButtonPressed() async {
    if(registerNameContrl.text.isNotEmpty) await _repository.updateCurrentUserName(registerNameContrl.text, transformName(registerNameContrl.text));
    if(registerCityContrl.text.isNotEmpty) await _repository.updateCurrentUserCity(registerCityContrl.text);
    if(registerAgeContrl.text.isNotEmpty) await _repository.updateCurrentUserAge(registerAgeContrl.text);
    if(sexType.isNotEmpty) await _repository.updateCurrentUserSex(sexType);
    if(registerPhoneContrl.text.isNotEmpty) await _repository.updateCurrentUserPhone(transformPhone(registerPhoneContrl.text));

    showInSnackBar('Se ha acualizado correctamente');

  }

  String getSex() {
    if(user == null) return 'Sexo';
    else {
      if(user.sex == "Hombre") {
        setState(() {
          sexType = 'Hombre';
        });
        return "Hombre";
      }
      else if(user.sex == "Mujer") {
        setState(() {
          sexType = "Mujer";
        });
        return "Mujer";
      }
      else {
        setState(() {
          sexType = "Otro";
        });
        return "Otro";
      }
    }

  }

}