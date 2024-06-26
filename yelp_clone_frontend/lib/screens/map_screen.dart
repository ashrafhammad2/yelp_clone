
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  Position? _currentPosition;
  String _mapStyle = '';
  Set<Marker> _markers = {};
  List<Map<String, dynamic>> _businesses = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadMapStyle();
    _fetchBusinesses();
  }

  Future<void> _loadMapStyle() async {
    _mapStyle = await rootBundle.loadString('assets/map_style.json');
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
    });

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 14.0,
      ),
    ));
  }

  Future<void> _fetchBusinesses() async {
    final response = await http.get(Uri.parse('http://your-backend-url/api/businesses/'));
    if (response.statusCode == 200) {
      setState(() {
        _businesses = List<Map<String, dynamic>>.from(json.decode(response.body));
        _setMarkers();
      });
    } else {
      throw Exception('Failed to load businesses');
    }
  }

  void _setMarkers() {
    _businesses.forEach((business) {
      final marker = Marker(
        markerId: MarkerId(business['id'].toString()),
        position: LatLng(business['latitude'], business['longitude']),
        infoWindow: InfoWindow(
          title: business['name'],
          snippet: business['description'],
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          business['hasDiscount'] ? BitmapDescriptor.hueBlue : BitmapDescriptor.hueRed,
        ),
      );
      _markers.add(marker);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              // Implement filter functionality
            },
          ),
        ],
      ),
      body: _currentPosition == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                zoom: 14,
              ),
              onMapCreated: (GoogleMapController controller) {
                controller.setMapStyle(_mapStyle);
                _controller.complete(controller);
              },
              markers: _markers,
            ),
    );
  }
}
