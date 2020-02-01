import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:niteapp/Backend/repository.dart';
import 'package:niteapp/Models/Event.dart';

class GoogleMapsPage extends StatefulWidget {

  final int day, month, year;

  const GoogleMapsPage({Key key, this.day, this.month, this.year}) : super(key: key);

  @override
  _GoogleMapsPageState createState() => _GoogleMapsPageState();

}
class _GoogleMapsPageState extends State<GoogleMapsPage> {

  CameraPosition _initialPosition = CameraPosition(target: LatLng(41.3955981, 2.1527464), zoom: 13);
  Completer<GoogleMapController> _controller = Completer();

  var _repository = Repository();
  List<Event> events;
  Set<Marker> markers = new Set<Marker>();
  String _mapStyle;


  void _onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(_mapStyle);
    _controller.complete(controller);
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
    for (int i = 0; i < events.length; i++){
      final Uint8List markerIcon = await getBytesFromCanvas(200, 200, 'assets/images/marker.png');
      Marker marker = new Marker(
        markerId: MarkerId(i.toString()),
        position: LatLng(double.parse(events[i].latitude), double.parse(events[i].longitude)),
        anchor: Offset(0.5, 0.5),
        infoWindow: InfoWindow(
          title: events[i].name,
          snippet: events[i].clubName),
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
        // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _repository.getEvents(widget.day.toString(), widget.month.toString(), widget.year.toString()),
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
                minMaxZoomPreference: MinMaxZoomPreference(13,16.5),
                markers: markers,
              )
            );
          }
      ),
    );
  }
}