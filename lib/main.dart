import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Mapz',
      theme: ThemeData(
        colorSchemeSeed: Colors.blueAccent,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const double _defaultLat = 8.555;
  static const double _defaultLng = 38.811;
  static const CameraPosition _defaultLocation =
      CameraPosition(target: LatLng(_defaultLat, _defaultLng), zoom: 15);
  MapType _currentMapType = MapType.normal;
  final Set<Marker> _markers = {};
  late final GoogleMapController _googleMapController;
  void _addMarker() {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('defaultLocation'),
          position: _defaultLocation.target,
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: const InfoWindow(
            title: 'Really cool Place',
            snippet: '5 star rating',
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Google Map"),
          centerTitle: true,
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: (controller) => _googleMapController = controller,
              initialCameraPosition: _defaultLocation,
              mapType: _currentMapType,
              markers: _markers,
            ),
            Container(
              padding: const EdgeInsets.only(top: 24, right: 12),
              alignment: Alignment.topRight,
              child: Column(
                children: <Widget>[
                  FloatingActionButton(
                    onPressed: _changeMapType,
                    backgroundColor: Colors.green,
                    child: const Icon(
                      Icons.map,
                      size: 30.0,
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  FloatingActionButton(
                    onPressed: _addMarker,
                    backgroundColor: Colors.deepPurpleAccent,
                    child: const Icon(
                      Icons.add_location,
                      size: 36.0,
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  FloatingActionButton(
                    onPressed: _moveToNewLocaiton,
                    backgroundColor: Colors.indigoAccent,
                    child: const Icon(
                      Icons.location_city,
                      size: 36,
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  FloatingActionButton(
                    onPressed: _goToDefaultLocaiton,
                    backgroundColor: Colors.red,
                    child: const Icon(
                      Icons.home_rounded,
                      size: 36.0,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );

  void _changeMapType() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  Future<void> _moveToNewLocaiton() async {
    const newPosition = LatLng(40.7128, -74.0060);
    _googleMapController.animateCamera(
      CameraUpdate.newLatLngZoom(
        newPosition,
        15,
      ),
    );
    setState(() {
      const marker = Marker(
        markerId: MarkerId('newLocation'),
        position: newPosition,
        infoWindow: InfoWindow(title: 'New York', snippet: 'The Best place'),
      );
      _markers
        ..clear()
        ..add(marker);
    });
  }

  Future<void> _goToDefaultLocaiton() async {
    const _defaultPosition = LatLng(_defaultLat, _defaultLng);
    _googleMapController
        .animateCamera(CameraUpdate.newLatLngZoom(_defaultPosition, 15));
    setState(() {
      const marker = Marker(
        markerId: MarkerId('My Default Location'),
        position: _defaultPosition,
        infoWindow: InfoWindow(title: 'Home', snippet: 'The Best Place'),
      );
      _markers
        ..clear()
        ..add(marker);
    });
  }
}
