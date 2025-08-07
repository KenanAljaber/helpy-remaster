import 'package:helpy/models/user/user.dart';

/// Enum for request status
enum RequestStatus {
  pending,
  accepted,
  rejected,
  completed,
  cancelled;

  /// Convert status to string for API communication
  String get value {
    switch (this) {
      case RequestStatus.pending:
        return 'pending';
      case RequestStatus.accepted:
        return 'accepted';
      case RequestStatus.rejected:
        return 'rejected';
      case RequestStatus.completed:
        return 'completed';
      case RequestStatus.cancelled:
        return 'cancelled';
    }
  }

  /// Convert string to status
  static RequestStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return RequestStatus.pending;
      case 'accepted':
        return RequestStatus.accepted;
      case 'rejected':
        return RequestStatus.rejected;
      case 'completed':
        return RequestStatus.completed;
      case 'cancelled':
        return RequestStatus.cancelled;
      default:
        return RequestStatus.pending;
    }
  }

  /// Get display text for UI
  String get displayText {
    switch (this) {
      case RequestStatus.pending:
        return 'Pending';
      case RequestStatus.accepted:
        return 'Accepted';
      case RequestStatus.rejected:
        return 'Rejected';
      case RequestStatus.completed:
        return 'Completed';
      case RequestStatus.cancelled:
        return 'Cancelled';
    }
  }

  /// Check if request is active (can be modified)
  bool get isActive {
    return this == RequestStatus.pending || this == RequestStatus.accepted;
  }

  /// Check if request is final (cannot be modified)
  bool get isFinal {
    return this == RequestStatus.rejected ||
        this == RequestStatus.completed ||
        this == RequestStatus.cancelled;
  }
}

/// Model for help requests between users
class Request {
  final String id;
  final String message;
  final RequestStatus status;

  // User who is requesting help
  final String requesterId;
  final String requesterName;
  final String? requesterPhotoLink;

  // User who is being asked for help
  final String helperId;
  final String helperName;
  final String? helperPhotoLink;

  // Location information
  final double? latitude;
  final double? longitude;
  final String? locationAddress;

  // Timestamps
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? acceptedAt;
  final DateTime? completedAt;
  final DateTime? rejectedAt;

  // Additional fields
  final String? rejectionReason;
  final int? estimatedDuration; // in minutes
  final double? estimatedCost; // if applicable
  final List<String>? tags;
  final Map<String, dynamic>? additionalData;

  Request({
    this.id = '',
    required this.message,
    this.status = RequestStatus.pending,
    required this.requesterId,
    required this.requesterName,
    this.requesterPhotoLink,
    required this.helperId,
    required this.helperName,
    this.helperPhotoLink,
    this.latitude,
    this.longitude,
    this.locationAddress,
    DateTime? createdAt,
    this.updatedAt,
    this.acceptedAt,
    this.completedAt,
    this.rejectedAt,
    this.rejectionReason,
    this.estimatedDuration,
    this.estimatedCost,
    this.tags,
    this.additionalData,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Create an empty request
  Request.empty()
      : this(
          id: '',
          message: '',
          status: RequestStatus.pending,
          requesterId: '',
          requesterName: '',
          helperId: '',
          helperName: '',
          createdAt: DateTime.now(),
        );

  /// Create a request from JSON data
  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      id: json['id'] ?? '',
      message: json['message'] ?? '',
      status: RequestStatus.fromString(json['status'] ?? 'pending'),
      requesterId: json['requesterId'] ?? '',
      requesterName: json['requesterName'] ?? '',
      requesterPhotoLink: json['requesterPhotoLink'],
      helperId: json['helperId'] ?? '',
      helperName: json['helperName'] ?? '',
      helperPhotoLink: json['helperPhotoLink'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      locationAddress: json['locationAddress'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      acceptedAt: json['acceptedAt'] != null
          ? DateTime.parse(json['acceptedAt'])
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      rejectedAt: json['rejectedAt'] != null
          ? DateTime.parse(json['rejectedAt'])
          : null,
      rejectionReason: json['rejectionReason'],
      estimatedDuration: json['estimatedDuration'],
      estimatedCost: json['estimatedCost']?.toDouble(),
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      additionalData: json['additionalData'],
    );
  }

  /// Convert request to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'status': status.value,
      'requesterId': requesterId,
      'requesterName': requesterName,
      'requesterPhotoLink': requesterPhotoLink,
      'helperId': helperId,
      'helperName': helperName,
      'helperPhotoLink': helperPhotoLink,
      'latitude': latitude,
      'longitude': longitude,
      'locationAddress': locationAddress,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'acceptedAt': acceptedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'rejectedAt': rejectedAt?.toIso8601String(),
      'rejectionReason': rejectionReason,
      'estimatedDuration': estimatedDuration,
      'estimatedCost': estimatedCost,
      'tags': tags,
      'additionalData': additionalData,
    };
  }

