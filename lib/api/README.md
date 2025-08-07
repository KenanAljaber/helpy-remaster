# API Directory

This directory contains all API-related functionality for the Helpy Flutter app.

## Structure

```
lib/api/
├── api_client.dart    # Main API client for HTTP requests
├── index.dart         # Exports for cleaner imports
└── README.md          # This file
```

## Files

### `api_client.dart`
The main API client that provides:
- HTTP request methods (GET, POST, PUT, PATCH, DELETE)
- File upload functionality
- Error handling and response parsing
- Authentication token management
- Query parameter support

### `index.dart`
Export file that makes imports cleaner:
```dart
// Instead of:
import 'package:helpy/api/api_client.dart';

// You can use:
import 'package:helpy/api/index.dart';
```

## Usage

### Basic Import
```dart
import 'package:helpy/api/api_client.dart';

final apiClient = ApiClient();
```

### Using Index Export
```dart
import 'package:helpy/api/index.dart';

final apiClient = ApiClient();
```

## Future Additions

This directory is designed to accommodate future API-related files such as:
- `services/` - API service classes (UserService, AuthService, etc.)
- `models/` - API request/response models
- `interceptors/` - Request/response interceptors
- `endpoints.dart` - API endpoint constants

## Organization Benefits

- **Separation of Concerns**: API logic is separated from utility functions
- **Scalability**: Easy to add new API-related files and services
- **Maintainability**: Clear structure makes it easy to find and modify API code
- **Clean Imports**: Index file provides cleaner import statements
