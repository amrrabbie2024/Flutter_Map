import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AdvancedMap extends StatefulWidget {
  const AdvancedMap({super.key});

  @override
  State<AdvancedMap> createState() => _AdvancedMapState();
}

double srclate=31.0449837;
double srclong=31.3655877;

double deslate=30.9418137;
double deslong=31.3023269;

class _AdvancedMapState extends State<AdvancedMap> {

  GoogleMapController? _mapController;


  LatLng _initialLatLng=LatLng(srclate, srclong);
  LatLng srcLatlng=LatLng(srclate, srclong);
  LatLng desLatlng=LatLng(deslate,deslong );
  Marker? srcMarker;
  Marker? desMarker;
  CameraPosition _cameraPosition=CameraPosition(target: LatLng(srclate, srclong),zoom: 11.0);
  bool? _serviceEnabled;

  @override
  void initState() {
    checkServiceEnabled().then((value) {
      print('Service Enabled $value');
      setState(() {
        _serviceEnabled=value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(_serviceEnabled != null && _serviceEnabled == true){
      try{
        checkPersimisons().then((value) {
          if(value) getCurrentLocation();
          else print('Need Permision');
        });
      }catch(error){
        print(error.toString());
      }
    }

    srcMarker=Marker(markerId: MarkerId('1'),
        icon: BitmapDescriptor.defaultMarkerWithHue(90),
        position: srcLatlng,
        infoWindow: InfoWindow(title: 'Marker 1'));

    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: _cameraPosition,
        mapType: MapType.normal,
        onMapCreated: (controller){
          setState(() {
            _mapController=controller;
          });
        },
        onLongPress: (argument){
          print('${argument.longitude},${argument.longitude}');
          CameraUpdate cameraUpdate=CameraUpdate.newLatLngZoom(LatLng(argument.latitude, argument.longitude), 11.0);
          _mapController!.animateCamera(cameraUpdate);
          setState(() {
            desMarker=Marker(markerId: MarkerId('2'),
                icon: BitmapDescriptor.defaultMarkerWithHue(10),
                position: LatLng(argument.latitude,argument.longitude),
                infoWindow: InfoWindow(title: 'Marker 2'));
          });
        },
        markers:  setMarkers(),
      ),
    );
  }

  Future<bool> checkServiceEnabled() {
    return Geolocator.isLocationServiceEnabled();
  }

  Future<bool> checkPersimisons() async {
    LocationPermission locationPermission=await Geolocator.checkPermission();
    print('${locationPermission.toString()}');
    if(locationPermission != LocationPermission.denied){
      return true;
    }else{
      Geolocator.requestPermission().then((permision) {
        if(permision != LocationPermission.denied){
          return true;
        }
      });
      return false;
    }

  }

  void getCurrentLocation() {
    print('Get current location');
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best,timeLimit: Duration(seconds: 5)).then((currentposition) {
      setState(() {
        desMarker=Marker(markerId: MarkerId('currentPosition'),position:LatLng(currentposition.latitude,currentposition.longitude),icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue));
      });
    });
  }

  Set<Marker> setMarkers() {
    Set<Marker> markers={srcMarker!};
    if(desMarker != null) markers.add(desMarker!);
    return markers;
  }

  Marker _addMarker(LatLng latLng, String id) {
    return Marker(
        markerId: MarkerId(id),
        icon: BitmapDescriptor.defaultMarkerWithHue(20),
        position: latLng,
        infoWindow: InfoWindow(title: id));
  }
}
