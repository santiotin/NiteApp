import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:niteapp/Backend/repository.dart';

class PubsPage extends StatefulWidget {

  final String uid;

  const PubsPage({Key key, this.uid}) : super(key: key);

  @override
  _PubsPageState createState() => _PubsPageState();

}
class _PubsPageState extends State<PubsPage> {

  var _repository = Repository();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pubs'),
      ),
      body: Container(),
    );
  }



}