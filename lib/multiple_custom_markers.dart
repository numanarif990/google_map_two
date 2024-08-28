import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MultipleCustomMarkers extends StatefulWidget {
  const MultipleCustomMarkers({super.key});

  @override
  State<MultipleCustomMarkers> createState() => _MultipleCustomMarkersState();
}

class _MultipleCustomMarkersState extends State<MultipleCustomMarkers> {
  final CameraPosition _kGooglePlex =
  const CameraPosition(target: LatLng(33.6941, 72.9734), zoom: 13);
  final Completer<GoogleMapController> _controller = Completer();

  List<String> images = [
    'images/car.png',
    'images/car1.png',
    'images/motorbike.png',
    'images/taxi.png',
  ];

  final List<Marker> _markers = <Marker>[];
  final List<LatLng> _latlng = const <LatLng>[
    LatLng(33.6941, 72.9734),
    LatLng(33.7008, 72.9682),
    LatLng(33.6992, 72.9744),
    LatLng(33.6939, 72.9771),
  ];

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    final ByteData data = await rootBundle.load(path);
    final Uint8List bytes = data.buffer.asUint8List();
    final ui.Codec codec = await ui.instantiateImageCodec(bytes, targetWidth: width);
    final ui.FrameInfo fi = await codec.getNextFrame();
    final ByteData? byteData = await fi.image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }
  Future<BitmapDescriptor> _getMarkerIcon(String assetPath) async {
    final ImageConfiguration imageConfiguration = ImageConfiguration(size: Size(100, 100)); // Specify the desired size
    return BitmapDescriptor.fromAssetImage(imageConfiguration, assetPath);
  }
  Future<void> loadData() async {
    for (int i = 0; i < images.length; i++) {
      // final Uint8List markerIcon = await getBytesFromAsset(images[i], 200); // Adjust size as needed
      final BitmapDescriptor markerIcon = await _getMarkerIcon(images[i]);
      _markers.add(Marker(
        markerId: MarkerId(i.toString()),
        // icon: BitmapDescriptor.fromBytes(markerIcon),
        icon: markerIcon,
        position: _latlng[i],
        infoWindow: InfoWindow(
          title: "This is marker : $i",
        ),
      ));
    }
    setState(() {}); // Call setState once after adding all markers
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: _kGooglePlex,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: Set<Marker>.of(_markers),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
