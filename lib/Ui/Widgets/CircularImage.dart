import 'dart:io';
import 'package:flutter/material.dart';
import 'package:niteapp/Utils/Constants.dart';

class CircularImage extends StatefulWidget {
  final double size;
  final String image;
  final File file;

  CircularImage({Key key, this.size, this.image, this.file}) : super(key: key);

  @override
  _CircularImageState createState() => new _CircularImageState();
}

class _CircularImageState extends State<CircularImage> {


  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        Container(
          width: widget.size,
          height: widget.size,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        Container(
            width: widget.size,
            height: widget.size,
            decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                    fit: BoxFit.cover,
                    image: widget.image == null ?
                    FileImage(widget.file) :
                    NetworkImage(widget.image)
                )
            )
        )
      ],
    );
  }
}