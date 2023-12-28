import 'package:flutter/material.dart';
import 'package:helpy/screens/login_screen.dart';
import 'package:helpy/screens/map_screen.dart';
import 'package:helpy/utils/constants/routes_constants.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> getAppRoutes() {
    return {
      RoutesConstants.login: (context) => const LoginScreen(),
      RoutesConstants.map: (context) => const MapScreen(),
    };
  }
}
