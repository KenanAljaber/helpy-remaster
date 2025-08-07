import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static String get apiBaseUrl {
    return dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000';
  }

  static String get environment {
    return dotenv.env['ENVIRONMENT'] ?? 'development';
  }

  static bool get isDevelopment {
    return environment == 'development';
  }

  static bool get isProduction {
    return environment == 'production';
  }

  // API Endpoints
  static String get authEndpoint => '$apiBaseUrl/auth';
  static String get usersEndpoint => '$apiBaseUrl/users';
  static String get helpRequestsEndpoint => '$apiBaseUrl/help-requests';
  static String get locationEndpoint => '$apiBaseUrl/location';

  // Helper method to get full API URL
  static String getApiUrl(String endpoint) {
    return '$apiBaseUrl/$endpoint';
  }
}
