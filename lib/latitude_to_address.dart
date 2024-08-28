import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

class LatitudeToAddress extends StatefulWidget {
  const LatitudeToAddress({super.key});

  @override
  State<LatitudeToAddress> createState() => _LatitudeToAddressState();
}

class _LatitudeToAddressState extends State<LatitudeToAddress> {
  String _address = "Press the button to get the address";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Address Conversion"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _address,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            InkWell(
                onTap: () async {
                  try {
                    List<Placemark> placemarks = await placemarkFromCoordinates(32.1877,74.1945);
                    if (placemarks.isNotEmpty) {
                      Placemark place = placemarks[0];
                      setState(() {
                        _address = "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
                      });
                    } else {
                      setState(() {
                        _address = "No address found.";
                      });
                    }
                  } catch (e) {
                    setState(() {
                      _address = "Failed to get address: $e";
                    });
                  }
                },

              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.cyan,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: const Center(
                  child: Text("Convert", style: TextStyle(
                      fontSize: 30,
                      color: Colors.white),),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
