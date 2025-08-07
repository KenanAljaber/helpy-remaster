import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:helpy/routes/app_routes.dart';
import 'package:helpy/styles/theme.dart';
import 'package:helpy/utils/constants/routes_constants.dart';
import 'package:helpy/api/api_client.dart';

Future<void> main() async {
  // Load environment variables
  await dotenv.load(fileName: ".env.development");

  // Initialize API client
  ApiClient().initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Helpy - Get Help, Be Helpful',
      initialRoute: RoutesConstants.map,
      onGenerateRoute: AppRoutes.getAppRoutes,
      theme: AppTheme.defaultTheme,
    );
  }
}
