import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart'; // For handling LatLng coordinates
import 'package:geolocator/geolocator.dart';

import 'package:helpy/models/user/user.dart';
import 'package:helpy/models/user/reputation.dart';
import 'package:helpy/widgets/map/user_popup.dart';
import 'package:helpy/styles/theme.dart';
import 'package:helpy/utils/utility_methods.dart';
import 'package:helpy/utils/demo_data_service.dart';

class MyMap extends StatefulWidget {
  const MyMap({super.key});

  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> with AutomaticKeepAliveClientMixin {
  User? selectedUser;
  bool showPopup = false;
  LatLng? selectedPinPosition;
  MapController? _mapController;

  // Location state
  LatLng? _userLocation;
  bool _isLoadingLocation = true;

  // Demo users
  List<User> _demoUsers = [];

  @override
  bool get wantKeepAlive => true;

  Future<void> _getUserLocation() async {
    try {
      setState(() {
        _isLoadingLocation = true;
      });

      // Get current position using utility method
      final position = await UtilityMethods.getCurrentLocation();

      if (mounted && position != null) {
        setState(() {
          _userLocation = LatLng(position.latitude, position.longitude);
          _isLoadingLocation = false;
        });

        // Generate demo users around the current location
        _generateDemoUsers();

        // Move map to user location
        if (_mapController != null) {
          _mapController!.move(_userLocation!, 15.0);
        }
      } else if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }

  void _generateDemoUsers() {
    if (_userLocation != null) {
      setState(() {
        _demoUsers =
            DemoDataService.generateDemoUsers(_userLocation!, count: 12);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialize map controller
    _mapController = MapController();
    // Get user location
    _getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    // Show loading screen while getting location
    if (_isLoadingLocation) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Getting your location...',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.almostBlack,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please wait while we locate you',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController!,
          options: MapOptions(
            initialCenter: _userLocation ??
                const LatLng(
                    37.7749, -122.4194), // Use user location or fallback
            initialZoom: _userLocation != null
                ? 15.0
                : 10.0, // Closer zoom if user location available
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
              userAgentPackageName: 'com.example.helpy',
              maxZoom: 18, // Reduced max zoom for better performance
              minZoom: 3, // Set minimum zoom
              keepBuffer: 2, // Reduce tile buffer for memory efficiency
              panBuffer: 1, // Reduce pan buffer
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: const ['a', 'b', 'c'],
              // backgroundColor: Colors.grey[200], // Add background color while loading
            ),
            MarkerLayer(markers: [
              // User's current location marker
              if (_userLocation != null)
                Marker(
                  point: _userLocation!,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.my_location,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  width: 30,
                  height: 30,
                ),
              // Demo users markers
              ..._demoUsers
                  .map((user) {
                    if (user.location != null) {
                      return Marker(
                        point: user.location!,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedUser = user;
                              selectedPinPosition = user.location!;
                              showPopup = true;
                            });
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Image.network(
                                user.photoLink,
                                width: 36,
                                height: 36,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 36,
                                    height: 36,
                                    color: AppColors.secondaryColor,
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  );
                                },
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    width: 36,
                                    height: 36,
                                    color: Colors.grey[300],
                                    child: const Center(
                                      child: SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        width: 40,
                        height: 40,
                      );
                    }
                    return null;
                  })
                  .where((marker) => marker != null)
                  .cast<Marker>(),
            ]),
          ],
        ),
        // Popup overlay positioned above the pin
        if (showPopup && selectedUser != null && selectedPinPosition != null)
          Positioned.fill(
            child: Stack(
              children: [
                // Semi-transparent overlay to handle tap outside
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        showPopup = false;
                        selectedUser = null;
                        selectedPinPosition = null;
                      });
                    },
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
                ),
                // Popup positioned in the center of the screen
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: UserPopup(
                      user: selectedUser!,
                      userLocation: _userLocation,
                      onClose: () {
                        setState(() {
                          showPopup = false;
                          selectedUser = null;
                          selectedPinPosition = null;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        // My Location button
        if (_userLocation != null)
          Positioned(
            bottom: 20, // Position above bottom navigation bar
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                _mapController?.move(_userLocation!, 15.0);
              },
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              child: const Icon(Icons.my_location),
            ),
          ),
      ],
    );
  }
}
