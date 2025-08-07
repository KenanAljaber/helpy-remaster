# API Client Usage Guide

This document explains how to use the `ApiClient` class for making HTTP requests in the Helpy Flutter app.

## Overview

The `ApiClient` is a singleton class that provides a clean, reusable interface for making HTTP requests. It handles:
- All HTTP methods (GET, POST, PUT, PATCH, DELETE)
- File uploads
- Error handling
- Response parsing
- Authentication headers
- Query parameters

## Basic Usage

### 1. Getting the API Client Instance

```dart
import 'package:helpy/api/api_client.dart';

final apiClient = ApiClient();
```

### 2. Making HTTP Requests

#### GET Request
```dart
final response = await apiClient.get('users');
if (response.isSuccess) {
  final users = response.data;
  print('Users: $users');
} else {
  print('Error: ${response.error}');
}
```

#### POST Request
```dart
final userData = {
  'name': 'John Doe',
  'email': 'john@example.com',
  'phone': '+1234567890',
};

final response = await apiClient.post(
  'users',
  body: userData,
);

if (response.isCreated) {
  print('User created successfully!');
  print('User ID: ${response.data['id']}');
} else {
  print('Failed to create user: ${response.error}');
}
```

#### PUT Request
```dart
final updateData = {
  'name': 'John Smith',
  'email': 'johnsmith@example.com',
};

final response = await apiClient.put(
  'users/123',
  body: updateData,
);

if (response.isOk) {
  print('User updated successfully!');
} else {
  print('Failed to update user: ${response.error}');
}
```

#### DELETE Request
```dart
final response = await apiClient.delete('users/123');

if (response.isNoContent) {
  print('User deleted successfully!');
} else {
  print('Failed to delete user: ${response.error}');
}
```

### 3. Using Query Parameters

```dart
final response = await apiClient.get(
  'users',
  queryParameters: {
    'page': 1,
    'limit': 10,
    'search': 'john',
    'status': 'active',
  },
);
```

### 4. Custom Headers

```dart
final response = await apiClient.post(
  'users',
  headers: {
    'X-Custom-Header': 'custom-value',
    'X-API-Version': 'v2',
  },
  body: userData,
);
```

## Authentication

### Setting Auth Token
```dart
// Set the authorization token
apiClient.setAuthToken('your-jwt-token-here');

// All subsequent requests will include the Authorization header
final response = await apiClient.get('profile');
```

### Removing Auth Token
```dart
// Remove the authorization token
apiClient.removeAuthToken();
```

## File Upload

```dart
import 'dart:io';

final file = File('/path/to/image.jpg');
final response = await apiClient.uploadFile(
  'upload/profile-picture',
  fields: {
    'userId': '123',
    'description': 'Profile picture',
  },
  files: {
    'image': file,
  },
);

if (response.isSuccess) {
  print('File uploaded successfully!');
  print('File URL: ${response.data['url']}');
}
```

## Response Handling

### Response Properties
```dart
final response = await apiClient.get('users/123');

// Check if request was successful
if (response.isSuccess) {
  // Access response data
  final user = response.data;
  
  // Get status code
  print('Status Code: ${response.statusCode}');
  
  // Get response headers
  print('Content-Type: ${response.headers['content-type']}');
  
  // Check specific status codes
  if (response.isOk) {
    print('200 OK');
  } else if (response.isCreated) {
    print('201 Created');
  }
} else {
  // Handle error
  print('Error: ${response.error}');
  print('Status Code: ${response.statusCode}');
}
```

### Response Helper Methods
```dart
final response = await apiClient.get('users/123');

// Get data as specific type
final userMap = response.getData<Map<String, dynamic>>();
final userList = response.getData<List<dynamic>>();

// Get nested data
final userName = response.getNestedData(['user', 'profile', 'name']);
final userEmail = response.getNestedData(['user', 'email']);
```

## Error Handling

