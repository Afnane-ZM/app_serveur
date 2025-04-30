// lib/blocs/messages/message_event.dart
abstract class MessageEvent {}

class LoadContacts extends MessageEvent {}

class LoadMessages extends MessageEvent {
  final String contactId;
  
  LoadMessages({required this.contactId});
}

class SendMessage extends MessageEvent {
  final String receiverId;
  final String content;
  
  SendMessage({required this.receiverId, required this.content});
}

class MarkMessagesAsRead extends MessageEvent {
  final String contactId;
  
  MarkMessagesAsRead({required this.contactId});
}