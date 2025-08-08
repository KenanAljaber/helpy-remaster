import 'package:helpy/api/api_client.dart';
import 'package:helpy/models/conversation.dart';
import 'package:helpy/models/message.dart';
import 'package:helpy/models/request.dart';

class ChatService {
  final ApiClient _apiClient = ApiClient();

  // Mock data for development
  List<Conversation> _mockConversations = [
    Conversation(
      id: 'conv1',
      requestId: 'req1',
      user1Id: 'current_user',
      user1Name: 'You',
      user1PhotoLink: null,
      user2Id: 'user2',
      user2Name: 'John Smith',
      user2PhotoLink: null,
      lastMessageAt: DateTime.now().subtract(const Duration(minutes: 5)),
      lastMessage: Message(
        id: 'msg1',
        conversationId: 'conv1',
        senderId: 'user2',
        senderName: 'John Smith',
        content:
            'I can help you with the math homework. When would you like to meet?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      unreadCount: 1,
    ),
    Conversation(
      id: 'conv2',
      requestId: 'req2',
      user1Id: 'current_user',
      user1Name: 'You',
      user1PhotoLink: null,
      user2Id: 'user3',
      user2Name: 'Sarah Johnson',
      user2PhotoLink: null,
      lastMessageAt: DateTime.now().subtract(const Duration(hours: 2)),
      lastMessage: Message(
        id: 'msg2',
        conversationId: 'conv2',
        senderId: 'current_user',
        senderName: 'You',
        content:
            'Thank you for accepting! I\'ll be at the grocery store at 3 PM.',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: true,
      ),
      unreadCount: 0,
    ),
    Conversation(
      id: 'conv3',
      requestId: 'req3',
      user1Id: 'current_user',
      user1Name: 'You',
      user1PhotoLink: null,
      user2Id: 'user8',
      user2Name: 'David Lee',
      user2PhotoLink: null,
      lastMessageAt: DateTime.now().subtract(const Duration(days: 1)),
      lastMessage: Message(
        id: 'msg3',
        conversationId: 'conv3',
        senderId: 'user8',
        senderName: 'David Lee',
        content:
            'The garden looks great! Thanks for your help with the planting.',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
      ),
      unreadCount: 0,
    ),
  ];

  Map<String, List<Message>> _mockMessages = {
    'conv1': [
      Message(
        id: 'msg1_1',
        conversationId: 'conv1',
        senderId: 'current_user',
        senderName: 'You',
        content: 'Hi John! I need help with calculus homework.',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        isRead: true,
      ),
      Message(
        id: 'msg1_2',
        conversationId: 'conv1',
        senderId: 'user2',
        senderName: 'John Smith',
        content: 'Hello! I\'d be happy to help you with calculus.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
        isRead: true,
      ),
      Message(
        id: 'msg1_3',
        conversationId: 'conv1',
        senderId: 'user2',
        senderName: 'John Smith',
        content:
            'I can help you with the math homework. When would you like to meet?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        isRead: false,
      ),
    ],
    'conv2': [
      Message(
        id: 'msg2_1',
        conversationId: 'conv2',
        senderId: 'user3',
        senderName: 'Sarah Johnson',
        content: 'I\'d be happy to help you with grocery shopping!',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        isRead: true,
      ),
      Message(
        id: 'msg2_2',
        conversationId: 'conv2',
        senderId: 'current_user',
        senderName: 'You',
        content:
            'Thank you for accepting! I\'ll be at the grocery store at 3 PM.',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: true,
      ),
    ],
    'conv3': [
      Message(
        id: 'msg3_1',
        conversationId: 'conv3',
        senderId: 'user8',
        senderName: 'David Lee',
        content: 'Hi! I need help with my garden maintenance.',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        isRead: true,
      ),
      Message(
        id: 'msg3_2',
        conversationId: 'conv3',
        senderId: 'current_user',
        senderName: 'You',
        content:
            'I can help you with that! What kind of maintenance do you need?',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        isRead: true,
      ),
      Message(
        id: 'msg3_3',
        conversationId: 'conv3',
        senderId: 'user8',
        senderName: 'David Lee',
        content:
            'The garden looks great! Thanks for your help with the planting.',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
      ),
    ],
  };

  /// Get all conversations for a user
  Future<List<Conversation>> getConversations(String userId) async {
    // TODO: Replace with actual API call when backend is ready
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    return _mockConversations
        .where((conv) => conv.involvesUser(userId))
        .toList()
      ..sort((a, b) => (b.lastMessageAt ?? b.createdAt)
          .compareTo(a.lastMessageAt ?? a.createdAt));
  }

  /// Get messages for a specific conversation
  Future<List<Message>> getMessages(String conversationId) async {
    // TODO: Replace with actual API call when backend is ready
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 300));

