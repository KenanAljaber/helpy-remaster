import 'package:flutter/material.dart';
import 'package:helpy/api/services/chat_service.dart';
import 'package:helpy/models/conversation.dart';
import 'package:helpy/models/message.dart';
import 'package:helpy/screens/chat/conversation_detail_screen.dart';
import 'package:helpy/styles/theme.dart';
import 'package:helpy/widgets/profile_picture_selector.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Conversation> _conversations = [];
  final ChatService _chatService = ChatService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Replace with actual user ID from authentication
      const String currentUserId = 'current_user';
      final conversations = await _chatService.getConversations(currentUserId);

      if (mounted) {
        setState(() {
          _conversations = conversations;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showMessage('Error loading conversations: $e');
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.primaryColor,
      ),
    );
  }

  void _onConversationTap(Conversation conversation) async {
    // TODO: Replace with actual user ID from authentication
    const String currentUserId = 'current_user';

    // Mark conversation as read
    await _chatService.markConversationAsRead(conversation.id, currentUserId);

    // Navigate to conversation detail
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConversationDetailScreen(
          conversation: conversation,
          currentUserId: currentUserId,
        ),
      ),
    ).then((_) {
      // Refresh conversations when returning
      _loadConversations();
    });
  }

  void _showConversationOptions(Conversation conversation) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.archive),
              title: const Text('Archive'),
              onTap: () async {
                Navigator.pop(context);
                await _archiveConversation(conversation);
              },
            ),
            ListTile(
              leading: const Icon(Icons.block),
              title: const Text('Block'),
              onTap: () async {
                Navigator.pop(context);
                await _blockConversation(conversation);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () async {
                Navigator.pop(context);
                await _deleteConversation(conversation);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _archiveConversation(Conversation conversation) async {
    try {
      final success = await _chatService.archiveConversation(conversation.id);
      if (success) {
        _loadConversations();
        _showMessage('Conversation archived');
      } else {
        _showMessage('Failed to archive conversation');
      }
    } catch (e) {
      _showMessage('Error archiving conversation: $e');
    }
  }

  Future<void> _blockConversation(Conversation conversation) async {
    try {
      final success = await _chatService.blockConversation(conversation.id);
      if (success) {
        _loadConversations();
        _showMessage('Conversation blocked');
      } else {
        _showMessage('Failed to block conversation');
      }
    } catch (e) {
      _showMessage('Error blocking conversation: $e');
    }
  }

  Future<void> _deleteConversation(Conversation conversation) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Conversation'),
        content: const Text(
            'Are you sure you want to delete this conversation? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final success = await _chatService.deleteConversation(conversation.id);
        if (success) {
          _loadConversations();
          _showMessage('Conversation deleted');
        } else {
          _showMessage('Failed to delete conversation');
        }
      } catch (e) {
        _showMessage('Error deleting conversation: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Chats',
          style: TextStyle(
            color: AppColors.almostBlack,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.almostBlack),
            onPressed: () {
              // TODO: Implement search functionality
              _showMessage('Search functionality coming soon!');
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _conversations.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _loadConversations,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _conversations.length,
                    itemBuilder: (context, index) {
                      final conversation = _conversations[index];
                      return _buildConversationCard(conversation);
                    },
                  ),
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Conversations Yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start helping others or request help to begin conversations!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildConversationCard(Conversation conversation) {
    // TODO: Replace with actual user ID from authentication
    const String currentUserId = 'current_user';

    final otherUserName = conversation.getOtherUserName(currentUserId);
    final otherUserPhoto = conversation.getOtherUserPhotoLink(currentUserId);
    final hasUnread = conversation.hasUnreadMessages;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _onConversationTap(conversation),
        onLongPress: () => _showConversationOptions(conversation),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Profile picture with unread indicator
              Stack(
                children: [
                  ProfilePictureSelector(
                    initialImagePath: otherUserPhoto,
                    size: 50,
                    isEditable: false,
                    fallbackText: otherUserName.isNotEmpty
                        ? otherUserName[0].toUpperCase()
                        : 'U',
                  ),
                  if (hasUnread)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              // Conversation details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            otherUserName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  hasUnread ? FontWeight.w600 : FontWeight.w500,
                              color: AppColors.almostBlack,
                            ),
                          ),
                        ),
                        Text(
                          conversation.formattedLastMessageTime,
                          style: TextStyle(
                            fontSize: 12,
                            color: hasUnread
                                ? AppColors.primaryColor
                                : Colors.grey[600],
                            fontWeight:
                                hasUnread ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            conversation.lastMessagePreview,
                            style: TextStyle(
                              fontSize: 14,
                              color: hasUnread
                                  ? AppColors.almostBlack
                                  : Colors.grey[600],
                              fontWeight: hasUnread
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (hasUnread) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              conversation.unreadCount.toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
