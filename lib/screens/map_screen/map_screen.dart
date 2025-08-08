import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helpy/api/services/notification_service.dart';
import 'package:helpy/models/user/reputation.dart';
import 'package:helpy/models/user/user.dart';
import 'package:helpy/screens/chat/chat_screen.dart';
import 'package:helpy/screens/location_permission_denied_screen.dart';
import 'package:helpy/screens/user_profile/user_profile.dart';
import 'package:helpy/styles/theme.dart';
import 'package:helpy/utils/constants/routes_constants.dart';
import 'package:helpy/utils/utility_methods.dart';
import 'package:helpy/widgets/map/my_map.dart';
import 'package:helpy/widgets/notification_badge.dart';
import 'dart:io' show Platform;

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
  int _unreadNotificationsCount = 0;
  final NotificationService _notificationService = NotificationService();
  DateTime? _lastBackPressedAt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // if the platform is android then hide the status bar
    UtilityMethods.hideStatusBar();
    // Check location availability
    _checkLocationAvailability();
    // Load notification count
    _loadNotificationCount();
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

  Future<void> _loadNotificationCount() async {
    try {
      // TODO: Replace with actual user ID from authentication
      const String currentUserId = 'current_user';
      final count =
          await _notificationService.getUnreadNotificationsCount(currentUserId);
      if (mounted) {
        setState(() {
          _unreadNotificationsCount = count;
        });
      }
    } catch (e) {
      // Handle error silently for now
      if (kDebugMode) {
        print('Error loading notification count: $e');
      }
    }
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        return _buildChatScreen();
      case 1:
        return _buildMapScreen();
      case 2:
        return _buildProfileScreen();
      default:
        return _buildMapScreen();
    }
  }

  Future<bool> _onWillPop() async {
    // Skip double-back behavior on web
    if (kIsWeb) {
      return true;
    }

    final now = DateTime.now();
    if (_lastBackPressedAt == null ||
        now.difference(_lastBackPressedAt!) > const Duration(seconds: 2)) {
      _lastBackPressedAt = now;
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Press back again to exit to background'),
            duration: Duration(seconds: 2),
          ),
        );
      }
      return false;
    }
    // Second back press - exit to background on Android
    if (Platform.isAndroid) {
      SystemNavigator.pop();
      return false;
    }
    return true;
  }

  Widget _buildChatScreen() {
    return const ChatScreen();
  }

  Widget _buildMapScreen() {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          // Show map only if location permission is available
          if (_locationAvailable) const MyMap(),

          // Show permission screen if needed
          if (_showPermissionScreen)
            LocationPermissionDeniedScreen(
              onPermissionGranted: _onPermissionGranted,
            ),

          // Loading indicator
          if (_isLoading)
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
          if (_locationAvailable)
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
                    NotificationBadge(
                      count: _unreadNotificationsCount,
                      child: Container(
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
                          onPressed: () async {
                            await Navigator.pushNamed(
                                context, RoutesConstants.notifications);
                            // Refresh notification count when returning
                            _loadNotificationCount();
                          },
                          icon: const Icon(
                            Icons.notifications_outlined,
                            color: AppColors.primaryColor,
                            size: 24,
                          ),
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
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: _buildCurrentScreen(),
        bottomNavigationBar: _showPermissionScreen
            ? null
            : Container(
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
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
