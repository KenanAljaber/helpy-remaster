import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:helpy/utils/utility_methods.dart';
import 'package:helpy/styles/theme.dart';

class LocationPicker extends StatefulWidget {
  final double? initialLatitude;
  final double? initialLongitude;
  final Function(double latitude, double longitude)? onLocationSelected;
  final double height;
  final bool showCurrentLocationButton;

  const LocationPicker({
    super.key,
    this.initialLatitude,
    this.initialLongitude,
    this.onLocationSelected,
    this.height = 200,
    this.showCurrentLocationButton = true,
  });

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  MapController? _mapController;
  LatLng? _selectedLocation;
  LatLng? _userLocation;
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();

    // Set initial location
    if (widget.initialLatitude != null && widget.initialLongitude != null) {
      _selectedLocation =
          LatLng(widget.initialLatitude!, widget.initialLongitude!);
    }

    // Get user's current location
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      final position = await UtilityMethods.getCurrentLocation();
      if (mounted && position != null) {
        setState(() {
          _userLocation = LatLng(position.latitude, position.longitude);
          // If no location is selected yet, use user's location as default
          if (_selectedLocation == null) {
            _selectedLocation = _userLocation;
            widget.onLocationSelected?.call(
              position.latitude,
              position.longitude,
            );
          }
        });

        // Move map to user location if no initial location was provided
        if (widget.initialLatitude == null && widget.initialLongitude == null) {
          _mapController?.move(_userLocation!, 15.0);
        }
      }
    } catch (e) {
      // If we can't get user location, use a default location
      if (_selectedLocation == null) {
        _selectedLocation = const LatLng(37.7749, -122.4194); // San Francisco
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }

  void _onMapTap(TapPosition tapPosition, LatLng point) {
    setState(() {
      _selectedLocation = point;
    });

    widget.onLocationSelected?.call(point.latitude, point.longitude);
  }

  void _goToCurrentLocation() {
    if (_userLocation != null) {
      setState(() {
        _selectedLocation = _userLocation;
      });

      _mapController?.move(_userLocation!, 15.0);
      widget.onLocationSelected?.call(
        _userLocation!.latitude,
        _userLocation!.longitude,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            FlutterMap(
              mapController: _mapController!,
              options: MapOptions(
                initialCenter:
                    _selectedLocation ?? const LatLng(37.7749, -122.4194),
                initialZoom: 15.0,
                onTap: _onMapTap,
                interactionOptions: const InteractionOptions(
                  enableMultiFingerGestureRace: false,
                ),
              ),
              children: [
                TileLayer(
                  userAgentPackageName: 'com.example.helpy',
                  maxZoom: 18,
                  minZoom: 3,
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: const ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    if (_selectedLocation != null)
                      Marker(
                        point: _selectedLocation!,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        width: 30,
                        height: 30,
                      ),
                  ],
                ),
              ],
            ),
            // Current location button
            if (widget.showCurrentLocationButton && _userLocation != null)
              Positioned(
                top: 10,
                right: 10,
                child: FloatingActionButton.small(
                  onPressed: _goToCurrentLocation,
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  child: const Icon(Icons.my_location, size: 18),
                ),
              ),
            // Loading indicator
            if (_isLoadingLocation)
              Container(
                color: Colors.black.withValues(alpha: 0.3),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            // Instructions overlay
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Tap on the map to set your location',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
