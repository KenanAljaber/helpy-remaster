import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:helpy/styles/theme.dart';
import 'package:helpy/utils/utility_methods.dart';

class LocationPermissionDeniedScreen extends StatefulWidget {
  final VoidCallback? onPermissionGranted;

  const LocationPermissionDeniedScreen({
    super.key,
    this.onPermissionGranted,
  });

  @override
  State<LocationPermissionDeniedScreen> createState() =>
      _LocationPermissionDeniedScreenState();
}

class _LocationPermissionDeniedScreenState
    extends State<LocationPermissionDeniedScreen> {
  bool _isRequesting = false;
  bool _isGpsDisabled = false;

  @override
  void initState() {
    super.initState();
    _checkGpsStatus();
  }

  Future<void> _checkGpsStatus() async {
    bool gpsDisabled =
        await UtilityMethods.isLocationPermissionGrantedButGpsDisabled();
    if (mounted) {
      setState(() {
        _isGpsDisabled = gpsDisabled;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom -
                  48, // 24*2 for padding
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Location icon
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isGpsDisabled ? Icons.location_off : Icons.location_off,
                      size: 60,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Title
                  Text(
                    _isGpsDisabled
                        ? 'Location Services Disabled'
                        : 'Location Access Required',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.almostBlack,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Description
                  Text(
                    _isGpsDisabled
                        ? 'Your location permission is granted, but GPS services are disabled. Please enable location services to use Helpy.'
                        : 'Helpy needs access to your location to show you nearby people who can help you, and to help others find you when you\'re offering assistance.',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Benefits list
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildBenefitItem(
                          icon: Icons.people,
                          title: 'Find Nearby Helpers',
                          description:
                              'Discover people around you who can assist with various tasks',
                        ),
                        const SizedBox(height: 16),
                        _buildBenefitItem(
                          icon: Icons.location_on,
                          title: 'Get Local Assistance',
                          description:
                              'Connect with helpers in your immediate area',
                        ),
                        const SizedBox(height: 16),
                        _buildBenefitItem(
                          icon: Icons.security,
                          title: 'Safe & Secure',
                          description:
                              'Your location is only used to find nearby assistance',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Enable location button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isRequesting
                          ? null
                          : () => _requestLocationPermission(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isRequesting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              _isGpsDisabled
                                  ? 'Enable GPS Services'
                                  : 'Enable Location Access',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Open settings button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed:
                          _isRequesting ? null : () => _openAppSettings(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryColor,
                        side: const BorderSide(color: AppColors.primaryColor),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Open Settings',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Note
                  Text(
                    'You can change this later in your device settings',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: AppColors.primaryColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.almostBlack,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _requestLocationPermission(BuildContext context) async {
    setState(() {
      _isRequesting = true;
    });

    try {
      // First check if permission is granted but GPS is disabled
      bool gpsDisabledButPermissionGranted =
          await UtilityMethods.isLocationPermissionGrantedButGpsDisabled();

      if (gpsDisabledButPermissionGranted) {
        // Permission is granted but GPS is disabled, open location settings
        if (mounted) {
          setState(() {
            _isRequesting = false;
          });
        }
        await _openLocationSettings();
        return;
      }

      // Otherwise, request permission normally
      bool granted = await UtilityMethods.requestLocationPermission();

      if (mounted) {
        setState(() {
          _isRequesting = false;
        });

        if (granted) {
          // Permission granted, trigger map rebuild
          widget.onPermissionGranted?.call();
        } else {
          // Permission denied, show settings dialog
          _showSettingsDialog(context);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isRequesting = false;
        });
        _showSettingsDialog(context);
      }
    }
  }

  Future<void> _openLocationSettings() async {
    setState(() {
      _isRequesting = true;
    });

    try {
      await UtilityMethods.openLocationSettings();

      // Wait a bit for the user to potentially change settings
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        setState(() {
          _isRequesting = false;
        });

        // Check if location is now available
        bool isAvailable = await UtilityMethods.isLocationAvailable();
        if (isAvailable) {
          widget.onPermissionGranted?.call();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isRequesting = false;
        });
      }
    }
  }

  Future<void> _openAppSettings() async {
    setState(() {
      _isRequesting = true;
    });

    try {
      await openAppSettings();

      // Wait a bit for the user to potentially change settings
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        setState(() {
          _isRequesting = false;
        });

        // Check if permission was granted
        bool isAvailable = await UtilityMethods.isLocationAvailable();
        if (isAvailable) {
          widget.onPermissionGranted?.call();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isRequesting = false;
        });
      }
    }
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Location Permission Required',
            style: TextStyle(
              color: AppColors.almostBlack,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: const Text(
            'To use Helpy, you need to enable location access in your device settings.',
            style: TextStyle(
              color: AppColors.almostBlack,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _openAppSettings();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Open Settings',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
