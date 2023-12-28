import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart'; // For handling LatLng coordinates

class MyMap extends StatefulWidget {
  const MyMap({super.key});

  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: MapController(),
      options: const MapOptions(
        center: LatLng(37.7749, -122.4194), // Initial map center coordinates
        zoom: 10.0, // Initial zoom level
      ),
      children: [
        TileLayer(
          userAgentPackageName: 'com.example.app',
          maxZoom: 19,
          urlTemplate:"https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
        ),
        MarkerLayer(markers: [
          Marker(
            point: const LatLng(37.7749, -122.4194),
            child: InkWell(
                onTap: () {
                  print("hello");
                },
                child: const Icon(Icons.location_on, color: Colors.red)),
            width: 10,
            height: 10,
          )
        ]),
      ],
    );
  }
}