    // Return a defensive copy to avoid external code holding a reference
    // to the internal list and accidentally causing duplication when both
    // sides mutate the same list instance.
    return List<Message>.from(_mockMessages[conversationId] ?? []);
  }

  /// Send a new message
  Future<Message?> sendMessage(Message message) async {
    // TODO: Replace with actual API call when backend is ready
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 200));

    // Add message to mock data
    final newMessage = message.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
    );

    if (_mockMessages[message.conversationId] == null) {
      _mockMessages[message.conversationId] = [];
    }
    _mockMessages[message.conversationId]!.add(newMessage);

    // Update conversation's last message
    final convIndex =
        _mockConversations.indexWhere((c) => c.id == message.conversationId);
    if (convIndex != -1) {
      _mockConversations[convIndex] =
          _mockConversations[convIndex].updateWithMessage(newMessage);
    }

    return newMessage;
  }

  /// Create a new conversation from a request
  Future<Conversation?> createConversationFromRequest(
      Request request, String currentUserId) async {
    // TODO: Replace with actual API call when backend is ready
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 400));

    final conversation = Conversation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      requestId: request.id,
      user1Id: request.requesterId,
      user1Name: request.requesterName,
      user1PhotoLink: request.requesterPhotoLink,
      user2Id: request.helperId,
      user2Name: request.helperName,
      user2PhotoLink: request.helperPhotoLink,
      createdAt: DateTime.now(),
    );

    // Add system message
    final systemMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      conversationId: conversation.id,
      senderId: 'system',
      senderName: 'System',
      type: MessageType.system,
      content: 'Help request accepted! You can now chat with each other.',
      timestamp: DateTime.now(),
      isRead: true,
    );

    _mockConversations.add(conversation);
    _mockMessages[conversation.id] = [systemMessage];

    return conversation;
  }

  /// Mark conversation as read
  Future<bool> markConversationAsRead(
      String conversationId, String userId) async {
    // TODO: Replace with actual API call when backend is ready
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 200));

    // Update conversation
    final convIndex =
        _mockConversations.indexWhere((c) => c.id == conversationId);
    if (convIndex != -1) {
      _mockConversations[convIndex] =
          _mockConversations[convIndex].markAsRead();
    }

    // Mark all messages as read
    final messages = _mockMessages[conversationId];
    if (messages != null) {
      for (int i = 0; i < messages.length; i++) {
        if (!messages[i].isFromUser(userId) && !messages[i].isRead) {
          _mockMessages[conversationId]![i] = messages[i].markAsRead();
        }
      }
    }

    return true;
  }

  /// Get unread conversations count
  Future<int> getUnreadConversationsCount(String userId) async {
    // TODO: Replace with actual API call when backend is ready
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 200));

    return _mockConversations
        .where((conv) => conv.involvesUser(userId) && conv.hasUnreadMessages)
        .length;
  }

  /// Archive a conversation
  Future<bool> archiveConversation(String conversationId) async {
    // TODO: Replace with actual API call when backend is ready
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 300));

    final convIndex =
        _mockConversations.indexWhere((c) => c.id == conversationId);
    if (convIndex != -1) {
      _mockConversations[convIndex] = _mockConversations[convIndex].copyWith(
        status: ConversationStatus.archived,
      );
    }

    return true;
  }

  /// Block a conversation
  Future<bool> blockConversation(String conversationId) async {
    // TODO: Replace with actual API call when backend is ready
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 300));

    final convIndex =
        _mockConversations.indexWhere((c) => c.id == conversationId);
    if (convIndex != -1) {
      _mockConversations[convIndex] = _mockConversations[convIndex].copyWith(
        status: ConversationStatus.blocked,
      );
    }

    return true;
  }

  /// Get conversation by ID
  Future<Conversation?> getConversationById(String conversationId) async {
    // TODO: Replace with actual API call when backend is ready
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 200));

    return _mockConversations.where((c) => c.id == conversationId).firstOrNull;
  }

  /// Delete a conversation
  Future<bool> deleteConversation(String conversationId) async {
    // TODO: Replace with actual API call when backend is ready
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 300));

    _mockConversations.removeWhere((c) => c.id == conversationId);
    _mockMessages.remove(conversationId);

    return true;
  }
}
