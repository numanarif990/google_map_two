import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_map_two/custom_info_window.dart';
import 'package:google_map_two/get_user_current_location.dart';
import 'package:google_map_two/google_search_places_api.dart';
import 'package:google_map_two/latitude_to_address.dart';
import 'package:google_map_two/map_screen.dart';
import 'package:google_map_two/network_image_marker.dart';
import 'package:google_map_two/polygons_googlemap.dart';
import 'package:google_map_two/polylines_googlemap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'multiple_custom_markers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: false,
      ),
      home: const NetworkImageMarker(),
    );
  }
}


