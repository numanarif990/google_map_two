import 'dart:async';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomWindow extends StatefulWidget {
  const CustomWindow({super.key});

  @override
  State<CustomWindow> createState() => _CustomWindowState();
}

class _CustomWindowState extends State<CustomWindow> {
  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  final List<Marker> _marker = <Marker>[];
  final List<LatLng> _latlng = const <LatLng>[
    LatLng(33.6941, 72.9734),
    LatLng(33.7008, 72.9682),
    LatLng(33.6992, 72.9744),
    LatLng(33.6939, 72.9771),
  ];
  final CameraPosition _kGooglePlex =
      const CameraPosition(target: LatLng(33.6941, 72.9734), zoom: 13);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  void loadData() {
    for (int i = 0; i < _latlng.length; i++) {
      if(i%2==0){
        _marker.add(Marker(
            markerId: MarkerId(i.toString()),
            position: _latlng[i],
            icon: BitmapDescriptor.defaultMarker,
            onTap: () {
              _customInfoWindowController.addInfoWindow!(
                  Container(
                    height: 200,
                    width: 300,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey, ),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Column(mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 100,
                          width: 300,
                          decoration:   const BoxDecoration(
                              image: DecorationImage(image: NetworkImage('https://images.pexels.com/photos/27776677/pexels-photo-27776677/free-photo-of-uluyayla.jpeg?auto=compress&cs=tinysrgb&w=600&lazy=load'),
                                  fit: BoxFit.fitWidth,
                                  filterQuality: FilterQuality.high),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              color: Colors.red
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(children: [
                            SizedBox(
                              width: 100,
                              child: Text("Kashmir", style: TextStyle(fontSize: 23,),maxLines: 1, overflow: TextOverflow.fade,softWrap: false,),
                            ),
                            Spacer(),
                            Text("pk")
                          ],),
                        ),
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Lorem Ipsum is simply dummy text of the printing and text ever since the 1500s",),
                          ),
                        )
                      ],
                    ),
                  ),
                  _latlng[i]);
            }));
      }else{
        _marker.add(Marker(
            markerId: MarkerId(i.toString()),
            position: _latlng[i],
            icon: BitmapDescriptor.defaultMarker,
            onTap: () {
              _customInfoWindowController.addInfoWindow!(
                  Container(
                    height: 200,
                    width: 300,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey, ),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Column(mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 100,
                          width: 300,
                          decoration:   const BoxDecoration(
                              image: DecorationImage(image: NetworkImage('https://images.pexels.com/photos/10855236/pexels-photo-10855236.jpeg?auto=compress&cs=tinysrgb&w=600&lazy=load'),
                                  fit: BoxFit.fitWidth,
                                  filterQuality: FilterQuality.high),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              color: Colors.red
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(children: [
                            SizedBox(
                              width: 100,
                              child: Text("Kashmir", style: TextStyle(fontSize: 23,),maxLines: 1, overflow: TextOverflow.fade,softWrap: false,),
                            ),
                            Spacer(),
                            Text("pk")
                          ],),
                        ),
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Lorem Ipsum is simply dummy text of the printing and text ever since the 1500s",),
                          ),
                        )
                      ],
                    ),
                  ),
                  _latlng[i]);
            }));
      }

    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Custom Info Window"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _customInfoWindowController.googleMapController = controller;
            },
            onTap: (position) {
              _customInfoWindowController.hideInfoWindow!();
            },
            onCameraMove: (Position){
              _customInfoWindowController.onCameraMove!();
            },
            markers: Set<Marker>.of(_marker),
          ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 200,
            width: 300,
            offset: 35,
          )
        ],
      ),
    );
  }
}
