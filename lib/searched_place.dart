import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchedPlace extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String address; // Changed to final for immutability

  SearchedPlace({super.key, required this.latitude, required this.longitude, required this.address});

  @override
  State<SearchedPlace> createState() => _SearchedPlaceState();
}

class _SearchedPlaceState extends State<SearchedPlace> {
  late CameraPosition _kGooglePlex;
  late List<Marker> _markers;
  final Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
    _kGooglePlex = CameraPosition(
      target: LatLng(widget.latitude, widget.longitude),
      zoom: 14.0,
    );
    _markers = <Marker>[
      Marker(
        markerId: MarkerId('1'),
        position: LatLng(widget.latitude, widget.longitude),
        infoWindow: InfoWindow(
          title: widget.address,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: _kGooglePlex,
        markers: Set<Marker>.of(_markers),
        mapType: MapType.hybrid,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
