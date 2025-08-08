import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class UtilityMethods {
  static Size getScreenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  static bool isMobile(BuildContext context) {
    try {
      if (UtilityMethods.getScreenSize(context).width < 600) {
        return true;
      }
      return false;
    } catch (e) {
      print("an error occured");
      return false;
    }
  }

  static void hideStatusBar() {
    try {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } catch (e) {
      return;
    }
  }

  static Future<bool> isServiceEnabled(Permission service) async {
    try {
      final status = await service.status;
      if (status.isDenied || status.isRestricted) {
        print("Permission Denied");
        return false;
      }
      print("Permission Granted");
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> requestPermission(Permission service) async {
    try {
      if (await service.request().isGranted) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  /// Check if location services are enabled and permission is granted
  static Future<bool> isLocationAvailable() async {
    try {
      if (kIsWeb) {
        // On web, rely solely on browser permission state
        final permission = await Geolocator.checkPermission();
        return permission == LocationPermission.whileInUse ||
            permission == LocationPermission.always;
      }

      // Check if location services are enabled (mobile/desktop)
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return false;
      }

      // Check location permission
      final permission = await Geolocator.checkPermission();
      return permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always;
    } catch (e) {
      print('Error checking location availability: $e');
      return false;
    }
  }

  /// Check if location permission is granted but GPS is disabled
  static Future<bool> isLocationPermissionGrantedButGpsDisabled() async {
    try {
      if (kIsWeb) {
        // GPS toggle concept doesn't apply on web
        return false;
      }
      // Check location permission first
      LocationPermission permission = await Geolocator.checkPermission();
      bool hasPermission = permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always;

      if (!hasPermission) {
        return false; // No permission granted
      }

      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      return !serviceEnabled; // Return true if permission granted but GPS disabled
    } catch (e) {
      print('Error checking location permission and GPS status: $e');
      return false;
    }
  }

  /// Request location permission and return the result
  static Future<bool> requestLocationPermission() async {
    try {
      if (kIsWeb) {
        // On web, trigger the browser permission prompt
        var permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }

        // Some browsers only show the prompt when requesting position
        if (permission == LocationPermission.denied) {
          try {
            await Geolocator.getCurrentPosition(
              locationSettings: const LocationSettings(
                accuracy: LocationAccuracy.low,
              ),
            ).timeout(const Duration(seconds: 10));
            permission = await Geolocator.checkPermission();
          } catch (_) {}
        }

        return permission == LocationPermission.whileInUse ||
            permission == LocationPermission.always;
      }

      // Mobile/desktop flow
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return false;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      return permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always;
    } catch (e) {
      print('Error requesting location permission: $e');
      return false;
    }
  }

  /// Get current location with timeout
  static Future<Position?> getCurrentLocation() async {
    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception('Location request timed out');
        },
      );
    } catch (e) {
      print('Error getting current location: $e');
      return null;
    }
  }

  /// Open location settings (GPS settings) on Android
  static Future<void> openLocationSettings() async {
    try {
      await Geolocator.openLocationSettings();
    } catch (e) {
      print('Error opening location settings: $e');
      // Fallback to app settings if location settings can't be opened
      await openAppSettings();
    }
  }
}
