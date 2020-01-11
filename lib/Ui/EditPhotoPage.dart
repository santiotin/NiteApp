import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:niteapp/Backend/repository.dart';
import 'package:niteapp/Models/User.dart';
import 'package:niteapp/Ui/Widgets/CircularImage.dart';
import 'package:niteapp/Utils/Constants.dart';

class EditPhotoPage extends StatefulWidget {
  @override
  _EditPhotoPageState createState() => _EditPhotoPageState();
}

class _EditPhotoPageState extends State<EditPhotoPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _repository = new Repository();

  File _image;
  User user;
  bool isLoading;
  bool isUploading;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
      print(image);
      print(_image);
    });
    retrieveLostData();
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response =
    await ImagePicker.retrieveLostData();
    if (response == null) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image = response.file;
      });
    }
  }

  void getUser() async {
    user = await _repository.getCurrentUserDetails();
    setState(() {
      isLoading = false;
    });
  }

  Future<bool> uploadPhoto() async {
    bool result = await _repository.uploadPhoto(_image);
    setState(() {
      isUploading = false;
    });
    if(result) {
      _image = null;
      isLoading = true;
      getUser();
      showInSnackBar('Se ha cambiado la imagen correctamente');
    }
    else showInSnackBar('No se ha podido cambiar la imagen');
  }

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
      backgroundColor: Constants.accent,
      duration: Duration(seconds: 2),
    ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = true;
    getUser();
    isUploading = false;
  }

  void saveImage(){
    if(_image == null) {
      showInSnackBar('Selecciona una imagen');
    } else {
      setState(() {
        isUploading = true;
      });
      uploadPhoto();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Editar Foto'),
      ),
      body: isUploading ?
        Center(child: CircularProgressIndicator(),) :
        Center(
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Center(
                child: isLoading ?
                  CircularProgressIndicator() :
                  CircularImage(size: MediaQuery.of(context).size.height * 0.3, image: user.imageUrl,),
              ),
            ),
            Container(
              child: Icon(Icons.arrow_upward,size: 40,),
            ),
            Container(
              padding: EdgeInsets.all(50.0),
              height: MediaQuery.of(context).size.height * 0.4,
              child: Center(
                child: _image == null ?
                RawMaterialButton(
                  onPressed: getImage,
                  child: new Icon(
                    Icons.photo_library,
                    color: Constants.accent,
                    size: 35.0,
                  ),
                  shape: new CircleBorder(),
                  elevation: 4.0,
                  fillColor: Colors.white,
                  padding: const EdgeInsets.all(100.0),
                ):
                GestureDetector(
                  onTap: getImage,
                  child: Stack(
                    children: <Widget>[
                      Center(child: CircularProgressIndicator()),
                      Center(child: CircularImage(size: MediaQuery.of(context).size.height * 0.3, file: _image,)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: saveImage,
        tooltip: 'Save',
        child: Icon(
          Icons.check,
          color: Constants.white,
        ),
      ),
    );
  }
}