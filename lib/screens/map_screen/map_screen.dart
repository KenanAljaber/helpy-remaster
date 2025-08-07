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
import 'package:helpy/screens/user_profile/user_profile.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with WidgetsBindingObserver {
  bool _locationAvailable = false;
  bool _isLoading = true;
  bool _showPermissionScreen = false;
  int _currentIndex = 1; // Map is in the center (index 1) and active by default

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

  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildCurrentScreen() {
    switch (_currentIndex) {
      case 0: // Chat
        return _buildChatScreen();
      case 1: // Map
        return _buildMapScreen();
      case 2: // Profile
        return _buildProfileScreen();
      default:
        return _buildMapScreen();
    }
  }

  Widget _buildChatScreen() {
    return Container(
      color: Colors.grey[50],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Chat Screen',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Coming Soon!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapScreen() {
    return SizedBox(
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

          // Search bar (only visible on map screen)
          if (_locationAvailable || kIsWeb)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 10,
                  left: 16,
                  right: 16,
                  bottom: 10,
                ),
                child: Row(
                  children: [
                    // Search bar
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
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
                                    fontSize: 16,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 15,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: Colors.grey[500],
                                    size: 20,
                                  ),
                                ),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Notification icon
                    const SizedBox(width: 12),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: () {
                          // TODO: Navigate to notifications screen
                        },
                        icon: const Icon(
                          Icons.notifications_outlined,
                          color: AppColors.primaryColor,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProfileScreen() {
    return UserProfile(
      user: User(
        reputation: Reputation(positive: 15, negative: 2, total: 17),
        name: 'kenan',
        email: 'keno12333@hotmail2.com',
        helpWay: "Help translating papers from English to Spanish",
        timesHelped: 10,
        timesGotHelped: 5,
      ),
      isCurrentUser: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildCurrentScreen(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Chat Icon
                _buildBottomNavItem(
                  icon: Icons.chat_bubble_outline,
                  activeIcon: Icons.chat_bubble,
                  label: 'Chat',
                  index: 0,
                  isActive: _currentIndex == 0,
                ),
                // Map Icon (Center)
                _buildBottomNavItem(
                  icon: Icons.map_outlined,
                  activeIcon: Icons.map,
                  label: 'Map',
                  index: 1,
                  isActive: _currentIndex == 1,
                  isCenter: true,
                ),
                // Profile Icon
                _buildBottomNavItem(
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  label: 'Profile',
                  index: 2,
                  isActive: _currentIndex == 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    required bool isActive,
    bool isCenter = false,
  }) {
    return GestureDetector(
      onTap: () => _onBottomNavTap(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primaryColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? AppColors.primaryColor : Colors.grey[600],
              size: isCenter ? 26 : 22,
            ),
            const SizedBox(height: 1),
            Text(
              label,
              style: TextStyle(
                color: isActive ? AppColors.primaryColor : Colors.grey[600],
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
