# Chat System Guide

## Overview

The chat system allows users to communicate after a help request has been accepted. When a user accepts a help request, a new conversation is automatically created between the requester and the helper.

## Models

### Message Model (`lib/models/message.dart`)

Represents individual messages in conversations.

**Key Features:**
- Multiple message types: text, image, location, system
- Read status tracking
- Timestamp formatting
- Sender information

**Message Types:**
- `text`: Regular text messages
- `image`: Image messages (future implementation)
- `location`: Location sharing (future implementation)
- `system`: System-generated messages (e.g., "Help request accepted!")

### Conversation Model (`lib/models/conversation.dart`)

Represents chat rooms between two users.

**Key Features:**
- Links to the original help request
- User information for both participants
- Last message tracking
- Unread message count
- Conversation status (active, archived, blocked)

## Services

### ChatService (`lib/api/services/chat_service.dart`)

Handles all chat-related operations with mock data.

**Key Methods:**
- `getConversations(userId)`: Get all conversations for a user
- `getMessages(conversationId)`: Get messages for a specific conversation
- `sendMessage(message)`: Send a new message
- `createConversationFromRequest(request, currentUserId)`: Create conversation from accepted request
- `markConversationAsRead(conversationId, userId)`: Mark conversation as read
- `archiveConversation(conversationId)`: Archive a conversation
- `blockConversation(conversationId)`: Block a conversation
- `deleteConversation(conversationId)`: Delete a conversation

## Screens

### ChatScreen (`lib/screens/chat/chat_screen.dart`)

Main chat screen showing all conversations.

**Features:**
- List of all conversations
- Unread message indicators
- Pull-to-refresh
- Long press for conversation options (archive, block, delete)
- Empty state when no conversations exist

### ConversationDetailScreen (`lib/screens/chat/conversation_detail_screen.dart`)

Individual conversation view with message history.

**Features:**
- Real-time message display
- Message input with send functionality
- System message support
- Auto-scroll to bottom
- Loading states
- Empty state for new conversations

## Integration

### Automatic Conversation Creation

When a help request is accepted in the notifications screen, a conversation is automatically created:

1. User accepts a help request
2. `NotificationService.acceptRequest()` is called
3. Request status is updated to "accepted"
4. `ChatService.createConversationFromRequest()` is called
5. New conversation is created with a system message

### Navigation

- Chat screen is accessible via the bottom navigation bar
- Tapping a conversation opens the conversation detail screen
- Back navigation returns to the chat list

## Mock Data

The system includes comprehensive mock data for development:

**Sample Conversations:**
- Math homework help with John Smith
- Grocery shopping with Sarah Johnson
- Garden maintenance with David Lee

**Sample Messages:**
- Various message types and timestamps
- Unread message indicators
- System messages for accepted requests

## Future Enhancements

### Planned Features:
- Real-time messaging with WebSocket integration
- Image and file sharing
- Location sharing
- Message reactions
- Typing indicators
- Push notifications
- Message search functionality
- Conversation search and filtering

### API Integration:
- Replace mock data with actual API calls
- Implement real-time updates
- Add authentication and user management
- Handle offline message queuing

## Usage Examples

### Creating a Conversation from Request
```dart
final conversation = await chatService.createConversationFromRequest(request, currentUserId);
```

### Sending a Message
```dart
final message = Message(
  conversationId: conversation.id,
  senderId: currentUserId,
  senderName: 'You',
  content: 'Hello! How can I help you?',
);
final sentMessage = await chatService.sendMessage(message);
```

### Getting Conversations
```dart
final conversations = await chatService.getConversations(currentUserId);
```

### Marking as Read
```dart
await chatService.markConversationAsRead(conversationId, currentUserId);
```

## File Structure

```
lib/
├── models/
│   ├── message.dart
│   └── conversation.dart
├── api/services/
│   └── chat_service.dart
└── screens/chat/
    ├── chat_screen.dart
    └── conversation_detail_screen.dart
```

## Dependencies

- `flutter/material.dart`: UI components
- `helpy/api/api_client.dart`: HTTP client for future API integration
- `helpy/widgets/profile_picture_selector.dart`: User profile pictures
- `helpy/styles/theme.dart`: App theming

## Testing

The chat system is ready for testing with mock data. Users can:

1. Accept help requests in the notifications screen
2. View new conversations in the chat screen
3. Send and receive messages
4. Archive, block, or delete conversations
5. See unread message indicators

All functionality works with mock data and is ready for API integration when the backend is available.

