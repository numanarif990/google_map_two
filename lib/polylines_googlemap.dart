import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolylinesGooglemap extends StatefulWidget {
  const PolylinesGooglemap({super.key});

  @override
  State<PolylinesGooglemap> createState() => _PolylinesGooglemapState();
}

class _PolylinesGooglemapState extends State<PolylinesGooglemap> {
  final CameraPosition _kGooglePlex =
      const CameraPosition(target: LatLng(33.113380, 73.761918), zoom: 15);
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _marker = {};
  final Set<Polyline> _polyline={};
final List<LatLng> _latlng = [
  const LatLng(33.113380, 73.761918),
  const LatLng(33.095805, 73.789442),
];

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    for(int i = 0; i< _latlng.length; i++){
      _marker.add(Marker(
          markerId: MarkerId(i.toString()),
        position: _latlng[i],
        infoWindow: const InfoWindow(
          title: "Cool place",
          snippet: '5 star rating'
        ),
        icon: BitmapDescriptor.defaultMarker
      ));
      setState(() {

      });
    }
    _polyline.add(Polyline(
        polylineId: const PolylineId('1'),
      points: _latlng,
      color: Colors.red,
      width: 3
    ));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Polylines",style: TextStyle(fontSize: 28),),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: GoogleMap(
          initialCameraPosition: _kGooglePlex,
        markers: _marker,
        polylines: _polyline,
        onMapCreated: (GoogleMapController controller){
            _controller.complete(controller);
        },
      ),
    );
  }
}
