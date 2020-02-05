import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:niteapp/Backend/repository.dart';
import 'package:niteapp/Models/Event.dart';
import 'package:niteapp/Ui/EventDetailsPage.dart';
import 'package:niteapp/Utils/AppLocalizations.dart';
import 'package:niteapp/Utils/Constants.dart';

class GoogleMapsPage extends StatefulWidget {

  final int day, month, year;
  final String uid;

  const GoogleMapsPage({Key key, this.day, this.month, this.year, this.uid}) : super(key: key);

  @override
  _GoogleMapsPageState createState() => _GoogleMapsPageState();

}
class _GoogleMapsPageState extends State<GoogleMapsPage> {

  CameraPosition _initialPosition = CameraPosition(target: LatLng(41.3955981, 2.1527464), zoom: 12);
  GoogleMapController googleMapController;

  var _repository = Repository();
  var _dateText;
  List<Event> events;
  Set<Marker> markers = new Set<Marker>();
  String _mapStyle;
  int day, month, year;
  bool firstBuild = true;
  bool clearMarkers = true;


  void _onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(_mapStyle);
    googleMapController = controller;
  }

  Future<Uint8List> getBytesFromCanvas(int width, int height, urlAsset) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final ByteData datai = await rootBundle.load(urlAsset);
    var imaged = await loadImage(new Uint8List.view(datai.buffer));
    canvas.drawImageRect(
      imaged,
      Rect.fromLTRB(0.0, 0.0, imaged.width.toDouble(), imaged.height.toDouble()),
      Rect.fromLTRB(0.0, 0.0, width.toDouble(), height.toDouble()),
      new Paint(),
    );

    final img = await pictureRecorder.endRecording().toImage(width, height);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data.buffer.asUint8List();
  }

  Future <ui.Image> loadImage(List <int> img) async {
    ui.Image image = await decodeImageFromList(img);
    return image;
  }


  void createMarkers() async{
    if(clearMarkers) {
      markers.clear();
      clearMarkers = false;
    }
    for (int i = 0; i < events.length; i++){
      final Uint8List markerIcon = await getBytesFromCanvas(100, 100, 'assets/images/map-marker.png');
      Marker marker = new Marker(
        markerId: MarkerId(i.toString()),
        position: LatLng(double.parse(events[i].latitude), double.parse(events[i].longitude)),
        anchor: Offset(0.5, 0.5),
        infoWindow: InfoWindow(
          title: events[i].name,
          snippet: events[i].clubName,
          onTap: () {
            Navigator.push(
                context,
                CupertinoPageRoute<Null>(
                  builder: (context) => EventDetailsPage(eid: events[i].id, uid: widget.uid,),
                  settings: RouteSettings(name: 'EventDetailsPage'),
                )
            );
          }
        ),
        icon: BitmapDescriptor.fromBytes(markerIcon),
      );

      setState(() {
        markers.add(marker);
      });
    }
  }

  List<Event> documentsToEvents(List<DocumentSnapshot> documents) {
    List<Event> events = new List<Event>();
    for(int i = 0; i < documents.length; i++) {
      events.add(Event.fromMap(documents[i].data, documents[i].documentID));
    }
    return events;
  }

  String retDateString(DateTime now, BuildContext context) {
    String locale = AppLocalizations.of(context).translate('locale');
    if(locale == 'es') return DateFormat.yMMMEd('es').format(now).toString();
    else return DateFormat.yMMMEd().format(now).toString();
  }

  void onDatePressed() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    Future<DateTime> selectedDate = showDatePicker(
        context: context,
        initialDate: DateTime(year,month,day),
        firstDate: DateTime(year-1),
        lastDate: DateTime(2025),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData(
              primaryColor: Constants.main,
              primarySwatch: Colors.pink,
              accentColor: Constants.accent,
              buttonColor: Constants.accent,
            ),
            child: child,
          );
        });

    selectedDate.then((value) {


      setState(() {
        _dateText = retDateString(value, context);
        markers.clear();
        clearMarkers = true;
        day = value.day;
        month = value.month;
        year = value.year;
        markers.clear();
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.white,
        ));
      });
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });

    day = widget.day;
    month = widget.month;
    year = widget.year;
  }


  @override
  Widget build(BuildContext context) {
    if(firstBuild) {
      firstBuild = false;
      setState(() {
        _dateText = retDateString(DateTime(year,month,day), context);
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('map')),
        // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: onDatePressed,
        backgroundColor: Constants.accent,
        label: Text(
          _dateText,
          style: TextStyle(
              color: Constants.white,
          ),
        ),
        icon: Icon(
          Icons.event,
          color: Constants.white,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _repository.getEvents(day.toString(), month.toString(), year.toString()),
          builder: (context, snapshot) {
            if(snapshot != null && snapshot.data != null
                && snapshot.data.documents != null && snapshot.data.documents.isNotEmpty) {
              events = documentsToEvents(snapshot.data.documents);
              WidgetsBinding.instance
                  .addPostFrameCallback((_) => createMarkers());
            }
            return Center(
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                mapType: MapType.normal,
                initialCameraPosition: _initialPosition,
                rotateGesturesEnabled: false,
                minMaxZoomPreference: MinMaxZoomPreference(12,16.5),
                markers: markers,
                myLocationButtonEnabled: false,
                myLocationEnabled: false,
              )
            );
          }
      ),
    );
  }
}