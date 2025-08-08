import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:helpy/routes/app_routes.dart';
import 'package:helpy/styles/theme.dart';
import 'package:helpy/utils/constants/routes_constants.dart';
import 'package:helpy/api/api_client.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import 'package:helpy/state/auth_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Load environment variables
  if (kIsWeb) {
    await dotenv.load(fileName: 'assets/env/.env.web');
  } else {
    // await dotenv.load(fileName: '.env.development');
  }

  // Initialize API client
  ApiClient().initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthState()..loadFromStorage(),
      child: Consumer<AuthState>(
        builder: (context, auth, _) {
          final initialRoute =
              auth.isLoggedIn ? RoutesConstants.map : RoutesConstants.login;
          return MaterialApp(
            title: 'Helpy - Get Help, Be Helpful',
            initialRoute: initialRoute,
            onGenerateRoute: AppRoutes.getAppRoutes,
            theme: AppTheme.defaultTheme,
          );
        },
      ),
    );
  }
}
