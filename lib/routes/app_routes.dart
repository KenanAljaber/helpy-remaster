import 'package:flutter/material.dart';
import 'package:helpy/models/user/user.dart';
import 'package:helpy/screens/login_screen/login_screen.dart';
import 'package:helpy/screens/map_screen/map_screen.dart';
import 'package:helpy/screens/notifications/notifications_screen.dart';
import 'package:helpy/screens/signup/phone_verification_screen.dart';
import 'package:helpy/screens/signup/user_details_screen.dart';
import 'package:helpy/screens/user_profile/user_profile.dart';
import 'package:helpy/utils/constants/routes_constants.dart';

class AppRoutes {
  static Route getAppRoutes(RouteSettings settings) {
    switch (settings.name) {
      case RoutesConstants.login:
        return MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        );
      case RoutesConstants.map:
        return MaterialPageRoute(
          builder: (context) => const MapScreen(),
        );
      case RoutesConstants.profile:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => UserProfile(
            user: args['user'] as User,
            isCurrentUser: args['isCurrentUser'] as bool? ?? false,
          ),
        );
      case RoutesConstants.phoneVerification:
        return MaterialPageRoute(
          builder: (context) => const PhoneVerificationScreen(),
        );
      case RoutesConstants.signupDetails:
        final phoneNumber = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => UserDetailsScreen(phoneNumber: phoneNumber),
        );
      case RoutesConstants.notifications:
        return MaterialPageRoute(
          builder: (context) => const NotificationsScreen(),
        );
      default:
        return MaterialPageRoute(builder: (context) => const LoginScreen());
    }
  }
}

    // return {
    //   RoutesConstants.login: (context) => const LoginScreen(),
    //   RoutesConstants.map: (context) => const MapScreen(),
    //   RoutesConstants.profile: (context) => UserProfile(user: User(email: 'keno12333@hotmail.com',name: 'kenan'),),
    // };