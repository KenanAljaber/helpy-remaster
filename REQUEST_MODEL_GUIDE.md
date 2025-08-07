# Request Model Guide

This document explains the `Request` model and `RequestStatus` enum used in the Helpy app for managing help requests between users.

## Overview

The `Request` model represents a help request from one user to another. It includes comprehensive information about the request, both users involved, location details, timestamps, and status management.

## RequestStatus Enum

### Available Statuses

- **`pending`** - Request is sent and waiting for response
- **`accepted`** - Helper has accepted the request
- **`rejected`** - Helper has rejected the request
- **`completed`** - Request has been completed
- **`cancelled`** - Request was cancelled by the requester

### Status Properties

```dart
// Get string value for API
String statusValue = RequestStatus.pending.value; // "pending"

// Convert from string
RequestStatus status = RequestStatus.fromString("accepted");

// Get display text for UI
String displayText = RequestStatus.pending.displayText; // "Pending"

// Check if request is active (can be modified)
bool isActive = RequestStatus.pending.isActive; // true

// Check if request is final (cannot be modified)
bool isFinal = RequestStatus.rejected.isFinal; // true
```

## Request Model Fields

### Core Information
- `id` - Unique identifier for the request
- `message` - Detailed message from the requester
- `status` - Current status of the request

### User Information
- `requesterId` - ID of the user requesting help
- `requesterName` - Name of the user requesting help
- `requesterPhotoLink` - Profile photo of the requester
- `helperId` - ID of the user being asked for help
- `helperName` - Name of the user being asked for help
- `helperPhotoLink` - Profile photo of the helper

### Location Information
- `latitude` - Latitude coordinate of the request location
- `longitude` - Longitude coordinate of the request location
- `locationAddress` - Human-readable address

### Timestamps
- `createdAt` - When the request was created
- `updatedAt` - When the request was last updated
- `acceptedAt` - When the request was accepted
- `completedAt` - When the request was completed
- `rejectedAt` - When the request was rejected

### Additional Information
- `rejectionReason` - Reason for rejection (if applicable)
- `estimatedDuration` - Estimated time needed (in minutes)
- `estimatedCost` - Estimated cost (if applicable)
- `tags` - List of tags for categorization
- `additionalData` - Any additional custom data

## Usage Examples

### Creating a New Request

```dart
final request = Request(
  message: "I'm struggling with calculus and need someone to explain derivatives",
  requesterId: "user123",
  requesterName: "John Doe",
  requesterPhotoLink: "https://example.com/photo.jpg",
  helperId: "user456",
  helperName: "Jane Smith",
  helperPhotoLink: "https://example.com/jane.jpg",
  latitude: 40.7128,
  longitude: -74.0060,
  locationAddress: "123 Main St, New York, NY",
  estimatedDuration: 120, // 2 hours
  tags: ["math", "calculus", "homework"],
);
```

### Creating from JSON (API Response)

```dart
final jsonData = {
  'id': 'req123',
  'message': 'I\'m struggling with calculus...',
  'status': 'pending',
  'requesterId': 'user123',
  'requesterName': 'John Doe',
  'helperId': 'user456',
  'helperName': 'Jane Smith',
  'createdAt': '2024-01-15T10:30:00Z',
  // ... other fields
};

final request = Request.fromJson(jsonData);
```

### Converting to JSON (for API)

```dart
final json = request.toJson();
// Use this JSON for API requests
```

### Updating Request Status

```dart
// Accept a request
final acceptedRequest = request.updateStatus(RequestStatus.accepted);

// Reject a request with reason
final rejectedRequest = request.updateStatus(
  RequestStatus.rejected,
  rejectionReason: "I'm not available at that time"
);

// Complete a request
final completedRequest = request.updateStatus(RequestStatus.completed);
```

### Helper Methods

```dart
// Check if request is from current user
bool isFromMe = request.isFromUser(currentUserId);

// Check if request is to current user
bool isToMe = request.isToUser(currentUserId);

// Get the other user's information
String otherUserId = request.getOtherUserId(currentUserId);
String otherUserName = request.getOtherUserName(currentUserId);
String? otherUserPhoto = request.getOtherUserPhotoLink(currentUserId);

// Get formatted information
String duration = request.formattedDuration; // "2h 30m"
String cost = request.formattedCost; // "$25.00"
String timeAgo = request.timeAgo; // "2 hours ago"
```

### Creating a Copy with Changes

```dart
final updatedRequest = request.copyWith(
  message: "Updated message",
  estimatedDuration: 180,
);
```

## Status Flow

```
pending → accepted → completed
    ↓
  rejected
    ↓
  cancelled
```

### Status Transitions

1. **pending** → **accepted**: Helper accepts the request
2. **pending** → **rejected**: Helper rejects the request
3. **pending** → **cancelled**: Requester cancels the request
4. **accepted** → **completed**: Request is completed
5. **accepted** → **cancelled**: Request is cancelled after acceptance

## Best Practices

### 1. Always Check Status Before Actions

```dart
if (request.status.isActive) {
  // Can perform actions like accept, reject, complete
} else {
  // Request is final, cannot be modified
}
```

### 2. Use Helper Methods for User Context

```dart
// Instead of checking requesterId/helperId manually
String otherUser = request.getOtherUserName(currentUserId);
```

### 3. Handle Timestamps Properly

```dart
// Always use updateStatus() for status changes
// It automatically handles timestamp updates
final updatedRequest = request.updateStatus(RequestStatus.accepted);
```

### 4. Validate Data Before Creating

```dart
if (message.isNotEmpty && 
    requesterId.isNotEmpty && helperId.isNotEmpty) {
  final request = Request(
    message: message,
    requesterId: requesterId,
    requesterName: requesterName,
    helperId: helperId,
    helperName: helperName,
  );
}
```

## Integration with API Client

```dart
import 'package:helpy/api/api_client.dart';
import 'package:helpy/models/request.dart';

class RequestService {
  final ApiClient _apiClient = ApiClient();

  // Create a new request
  Future<Request?> createRequest(Request request) async {
    final response = await _apiClient.post(
      'requests',
      body: request.toJson(),
    );

    if (response.isCreated) {
      return Request.fromJson(response.data);
    }
    return null;
  }

  // Get user's requests
  Future<List<Request>> getUserRequests(String userId) async {
    final response = await _apiClient.get(
      'requests',
      queryParameters: {'userId': userId},
    );

    if (response.isSuccess) {
      final List<dynamic> requestsJson = response.data;
      return requestsJson.map((json) => Request.fromJson(json)).toList();
    }
    return [];
  }

  // Update request status
  Future<bool> updateRequestStatus(String requestId, RequestStatus status, {String? rejectionReason}) async {
    final response = await _apiClient.patch(
      'requests/$requestId/status',
      body: {
        'status': status.value,
        if (rejectionReason != null) 'rejectionReason': rejectionReason,
      },
    );

    return response.isOk;
  }
}
```

This comprehensive request model provides all the functionality needed for a robust help request system in your Helpy app!
