import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helpy/models/user/reputation.dart';
import 'package:helpy/models/user/user.dart';
import 'package:helpy/styles/theme.dart';
import 'package:helpy/utils/constants/routes_constants.dart';
import 'package:helpy/utils/utility_methods.dart';
import 'package:helpy/widgets/map/my_map.dart';
import 'package:helpy/screens/location_permission_denied_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with WidgetsBindingObserver {
  bool _locationAvailable = false;
  bool _isLoading = true;
  bool _showPermissionScreen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // if the platform is android then hide the status bar
    UtilityMethods.hideStatusBar();
    // Check location availability
    _checkLocationAvailability();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // Check location when app resumes (user might have changed settings)
    if (state == AppLifecycleState.resumed) {
      _checkLocationAvailability();
    }
  }

  Future<void> _checkLocationAvailability() async {
    // Skip on web
    if (kIsWeb) {
      setState(() {
        _locationAvailable = true;
        _isLoading = false;
        _showPermissionScreen = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      bool isAvailable = await UtilityMethods.isLocationAvailable();

      if (mounted) {
        setState(() {
          _locationAvailable = isAvailable;
          _isLoading = false;
          _showPermissionScreen = !isAvailable;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _locationAvailable = false;
          _isLoading = false;
          _showPermissionScreen = true;
        });
      }
    }
  }

  void _onPermissionGranted() {
    setState(() {
      _showPermissionScreen = false;
      _isLoading = true;
    });
    _checkLocationAvailability();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            // Show map if location is available or on web
            if (_locationAvailable || kIsWeb) const MyMap(),

            // Show permission screen if needed
            if (_showPermissionScreen && !kIsWeb)
              LocationPermissionDeniedScreen(
                onPermissionGranted: _onPermissionGranted,
              ),

            // Loading indicator
            if (_isLoading && !kIsWeb)
              Container(
                color: Colors.black26,
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                  ),
                ),
              ),

            // Profile button (only show when map is visible)
            if (_locationAvailable || kIsWeb)
              Container(
                  alignment: Alignment.bottomCenter,
                  margin: const EdgeInsets.only(bottom: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RoutesConstants.profile,
                          arguments: {
                            'user': User(
                                reputation: Reputation(
                                    positive: 15, negative: 2, total: 17),
                                name: 'kenan',
                                email: 'keno12333@hotmail2.com',
                                helpWay:
                                    "Help translating papers from English to Spanish",
                                timesHelped: 10,
                                timesGotHelped: 5),
                            'isCurrentUser': true,
                          });
                    },
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(kIsWeb ? 15 : 5),
                        backgroundColor: AppColors.primaryColor,
                        shape: const CircleBorder()),
                    child: Image.asset("assets/images/map_button_image.png",
                        width: 50, height: 50),
                  )),

            // Top bar (only show when map is visible)
            if (_locationAvailable || kIsWeb)
              Container(
                width: UtilityMethods.getScreenSize(context).width,
                height: 60,
                padding: EdgeInsets.symmetric(
                  horizontal: kIsWeb ? 30.0 : 12.0,
                  vertical: 6.0,
                ),
                color: AppColors.primaryColor.withOpacity(0.2),
                child: Row(
                  children: [
                    // Icons on the left
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            // TODO: Implement notifications functionality
                          },
                          icon: const Icon(Icons.notifications_outlined),
                          iconSize: kIsWeb ? 28 : 24,
                          color: AppColors.almostBlack,
                          padding: const EdgeInsets.all(6),
                        ),
                        IconButton(
                          onPressed: () {
                            // TODO: Implement people/contacts functionality
                          },
                          icon: const Icon(Icons.people_outline),
                          iconSize: kIsWeb ? 28 : 24,
                          color: AppColors.almostBlack,
                          padding: const EdgeInsets.all(6),
                        ),
                      ],
                    ),

                    // Search bar on the right
                    Expanded(
                      child: Container(
                        height: 40,
                        margin: const EdgeInsets.only(left: 12),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            // Search input field
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "Search for help...",
                                  hintStyle: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 14,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                ),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            // Search button
                            Container(
                              width: 36,
                              height: 36,
                              margin: const EdgeInsets.only(right: 2),
                              decoration: BoxDecoration(
                                color: AppColors.almostBlack,
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  // TODO: Implement search functionality
                                },
                                padding: EdgeInsets.zero,
                                icon: const Icon(
                                  Icons.search,
                                  color: AppColors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
