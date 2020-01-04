import 'dart:async';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:easy_permission_validator/easy_permission_validator.dart';
import 'package:niteapp/Backend/repository.dart';
import 'package:niteapp/Models/User.dart';


class ContactsPage extends StatefulWidget {
  ContactsPage({Key key}) : super(key: key);

  @override
  _ContactsPageState createState() => new _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {

  var _repository = new Repository();
  var contacts;
  List<User> _usersInApp = new List<User>();
  bool _isLoading = false;
  int totalPhones = 1;
  int numPhones = 1;

  @override
  void initState() {
    super.initState();
    _permissionContactsRequest().then((result) {
      if (result) refreshContacts();
      else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Oops!'),
            content: const Text('Looks like permission to read contacts is not granted.'),
            actions: <Widget>[
              FlatButton(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Contactos'),
      ),
      body: !_isLoading
          ? Container(
              child: _usersInApp.isEmpty ?
                  Center(child: Text('No tienes amigos')) :
                  ListView.builder(
                    itemCount: _usersInApp.length,
                    itemBuilder: (BuildContext context, int index) {
                      User user = _usersInApp.elementAt(index);
                      return _buildListTile(user);
                    },
                  ),
            )
          : Center(
              child: CircularProgressIndicator(),
          ),
    );
  }


  ListTile _buildListTile(User user) {
    return ListTile(
      leading: Icon(Icons.contacts, size: 50,),
      title: Text(user.name),
      subtitle: Text(user.id),
      trailing: Checkbox(
          activeColor: Colors.green,
          value: false,
      )
    );
  }

  refreshContacts() async {
    setState(() {
      _isLoading = true;
    });
    contacts = await ContactsService.getContacts();
    for(int i = 0; i < contacts.length; i++) {
      if(contacts.elementAt(i).phones.isNotEmpty && contacts.elementAt(i).phones.elementAt(0) != null){
        getUserInApp(contacts.elementAt(i).phones.elementAt(0).value.replaceAll(new RegExp(r"\s+\b|\b\s"), ""));
        totalPhones++;
      }
    }
    //getUsersInApp();
  }

  Future<bool>_permissionContactsRequest() async {
    final permissionValidator = EasyPermissionValidator(
      context: context,
      appName: 'NiteApp',
    );
    var result = await permissionValidator.contacts();
    if (result) return true;
    else return false;
  }

  Future<List<User>> getUserInApp(String phone) async{
    List<User> auxUsers = await _repository.getUserInApp(phone);
    numPhones++;
    for(int i = 0; i < auxUsers.length; i++) {
      setState(() {
        _usersInApp.add(auxUsers.elementAt(i));
        _isLoading = false;
      });
    }
    if(numPhones == totalPhones) {
      setState(() {
        _isLoading = false;
      });
    }
  }


}