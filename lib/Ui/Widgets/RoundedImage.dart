import 'dart:io';
import 'package:flutter/material.dart';

class RoundedImage extends StatefulWidget {
  final double size;
  final String image;
  final File file;

  RoundedImage({Key key, this.size, this.image, this.file}) : super(key: key);

  @override
  _RoundedImageState createState() => new _RoundedImageState();
}

class _RoundedImageState extends State<RoundedImage> {


  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        Container(
          width: widget.size,
          height: widget.size,
          child: Center(
            child: Container(
              width: widget.size * 0.20,
              height: widget.size * 0.20,
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            ),
          ),
        ),
        Container(
            width: widget.size,
            height: widget.size,
            decoration: new BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(widget.size*0.2),
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