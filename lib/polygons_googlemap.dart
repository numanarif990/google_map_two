import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolygonsGooglemap extends StatefulWidget {
  const PolygonsGooglemap({super.key});

  @override
  State<PolygonsGooglemap> createState() => _PolygonsGooglemapState();
}

class _PolygonsGooglemapState extends State<PolygonsGooglemap> {
  final CameraPosition _kGooglePlex =
      const CameraPosition(target: LatLng(33.113380, 73.761918), zoom: 16);
  final Completer<GoogleMapController> _controller = Completer();
  Set<Polygon> _polygon = HashSet<Polygon>();
  List<LatLng> points = [
    const LatLng(33.113380, 73.761918),
    const LatLng(33.099112, 73.758905),
    const LatLng(33.095805, 73.789442),
    const LatLng(33.113380, 73.761918),

  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _polygon.add(Polygon(
      polygonId: PolygonId("1"),
      points: points,
      fillColor: Colors.grey.withOpacity(0.5),
      geodesic: true,
      strokeWidth: 4,
      strokeColor: Colors.blue
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Polygon"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: GoogleMap(
        initialCameraPosition: _kGooglePlex,
        mapType: MapType.normal,
        myLocationButtonEnabled: true,
        myLocationEnabled: false,
        polygons: _polygon,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        zoomControlsEnabled: true,
      ),
    );
  }
}