### Common Error Scenarios
```dart
final response = await apiClient.get('users/999');

if (response.isNotFound) {
  print('User not found');
} else if (response.isUnauthorized) {
  print('Please log in again');
} else if (response.isForbidden) {
  print('You don\'t have permission to access this resource');
} else if (response.isServerError) {
  print('Server error occurred');
} else if (response.error != null) {
  print('Network error: ${response.error}');
}
```

### Exception Handling
```dart
try {
  final response = await apiClient.get('users');
  if (!response.isSuccess) {
    throw ApiException(response.error ?? 'Unknown error', 
                      statusCode: response.statusCode);
  }
  // Handle success
} on ApiException catch (e) {
  print('API Error: ${e.message}');
  print('Status Code: ${e.statusCode}');
} catch (e) {
  print('Unexpected error: $e');
}
```

## Using with Config Class

### Automatic Base URL
```dart
// The API client automatically uses the base URL from Config
final response = await apiClient.get('users'); // Uses Config.apiBaseUrl

// You can also use full URLs
final response = await apiClient.get('https://api.example.com/users');
```

### Environment-Specific Endpoints
```dart
import 'package:helpy/utils/config.dart';

// Use Config endpoints
final response = await apiClient.get(Config.usersEndpoint);

// Or build custom endpoints
final customEndpoint = Config.getApiUrl('custom-endpoint');
final response = await apiClient.get(customEndpoint);
```

## Best Practices

### 1. Always Check Response Status
```dart
final response = await apiClient.post('users', body: userData);
if (!response.isSuccess) {
  // Handle error appropriately
  return;
}
// Process successful response
```

### 2. Use Type-Safe Data Access
```dart
final response = await apiClient.get('users');
if (response.isSuccess) {
  final users = response.getData<List<dynamic>>();
  if (users != null) {
    // Process users list
  }
}
```

### 3. Handle Authentication Properly
```dart
// Set token when user logs in
apiClient.setAuthToken(userToken);

// Remove token when user logs out
apiClient.removeAuthToken();
```

### 4. Use Query Parameters for Filtering
```dart
final response = await apiClient.get(
  'help-requests',
  queryParameters: {
    'status': 'open',
    'category': 'tutoring',
    'location': 'nearby',
  },
);
```

## Example Helper Service

Here's an example of how to create a helper service using the API client:

```dart
import 'package:helpy/api/api_client.dart';

class UserService {
  final ApiClient _apiClient = ApiClient();

  Future<List<dynamic>> getUsers({int? page, int? limit}) async {
    final response = await _apiClient.get(
      'users',
      queryParameters: {
        if (page != null) 'page': page,
        if (limit != null) 'limit': limit,
      },
    );

    if (response.isSuccess) {
      return response.getData<List<dynamic>>() ?? [];
    } else {
      throw ApiException(response.error ?? 'Failed to fetch users');
    }
  }

  Future<Map<String, dynamic>?> createUser(Map<String, dynamic> userData) async {
    final response = await _apiClient.post(
      'users',
      body: userData,
    );

    if (response.isCreated) {
      return response.getData<Map<String, dynamic>>();
    } else {
      throw ApiException(response.error ?? 'Failed to create user');
    }
  }

  Future<bool> updateUser(String userId, Map<String, dynamic> userData) async {
    final response = await _apiClient.put(
      'users/$userId',
      body: userData,
    );

    return response.isOk;
  }

  Future<bool> deleteUser(String userId) async {
    final response = await _apiClient.delete('users/$userId');
    return response.isNoContent;
  }
}
```

## Debugging

The API client includes built-in logging for debugging:

```dart
// In debug mode, requests and responses are automatically logged
// Look for logs like:
// 🌐 API Request: GET http://localhost:3000/users
// 📡 API Response: GET http://localhost:3000/users
// 📊 Status Code: 200
// 📦 Response Data: {...}
```

This comprehensive API client provides a robust foundation for all your HTTP communication needs in the Helpy app!
