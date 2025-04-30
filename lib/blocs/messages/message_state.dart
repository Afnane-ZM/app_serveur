// lib/blocs/messages/message_state.dart
import '../../data/models/message.dart';

enum MessageStatus { initial, loading, loaded, sending, error }

class MessageState {
  final MessageStatus status;
  final List<Contact> contacts;
  final Map<String, List<ChatMessage>> messagesByContact;
  final String? errorMessage;
  final String? activeContactId;

  MessageState({
    this.status = MessageStatus.initial,
    this.contacts = const [],
    this.messagesByContact = const {},
    this.errorMessage,
    this.activeContactId,
  });

  MessageState copyWith({
    MessageStatus? status,
    List<Contact>? contacts,
    Map<String, List<ChatMessage>>? messagesByContact,
    String? errorMessage,
    String? activeContactId,
  }) {
    return MessageState(
      status: status ?? this.status,
      contacts: contacts ?? this.contacts,
      messagesByContact: messagesByContact ?? this.messagesByContact,
      errorMessage: errorMessage ?? this.errorMessage,
      activeContactId: activeContactId ?? this.activeContactId,
    );
  }

  List<ChatMessage> get currentMessages {
    if (activeContactId == null) return [];
    return messagesByContact[activeContactId] ?? [];
  }
}