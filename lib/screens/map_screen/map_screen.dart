import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helpy/models/user/reputation.dart';
import 'package:helpy/models/user/user.dart';
import 'package:helpy/styles/theme.dart';
import 'package:helpy/utils/constants/routes_constants.dart';
import 'package:helpy/utils/utility_methods.dart';
import 'package:helpy/widgets/map/my_map.dart';
import 'package:permission_handler/permission_handler.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool locationIsGranted = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // if the platform is android then hide the status bar
    UtilityMethods.hideStatusBar();
    // Check permissions asynchronously without blocking UI
    _checkLocationPermissions();
  }

  Future<void> _checkLocationPermissions() async {
    // Only check permissions on mobile platforms
    if (kIsWeb) return;
    
    try {
      setState(() {
        isLoading = true;
      });
      
      bool result = await UtilityMethods.isServiceEnabled(Permission.locationWhenInUse);
      if (!result) {
        bool permissionResult = await UtilityMethods.requestPermission(
            Permission.locationWhenInUse);
        if (mounted) {
          setState(() {
            locationIsGranted = permissionResult;
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          locationIsGranted = true; // Fallback to allow map usage
        });
      }
    }
  }
  // lets try to code anything, wow it is so fucking clear

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Stack(
                  children: [
                    // Always show the map immediately
                    const MyMap(),
                    //add a rounded button on the bottom center
                    Container(
                        alignment: Alignment.bottomCenter,
                        margin: const EdgeInsets.only(bottom: 20),
                        child: ElevatedButton(
                          // profile button
                          onPressed: () {
                             Navigator.pushNamed(
                                              context, RoutesConstants.profile, arguments: {
                                                'user': User(
                                                    reputation: Reputation(positive: 15, negative: 2, total: 17),
                                                    name: 'kenan',
                                                    email: 'keno12333@hotmail2.com',
                                                    helpWay: "Help translating papers from English to Spanish",
                                                    timesHelped: 10,
                                                    timesGotHelped: 5),
                                                'isCurrentUser': true, // This is the current user's profile
                                              }
                                          );
                          },
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(kIsWeb ? 15 : 5),
                              backgroundColor: AppColors.primaryColor,
                              shape: const CircleBorder()),
                          child: Image.asset(
                              "assets/images/map_button_image.png",
                              width: 50,
                              height: 50),
                        )),
                    
                    // Optional loading indicator for permissions
                    if (isLoading && !kIsWeb)
                      Container(
                        color: Colors.black26,
                        child: const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                          ),
                        ),
                      ),
                    
                    // Permission denied overlay (only if actually denied)
                    if (!locationIsGranted && !kIsWeb && !isLoading)
                      Container(
                        color: AppColors.primaryColor,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.location_off,
                                size: 64,
                                color: AppColors.almostBlack,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "Location Access Needed",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.almostBlack,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "This app works better with location access",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.almostBlack,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: _checkLocationPermissions,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.secondaryColor,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text("Grant Permission"),
                              ),
                              const SizedBox(height: 12),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    locationIsGranted = true; // Continue without location
                                  });
                                },
                                child: const Text(
                                  "Continue without location",
                                  style: TextStyle(color: AppColors.almostBlack),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    
                    //add a topBar full width with primary color as background
                    Container(
                      width: UtilityMethods.getScreenSize(context).width,
                      height: 60,
                      padding: EdgeInsets.symmetric(
                        horizontal: kIsWeb ? 30.0 : 12.0,
                        vertical: 6.0,
                      ),
                      color: AppColors.primaryColor,
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
                    )
                  ],
                ),
              ));
  }
}
