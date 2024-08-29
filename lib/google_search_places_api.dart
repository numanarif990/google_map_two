import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_map_two/searched_place.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class GoogleSearchPlacesApi extends StatefulWidget {
  const GoogleSearchPlacesApi({super.key});

  @override
  State<GoogleSearchPlacesApi> createState() => _GoogleSearchPlacesApiState();
}

class _GoogleSearchPlacesApiState extends State<GoogleSearchPlacesApi> {
  TextEditingController placeController = TextEditingController();
  var uuid = Uuid();
  String _sessionToken = '12234';
  List<dynamic> _placesList = [];

  @override
  void initState() {
    super.initState();
    _sessionToken = uuid.v4();  // Initialize session token
    placeController.addListener(onChange);
  }

  void onChange() {
    final input = placeController.text;
    if (input.isEmpty) {
      setState(() {
        _placesList = [];
      });
      return;
    }

    if (_sessionToken.isEmpty || _sessionToken == '12234') {
      setState(() {
        _sessionToken = uuid.v4();  // Reset session token
      });
    }

    getSuggestion(input);
  }

  void getSuggestion(String input) async {
    String KGOOGLE_PLACES_API = "place your api here";
    String baseUrl = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$baseUrl?input=$input&key=$KGOOGLE_PLACES_API&sessiontoken=$_sessionToken';

    try {
      var response = await http.get(Uri.parse(request));
      if (response.statusCode == 200) {
        setState(() {
          _placesList = jsonDecode(response.body)['predictions'];
        });
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Places"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TextFormField(
            controller: placeController,
            style: const TextStyle(fontSize: 20),
            decoration: const InputDecoration(
              hintText: "Search Places with name",
              hintStyle: TextStyle(fontSize: 20, color: Colors.grey),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: _placesList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () async {
                      List<Location> locations = await locationFromAddress(_placesList[index]['description']);
                      Location latlang = locations[0];
                      double latitude = latlang.latitude;
                      double longitude = latlang.longitude;
                      String address = _placesList[index]['description'];
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SearchedPlace(latitude: latitude, longitude: longitude, address: address)));
                      print("location: ${latlang.latitude}, ${latlang.longitude}");
                    },
                    title: Text(_placesList[index]['description']),
                  );
                }
            ),
          ),
        ],
      ),
    );
  }
}
