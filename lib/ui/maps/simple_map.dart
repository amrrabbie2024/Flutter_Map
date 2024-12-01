import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MySampleMap extends StatefulWidget {
  const MySampleMap({super.key});

  @override
  State<MySampleMap> createState() => _MySampleMapState();
}

LatLng initalLocation=LatLng(31.037933, 31.381523);

class _MySampleMapState extends State<MySampleMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: initalLocation,
            zoom: 13,
          ),
          mapType: MapType.hybrid,
          zoomControlsEnabled: true,
          onTap: (argument) {
            print("Onpress:- ${argument.latitude}-${argument.longitude}");
          },
          onLongPress: (argument) {
            print("OnLongPress:- ${argument.latitude}-${argument.longitude}");
          },
        ),
      ),
    );
  }
}
