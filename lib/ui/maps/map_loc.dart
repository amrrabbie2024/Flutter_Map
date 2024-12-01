import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyCurrentLocation extends StatefulWidget {
  const MyCurrentLocation({Key? key}) : super(key: key);

  @override
  _MyCurrentLocationState createState() => _MyCurrentLocationState();
}

class _MyCurrentLocationState extends State<MyCurrentLocation> {
  GoogleMapController? _mapController;
  LatLng _initialLatLng = LatLng(31.0449837, 31.3655877);
  LatLng srcLatLng = LatLng(31.0449837, 31.3655877);
  LatLng desLatLng = LatLng(30.9418137, 31.3023269);
  Marker? desMarker;
  Marker? srcMarker;
  CameraPosition _cameraPosition =
      CameraPosition(target: LatLng(31.0449837, 31.3655877), zoom: 11.0);
  bool? _serviceEnabled;
  @override
  void initState() {
    checkServiceEnabled().then((value){
      print('Service Enabled $value');
      setState(() {
        _serviceEnabled = value;
      });

    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    if(_serviceEnabled!=null && _serviceEnabled== true){
      try {
        checkPermissions().then((value) {
          if(value) getCurrentPosition();
          else print('Need Permission');
        });

      }catch(e){
        print(e.toString());
      }
    }
    srcMarker = Marker(
        markerId: MarkerId('1'),
        icon: BitmapDescriptor.defaultMarkerWithHue(90),
        position: srcLatLng,
        infoWindow: InfoWindow(title: 'Marker 1'));

    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: _cameraPosition,
        mapType: MapType.normal,
        onMapCreated: (controller) {
          setState(() {
            _mapController = controller;
          });
        },
        onLongPress: (argument) {
          print('${argument.latitude},${argument.longitude}');
          // _addMarker(LatLng(argument.latitude,argument.longitude));
          CameraUpdate cameraUpdate = CameraUpdate.newLatLngZoom(
              LatLng(argument.latitude, argument.longitude), 11.0);
          _mapController?.animateCamera(cameraUpdate);
          setState(() {
            desMarker = Marker(
                markerId: MarkerId('2'),
                icon: BitmapDescriptor.defaultMarkerWithHue(10),
                position: LatLng(argument.latitude, argument.longitude),
                infoWindow: InfoWindow(title: '2'));
          });
        },
        markers: setMarkers(),
      ),
    );
  }

  Set<Marker> setMarkers() {
    Set<Marker> markers = {srcMarker!};
    if(desMarker!= null) markers.add(desMarker!);

    return markers;
  }

  Marker _addMarker(LatLng latLng, String id) {
    return Marker(
        markerId: MarkerId(id),
        icon: BitmapDescriptor.defaultMarkerWithHue(20),
        position: latLng,
        infoWindow: InfoWindow(title: id));
  }

  Future<bool> checkServiceEnabled() {
    return Geolocator.isLocationServiceEnabled();
  }

  Future<bool> checkPermissions() async {

    LocationPermission locationPermission = await Geolocator.checkPermission();
    print('${locationPermission.toString()}');
    if(locationPermission != LocationPermission.denied){
      return true;
    }else{
      Geolocator.requestPermission().then((permission){
        if(permission != LocationPermission.denied){
         return true;
        }
      });
      return false;

    }
  }

  getCurrentPosition() {
    print('Get Current Position');
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best,timeLimit: Duration(seconds: 5)).then((currentPosition) {
      setState(() {
        desMarker = Marker(markerId: MarkerId('currentPosition'),position: LatLng(currentPosition.latitude,currentPosition.longitude),icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue));
      });
    });
  }
}

