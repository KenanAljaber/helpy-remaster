import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart'; // For handling LatLng coordinates
import 'package:helpy/models/user/user.dart';
import 'package:helpy/models/user/reputation.dart';
import 'package:helpy/widgets/map/user_popup.dart';

class MyMap extends StatefulWidget {
  const MyMap({super.key});

  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  User? selectedUser;
  bool showPopup = false;
  LatLng? selectedPinPosition;
  final MapController _mapController = MapController();

  // Sample user data - in a real app, this would come from your backend
  final List<User> users = [
    User(
      name: 'John Doe',
      email: 'john@example.com',
      helpWay: 'Help translating papers from English to Spanish',
      reputation: Reputation.empty(),
      photoLink: 'https://via.placeholder.com/60x60/FF6E4E/FFFFFF?text=JD',
    ),
    User(
      name: 'Sarah Smith',
      email: 'sarah@example.com',
      helpWay: 'Assist with grocery shopping and errands',
      reputation: Reputation.empty(),
      photoLink: 'https://via.placeholder.com/60x60/87643E/FFFFFF?text=SS',
    ),
  ];

  // Pin positions
  final List<LatLng> pinPositions = [
    const LatLng(37.7749, -122.4194), // San Francisco
    const LatLng(37.7849, -122.4094), // Oakland
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: const LatLng(37.7749, -122.4194), // Initial map center coordinates
            initialZoom: 10.0, // Initial zoom level
            onTap: (tapPosition, point) {
              // Close popup when tapping on the map
              if (showPopup) {
                setState(() {
                  showPopup = false;
                  selectedUser = null;
                  selectedPinPosition = null;
                });
              }
            },
          ),
          children: [
            TileLayer(
              userAgentPackageName: 'com.example.app',
              maxZoom: 19,
              urlTemplate:"https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: const ['a', 'b', 'c'],
            ),
            MarkerLayer(markers: [
              // First user marker
              Marker(
                point: pinPositions[0],
                child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedUser = users[0];
                        selectedPinPosition = pinPositions[0];
                        showPopup = true;
                      });
                    },
                    child: const Icon(Icons.location_on, color: Colors.red, size: 30)),
                width: 30,
                height: 30,
              ),
              // Second user marker
              Marker(
                point: pinPositions[1],
                child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedUser = users[1];
                        selectedPinPosition = pinPositions[1];
                        showPopup = true;
                      });
                    },
                    child: const Icon(Icons.location_on, color: Colors.red, size: 30)),
                width: 30,
                height: 30,
              ),
            ]),
          ],
        ),
        // Popup overlay positioned above the pin
        if (showPopup && selectedUser != null && selectedPinPosition != null)
          Positioned(
            left: _calculatePopupPosition(context).dx,
            top: _calculatePopupPosition(context).dy,
            child: UserPopup(
              user: selectedUser!,
              onClose: () {
                setState(() {
                  showPopup = false;
                  selectedUser = null;
                  selectedPinPosition = null;
                });
              },
            ),
          ),
      ],
    );
  }

  Offset _calculatePopupPosition(BuildContext context) {
    if (selectedPinPosition == null) {
      return const Offset(0, 0);
    }
    
    // Convert lat/lng coordinates to screen pixel coordinates
    final screenSize = MediaQuery.of(context).size;
    
    // Get the current map bounds and zoom
    final bounds = _mapController.camera.visibleBounds;
    final zoom = _mapController.camera.zoom;
    
    // Calculate the pixel position of the pin on screen
    final pinScreenPosition = _latLngToScreenPoint(
      selectedPinPosition!,
      bounds,
      screenSize,
      zoom,
    );
    
    // Position popup just above the pin
    const popupWidth = 280.0;
    const popupHeight = 150.0; // Approximate popup height
    const pinOffset = 40.0; // Distance above the pin
    
    // Center popup horizontally over the pin
    final popupX = pinScreenPosition.dx - (popupWidth / 2);
    
    // Position popup above the pin
    final popupY = pinScreenPosition.dy - popupHeight - pinOffset;
    
    // Ensure popup stays within screen bounds
    final adjustedX = popupX.clamp(10.0, screenSize.width - popupWidth - 10);
    final adjustedY = popupY.clamp(70.0, screenSize.height - popupHeight - 10);
    
    return Offset(adjustedX, adjustedY);
  }
  
  Offset _latLngToScreenPoint(LatLng latLng, LatLngBounds bounds, Size screenSize, double zoom) {
    // Simple approximation to convert lat/lng to screen coordinates
    final latRange = bounds.north - bounds.south;
    final lngRange = bounds.east - bounds.west;
    
    final x = ((latLng.longitude - bounds.west) / lngRange) * screenSize.width;
    final y = ((bounds.north - latLng.latitude) / latRange) * screenSize.height;
    
    return Offset(x, y);
  }
}