  /// Create a copy of the request with updated fields
  Request copyWith({
    String? id,
    String? message,
    RequestStatus? status,
    String? requesterId,
    String? requesterName,
    String? requesterPhotoLink,
    String? helperId,
    String? helperName,
    String? helperPhotoLink,
    double? latitude,
    double? longitude,
    String? locationAddress,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? acceptedAt,
    DateTime? completedAt,
    DateTime? rejectedAt,
    String? rejectionReason,
    int? estimatedDuration,
    double? estimatedCost,
    List<String>? tags,
    Map<String, dynamic>? additionalData,
  }) {
    return Request(
      id: id ?? this.id,
      message: message ?? this.message,
      status: status ?? this.status,
      requesterId: requesterId ?? this.requesterId,
      requesterName: requesterName ?? this.requesterName,
      requesterPhotoLink: requesterPhotoLink ?? this.requesterPhotoLink,
      helperId: helperId ?? this.helperId,
      helperName: helperName ?? this.helperName,
      helperPhotoLink: helperPhotoLink ?? this.helperPhotoLink,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      locationAddress: locationAddress ?? this.locationAddress,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      completedAt: completedAt ?? this.completedAt,
      rejectedAt: rejectedAt ?? this.rejectedAt,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      tags: tags ?? this.tags,
      additionalData: additionalData ?? this.additionalData,
    );
  }

  /// Update request status with appropriate timestamp
  Request updateStatus(RequestStatus newStatus, {String? rejectionReason}) {
    DateTime? acceptedAt;
    DateTime? completedAt;
    DateTime? rejectedAt;
    DateTime? updatedAt = DateTime.now();

    switch (newStatus) {
      case RequestStatus.accepted:
        acceptedAt = DateTime.now();
        break;
      case RequestStatus.completed:
        completedAt = DateTime.now();
        break;
      case RequestStatus.rejected:
        rejectedAt = DateTime.now();
        break;
      default:
        break;
    }

    return copyWith(
      status: newStatus,
      acceptedAt: acceptedAt,
      completedAt: completedAt,
      rejectedAt: rejectedAt,
      updatedAt: updatedAt,
      rejectionReason: rejectionReason,
    );
  }

  /// Check if request is from a specific user
  bool isFromUser(String userId) {
    return requesterId == userId;
  }

  /// Check if request is to a specific user
  bool isToUser(String userId) {
    return helperId == userId;
  }

  /// Get the other user's ID (not the current user)
  String getOtherUserId(String currentUserId) {
    return requesterId == currentUserId ? helperId : requesterId;
  }

  /// Get the other user's name
  String getOtherUserName(String currentUserId) {
    return requesterId == currentUserId ? helperName : requesterName;
  }

  /// Get the other user's photo link
  String? getOtherUserPhotoLink(String currentUserId) {
    return requesterId == currentUserId ? helperPhotoLink : requesterPhotoLink;
  }

  /// Get formatted duration string
  String get formattedDuration {
    if (estimatedDuration == null) return 'Not specified';

    final hours = estimatedDuration! ~/ 60;
    final minutes = estimatedDuration! % 60;

    if (hours > 0) {
      return minutes > 0 ? '${hours}h ${minutes}m' : '${hours}h';
    } else {
      return '${minutes}m';
    }
  }

  /// Get formatted cost string
  String get formattedCost {
    if (estimatedCost == null) return 'Free';
    return '\$${estimatedCost!.toStringAsFixed(2)}';
  }

  /// Get time ago string for creation
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  @override
  String toString() {
    return 'Request(id: $id, status: $status, requester: $requesterName, helper: $helperName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Request && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
