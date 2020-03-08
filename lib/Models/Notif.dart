import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

abstract class Notif {

  Widget print(BuildContext context) {
    return Container();
  }

  Timestamp getTime() {
    return Timestamp.now();
  }

}