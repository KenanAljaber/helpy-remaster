# Environment Configuration Setup

This document explains how to set up and use environment variables in the Helpy Flutter app.

## Environment Files

The app uses two environment files:

### Development Environment (`.env.development`)
- **API_BASE_URL**: `http://localhost:3000`
- **ENVIRONMENT**: `development`

### Production Environment (`.env.production`)
- **API_BASE_URL**: `https://your-production-api.com`
- **ENVIRONMENT**: `production`

## How to Use

### 1. Loading Environment Variables

The environment variables are loaded in `main.dart`:

```dart
Future<void> main() async {
  // Load environment variables
  await dotenv.load(fileName: ".env.development");
  
  runApp(const MyApp());
}
```

### 2. Accessing Configuration

Use the `Config` class to access environment variables:

```dart
import 'package:helpy/utils/config.dart';

// Get API base URL
String apiUrl = Config.apiBaseUrl;

// Check environment
bool isDev = Config.isDevelopment;
bool isProd = Config.isProduction;

// Get specific endpoints
String authUrl = Config.authEndpoint;
String usersUrl = Config.usersEndpoint;

// Helper method for custom endpoints
String customUrl = Config.getApiUrl('custom-endpoint');
```

### 3. Switching Environments

To switch between development and production:

1. **For Development**: The app currently loads `.env.development` by default
2. **For Production**: Change the file name in `main.dart`:
   ```dart
   await dotenv.load(fileName: ".env.production");
   ```

### 4. Available Configuration Properties

- `Config.apiBaseUrl` - Base URL for API calls
- `Config.environment` - Current environment name
- `Config.isDevelopment` - Boolean for development environment
- `Config.isProduction` - Boolean for production environment
- `Config.authEndpoint` - Authentication endpoint
- `Config.usersEndpoint` - Users endpoint
- `Config.helpRequestsEndpoint` - Help requests endpoint
- `Config.locationEndpoint` - Location endpoint
- `Config.getApiUrl(endpoint)` - Helper method for custom endpoints

## Example Usage in API Calls

```dart
import 'package:helpy/utils/config.dart';

// Make API call
final response = await http.post(
  Uri.parse(Config.authEndpoint),
  body: jsonEncode({
    'email': email,
    'password': password,
  }),
  headers: {'Content-Type': 'application/json'},
);
```

## Security Notes

- Never commit sensitive information like API keys to version control
- Use different API URLs for development and production
- Consider using build flavors for more complex environment management
- The environment files are included in `.gitignore` to prevent accidental commits

## Build Flavors (Advanced)

For more complex environment management, you can use Flutter build flavors:

1. Create different environment files for each flavor
2. Use build arguments to specify which environment to load
3. Configure different app icons, names, and configurations per environment

Example:
```bash
# Development build
flutter build apk --flavor development

# Production build
flutter build apk --flavor production
```
