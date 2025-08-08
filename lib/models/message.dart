import 'package:helpy/models/user/user.dart';

/// Enum for message types
enum MessageType {
  text,
  image,
  location,
  system;

  /// Convert type to string for API communication
  String get value {
    switch (this) {
      case MessageType.text:
        return 'text';
      case MessageType.image:
        return 'image';
      case MessageType.location:
        return 'location';
      case MessageType.system:
        return 'system';
    }
  }

  /// Convert string to type
  static MessageType fromString(String type) {
    switch (type.toLowerCase()) {
      case 'text':
        return MessageType.text;
      case 'image':
        return MessageType.image;
      case 'location':
        return MessageType.location;
      case 'system':
        return MessageType.system;
      default:
        return MessageType.text;
    }
  }
}

/// Model for individual messages in conversations
class Message {
  final String id;
  final String conversationId;
  final String senderId;
  final String senderName;
  final String? senderPhotoLink;
  final MessageType type;
  final String content;
  final String? imageUrl;
  final double? latitude;
  final double? longitude;
  final DateTime timestamp;
  final bool isRead;
  final DateTime? readAt;
  final Map<String, dynamic>? metadata;

  Message({
    this.id = '',
    required this.conversationId,
    required this.senderId,
    required this.senderName,
    this.senderPhotoLink,
    this.type = MessageType.text,
    required this.content,
    this.imageUrl,
    this.latitude,
    this.longitude,
    DateTime? timestamp,
    this.isRead = false,
    this.readAt,
    this.metadata,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Create an empty message
  Message.empty()
      : this(
          id: '',
          conversationId: '',
          senderId: '',
          senderName: '',
          content: '',
          timestamp: DateTime.now(),
        );

  /// Create a message from JSON data
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] ?? '',
      conversationId: json['conversationId'] ?? '',
      senderId: json['senderId'] ?? '',
      senderName: json['senderName'] ?? '',
      senderPhotoLink: json['senderPhotoLink'],
      type: MessageType.fromString(json['type'] ?? 'text'),
      content: json['content'] ?? '',
      imageUrl: json['imageUrl'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      isRead: json['isRead'] ?? false,
      readAt: json['readAt'] != null ? DateTime.parse(json['readAt']) : null,
      metadata: json['metadata'],
    );
  }

  /// Convert message to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversationId': conversationId,
      'senderId': senderId,
      'senderName': senderName,
      'senderPhotoLink': senderPhotoLink,
      'type': type.value,
      'content': content,
      'imageUrl': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'readAt': readAt?.toIso8601String(),
      'metadata': metadata,
    };
  }

  /// Create a copy of the message with updated fields
  Message copyWith({
    String? id,
    String? conversationId,
    String? senderId,
    String? senderName,
    String? senderPhotoLink,
    MessageType? type,
    String? content,
    String? imageUrl,
    double? latitude,
    double? longitude,
    DateTime? timestamp,
    bool? isRead,
    DateTime? readAt,
    Map<String, dynamic>? metadata,
  }) {
    return Message(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderPhotoLink: senderPhotoLink ?? this.senderPhotoLink,
      type: type ?? this.type,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Mark message as read
  Message markAsRead() {
    return copyWith(
      isRead: true,
      readAt: DateTime.now(),
    );
  }

  /// Check if message is from a specific user
  bool isFromUser(String userId) {
    return senderId == userId;
  }

  /// Get formatted time string
  String get formattedTime {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate =
        DateTime(timestamp.year, timestamp.month, timestamp.day);

    if (messageDate == today) {
      // Today - show time only
      return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      // Yesterday
      return 'Yesterday';
    } else if (now.difference(timestamp).inDays < 7) {
      // This week - show day name
      final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return days[timestamp.weekday - 1];
    } else {
      // Older - show date
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  /// Get time ago string
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

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

  /// Check if message is a system message
  bool get isSystemMessage => type == MessageType.system;

  /// Check if message contains location
  bool get hasLocation => latitude != null && longitude != null;

  /// Check if message contains image
  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  @override
  String toString() {
    return 'Message(id: $id, sender: $senderName, content: ${content.length > 20 ? '${content.substring(0, 20)}...' : content})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Message && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

