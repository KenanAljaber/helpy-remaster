import 'package:flutter/material.dart';
import 'package:helpy/routes/app_routes.dart';
import 'package:helpy/styles/theme.dart';
import 'package:helpy/utils/constants/routes_constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Helpy - Get Help, Be Helpful',
      initialRoute: RoutesConstants.login,
      onGenerateRoute: AppRoutes.getAppRoutes,
      theme: AppTheme.defaultTheme,
    );
  }
}
