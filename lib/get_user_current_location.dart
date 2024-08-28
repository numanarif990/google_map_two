import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GetUserCurrentLocation extends StatefulWidget {
  const GetUserCurrentLocation({super.key});

  @override
  State<GetUserCurrentLocation> createState() => _GetUserCurrentLocationState();
}

class _GetUserCurrentLocationState extends State<GetUserCurrentLocation> {
  String _address = "";
  bool _isAddressAvailable = false;
  // This widget is the root of your application.
  final Completer<GoogleMapController> _controller = Completer();
  static const CameraPosition _kGooglePlex =
      CameraPosition(target: LatLng(33.4, 73.9), zoom: 13);
  final List<Marker> _markers = <Marker>[
    Marker(
        markerId: MarkerId("1"),
        position: LatLng(33.4, 73.9),
        infoWindow: InfoWindow(title: "The title of marker"))
  ];

  Future<Position> getCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((onValue) {})
        .onError((error, stackTrace) {
      print(error);
    });
    return await Geolocator.getCurrentPosition();
  }
  Future<void> _getAddress(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _isAddressAvailable = true;
          _address = "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}, ${place.street}, ${place.postalCode}";
        });
      } else {
        setState(() {
          _address = "No address found.";
        });
      }
    } catch (e) {
      print("Error fetching placemarks: $e");
      setState(() {
        _address = "Failed to get address. Retrying...";
      });

      // Retry after a delay
      Future.delayed(Duration(seconds: 3), () {
        _getAddress(lat, lng);  // Retry the request
      });
    }
  }

  loadData(){

}
@override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: _kGooglePlex,
              markers: Set<Marker>.of(_markers),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
          Visibility(
            visible: _isAddressAvailable,
            child: Container(
              height: 150,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 50,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: const Center(child: Text("Address",style: TextStyle(fontSize: 28, color: Colors.white),)),
                    ),
                    Text(_address,textAlign: TextAlign.center, style: TextStyle(fontSize: 20, ),)
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getCurrentLocation().then((onValue) async{
            print("my current location");
            print(onValue.latitude.toString() +
                " " +
                onValue.longitude.toString());
            await _getAddress(onValue.latitude.toDouble(), onValue.longitude.toDouble());
            _markers.add(Marker(
                markerId: const MarkerId('2'),
                position: LatLng(onValue.latitude, onValue.longitude),
                infoWindow: const InfoWindow(title: "My current location")));
            CameraPosition cameraPosition = CameraPosition(
                zoom: 13,
                target: LatLng(onValue.latitude, onValue.longitude));
            final GoogleMapController controller = await _controller.future;
            controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
            setState(() {

            });
          });
        },
        child: const Icon(Icons.location_searching),
      ),
    );
  }
}
