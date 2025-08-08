import 'package:helpy/models/message.dart';
import 'package:helpy/models/request.dart';

/// Enum for conversation status
enum ConversationStatus {
  active,
  archived,
  blocked;

  /// Convert status to string for API communication
  String get value {
    switch (this) {
      case ConversationStatus.active:
        return 'active';
      case ConversationStatus.archived:
        return 'archived';
      case ConversationStatus.blocked:
        return 'blocked';
    }
  }

  /// Convert string to status
  static ConversationStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return ConversationStatus.active;
      case 'archived':
        return ConversationStatus.archived;
      case 'blocked':
        return ConversationStatus.blocked;
      default:
        return ConversationStatus.active;
    }
  }
}

/// Model for conversations/chat rooms between users
class Conversation {
  final String id;
  final String requestId; // Associated help request
  final String user1Id;
  final String user1Name;
  final String? user1PhotoLink;
  final String user2Id;
  final String user2Name;
  final String? user2PhotoLink;
  final ConversationStatus status;
  final DateTime createdAt;
  final DateTime? lastMessageAt;
  final Message? lastMessage;
  final int unreadCount;
  final Map<String, dynamic>? metadata;

  Conversation({
    this.id = '',
    required this.requestId,
    required this.user1Id,
    required this.user1Name,
    this.user1PhotoLink,
    required this.user2Id,
    required this.user2Name,
    this.user2PhotoLink,
    this.status = ConversationStatus.active,
    DateTime? createdAt,
    this.lastMessageAt,
    this.lastMessage,
    this.unreadCount = 0,
    this.metadata,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Create an empty conversation
  Conversation.empty()
      : this(
          id: '',
          requestId: '',
          user1Id: '',
          user1Name: '',
          user2Id: '',
          user2Name: '',
          createdAt: DateTime.now(),
        );

  /// Create a conversation from JSON data
  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] ?? '',
      requestId: json['requestId'] ?? '',
      user1Id: json['user1Id'] ?? '',
      user1Name: json['user1Name'] ?? '',
      user1PhotoLink: json['user1PhotoLink'],
      user2Id: json['user2Id'] ?? '',
      user2Name: json['user2Name'] ?? '',
      user2PhotoLink: json['user2PhotoLink'],
      status: ConversationStatus.fromString(json['status'] ?? 'active'),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      lastMessageAt: json['lastMessageAt'] != null
          ? DateTime.parse(json['lastMessageAt'])
          : null,
      lastMessage: json['lastMessage'] != null
          ? Message.fromJson(json['lastMessage'])
          : null,
      unreadCount: json['unreadCount'] ?? 0,
      metadata: json['metadata'],
    );
  }

  /// Convert conversation to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'requestId': requestId,
      'user1Id': user1Id,
      'user1Name': user1Name,
      'user1PhotoLink': user1PhotoLink,
      'user2Id': user2Id,
      'user2Name': user2Name,
      'user2PhotoLink': user2PhotoLink,
      'status': status.value,
      'createdAt': createdAt.toIso8601String(),
      'lastMessageAt': lastMessageAt?.toIso8601String(),
      'lastMessage': lastMessage?.toJson(),
      'unreadCount': unreadCount,
      'metadata': metadata,
    };
  }

  /// Create a copy of the conversation with updated fields
  Conversation copyWith({
    String? id,
    String? requestId,
    String? user1Id,
    String? user1Name,
    String? user1PhotoLink,
    String? user2Id,
    String? user2Name,
    String? user2PhotoLink,
    ConversationStatus? status,
    DateTime? createdAt,
    DateTime? lastMessageAt,
    Message? lastMessage,
    int? unreadCount,
    Map<String, dynamic>? metadata,
  }) {
    return Conversation(
      id: id ?? this.id,
      requestId: requestId ?? this.requestId,
      user1Id: user1Id ?? this.user1Id,
      user1Name: user1Name ?? this.user1Name,
      user1PhotoLink: user1PhotoLink ?? this.user1PhotoLink,
      user2Id: user2Id ?? this.user2Id,
      user2Name: user2Name ?? this.user2Name,
      user2PhotoLink: user2PhotoLink ?? this.user2PhotoLink,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Get the other user's information (not the current user)
  String getOtherUserId(String currentUserId) {
    return user1Id == currentUserId ? user2Id : user1Id;
  }

  /// Get the other user's name
  String getOtherUserName(String currentUserId) {
    return user1Id == currentUserId ? user2Name : user1Name;
  }

  /// Get the other user's photo link
  String? getOtherUserPhotoLink(String currentUserId) {
    return user1Id == currentUserId ? user2PhotoLink : user1PhotoLink;
  }

  /// Check if conversation involves a specific user
  bool involvesUser(String userId) {
    return user1Id == userId || user2Id == userId;
  }

  /// Check if conversation is active
  bool get isActive => status == ConversationStatus.active;

  /// Check if conversation is archived
  bool get isArchived => status == ConversationStatus.archived;

  /// Check if conversation is blocked
  bool get isBlocked => status == ConversationStatus.blocked;

  /// Get formatted last message time
  String get formattedLastMessageTime {
    if (lastMessageAt == null) return '';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate =
        DateTime(lastMessageAt!.year, lastMessageAt!.month, lastMessageAt!.day);

    if (messageDate == today) {
      // Today - show time only
      return '${lastMessageAt!.hour.toString().padLeft(2, '0')}:${lastMessageAt!.minute.toString().padLeft(2, '0')}';
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      // Yesterday
      return 'Yesterday';
    } else if (now.difference(lastMessageAt!).inDays < 7) {
      // This week - show day name
      final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return days[lastMessageAt!.weekday - 1];
    } else {
      // Older - show date
      return '${lastMessageAt!.day}/${lastMessageAt!.month}/${lastMessageAt!.year}';
    }
  }

  /// Get time ago string for last message
  String get lastMessageTimeAgo {
    if (lastMessageAt == null) return '';

    final now = DateTime.now();
    final difference = now.difference(lastMessageAt!);

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

  /// Get last message preview
  String get lastMessagePreview {
    if (lastMessage == null) return 'No messages yet';

    final content = lastMessage!.content;
    if (content.length <= 50) return content;
    return '${content.substring(0, 47)}...';
  }

  /// Check if conversation has unread messages
  bool get hasUnreadMessages => unreadCount > 0;

  /// Mark conversation as read
  Conversation markAsRead() {
    return copyWith(
      unreadCount: 0,
    );
  }

  /// Update with new message
  Conversation updateWithMessage(Message message) {
    return copyWith(
      lastMessage: message,
      lastMessageAt: message.timestamp,
      unreadCount: unreadCount + 1,
    );
  }

  @override
  String toString() {
    return 'Conversation(id: $id, users: $user1Name & $user2Name, unread: $unreadCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Conversation && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

