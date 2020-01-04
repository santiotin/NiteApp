import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsPage extends StatefulWidget {

  const GoogleMapsPage({Key key}) : super(key: key);

  @override
  _GoogleMapsPageState createState() => _GoogleMapsPageState();

}
class _GoogleMapsPageState extends State<GoogleMapsPage> {

  CameraPosition _initialPosition = CameraPosition(target: LatLng(26.8206, 30.8025));
  Completer<GoogleMapController> _controller = Completer();


  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wikipedia Explorer'),
        // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.3,
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: _initialPosition,
            scrollGesturesEnabled: false,
            zoomGesturesEnabled: false,
            rotateGesturesEnabled: false,
            minMaxZoomPreference: MinMaxZoomPreference(15,15),
          ),
        )
      ),
    );
  }
}