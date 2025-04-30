// lib/data/models/message.dart
class ChatMessage {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime timestamp;
  final bool isRead;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    this.isRead = false,
  });
}

class Contact {
  final String id;
  final String name;
  final String avatarUrl;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final int unreadCount;

  Contact({
    required this.id,
    required this.name,
    required this.avatarUrl,
    this.lastMessage,
    this.lastMessageTime,
    this.unreadCount = 0,
  });
}