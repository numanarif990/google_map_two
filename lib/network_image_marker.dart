import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NetworkImageMarker extends StatefulWidget {
  const NetworkImageMarker({super.key});

  @override
  State<NetworkImageMarker> createState() => _NetworkImageMarkerState();
}

class _NetworkImageMarkerState extends State<NetworkImageMarker> {
  final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(33.113380, 73.761918),
    zoom: 15,
  );
  final Completer<GoogleMapController> _controller = Completer();
  final List<Marker> _markers = [];
  final List<LatLng> _latlng = [
    const LatLng(33.113380, 73.761918),
    const LatLng(33.099112, 73.758905),
    const LatLng(33.095805, 73.789442),
  ];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    for (int i = 0; i < _latlng.length; i++) {
      Uint8List? image = await loadNetworkImage(
          'https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&w=600');

      if (image != null) {
        final ui.Codec markerImageCodec = await ui.instantiateImageCodec(
          image,
          targetHeight: 100,
          targetWidth: 100,
        );

        final ui.FrameInfo frameInfo = await markerImageCodec.getNextFrame();
        final ByteData? byteData =
        await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);

        if (byteData != null) {
          final Uint8List resizedImageMarker = byteData.buffer.asUint8List();
          _markers.add(
            Marker(
              markerId: MarkerId(i.toString()),
              position: _latlng[i],
              icon: BitmapDescriptor.fromBytes(resizedImageMarker),
              infoWindow: InfoWindow(
                title: "Chakkaas " + i.toString(),
                snippet: "wow",
              ),
            ),
          );
        }
      }
    }

    setState(() {}); // Trigger rebuild after markers are loaded
  }

  Future<Uint8List?> loadNetworkImage(String path) async {
    try {
      final completed = Completer<ImageInfo>();
      var image = NetworkImage(path);
      image.resolve(const ImageConfiguration()).addListener(
        ImageStreamListener(
              (info, _) => completed.complete(info),
          onError: (dynamic error, StackTrace? stackTrace) {
            completed.completeError(error, stackTrace);
          },
        ),
      );
      final imageInfo = await completed.future;
      final byteData =
      await imageInfo.image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      print('Failed to load image: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Network Image Marker",
          style: TextStyle(fontSize: 28),
        ),
        centerTitle: true,
        backgroundColor: Colors.brown,
      ),
      body: GoogleMap(
        initialCameraPosition: _kGooglePlex,
        markers: Set<Marker>.of(_markers),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
