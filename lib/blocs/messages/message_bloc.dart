// lib/blocs/messages/message_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/message_repository.dart';
import '../../data/models/message.dart';
import 'message_event.dart';
import 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final MessageRepository messageRepository;

  MessageBloc({required this.messageRepository}) 
      : super(MessageState()) {
    on<LoadContacts>(_onLoadContacts);
    on<LoadMessages>(_onLoadMessages);
    on<SendMessage>(_onSendMessage);
    on<MarkMessagesAsRead>(_onMarkMessagesAsRead);
  }

  Future<void> _onLoadContacts(
    LoadContacts event,
    Emitter<MessageState> emit,
  ) async {
    emit(state.copyWith(status: MessageStatus.loading));
    try {
      final contacts = await messageRepository.getContacts();
      emit(state.copyWith(
        status: MessageStatus.loaded,
        contacts: contacts,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: MessageStatus.error,
        errorMessage: 'Impossible de charger les contacts',
      ));
    }
  }

  Future<void> _onLoadMessages(
    LoadMessages event,
    Emitter<MessageState> emit,
  ) async {
    emit(state.copyWith(
      status: MessageStatus.loading,
      activeContactId: event.contactId,
    ));
    
    try {
      final messages = await messageRepository.getMessagesWithContact(event.contactId);
      
      // Mettre à jour la map des messages
      final updatedMessagesByContact = Map<String, List<ChatMessage>>.from(state.messagesByContact);
      updatedMessagesByContact[event.contactId] = messages;
      
      emit(state.copyWith(
        status: MessageStatus.loaded,
        messagesByContact: updatedMessagesByContact,
      ));
      
      // Marquer les messages comme lus
      add(MarkMessagesAsRead(contactId: event.contactId));
    } catch (e) {
      emit(state.copyWith(
        status: MessageStatus.error,
        errorMessage: 'Impossible de charger les messages',
      ));
    }
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<MessageState> emit,
  ) async {
    emit(state.copyWith(status: MessageStatus.sending));
    
    try {
      final newMessage = await messageRepository.sendMessage(
        event.receiverId,
        event.content,
      );
      
      // Ajouter le nouveau message à la liste existante
      final currentMessages = List<ChatMessage>.from(
        state.messagesByContact[event.receiverId] ?? []
      );
      currentMessages.add(newMessage);
      
      // Mettre à jour la map des messages
      final updatedMessagesByContact = Map<String, List<ChatMessage>>.from(state.messagesByContact);
      updatedMessagesByContact[event.receiverId] = currentMessages;
      
      emit(state.copyWith(
        status: MessageStatus.loaded,
        messagesByContact: updatedMessagesByContact,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: MessageStatus.error,
        errorMessage: 'Impossible d\'envoyer le message',
      ));
    }
  }

  Future<void> _onMarkMessagesAsRead(
    MarkMessagesAsRead event,
    Emitter<MessageState> emit,
  ) async {
    try {
      await messageRepository.markMessagesAsRead(event.contactId);
      
      // Dans une vraie application, vous devriez mettre à jour l'état local
      // Pour marquer les messages comme lus
      final contactMessages = state.messagesByContact[event.contactId] ?? [];
      final updatedMessages = contactMessages.map((message) {
        if (message.receiverId == messageRepository.currentUserId && !message.isRead) {
          return ChatMessage(
            id: message.id,
            senderId: message.senderId,
            receiverId: message.receiverId,
            content: message.content,
            timestamp: message.timestamp,
            isRead: true,
          );
        }
        return message;
      }).toList();
      
      final updatedMessagesByContact = Map<String, List<ChatMessage>>.from(state.messagesByContact);
      updatedMessagesByContact[event.contactId] = updatedMessages;
      
      emit(state.copyWith(messagesByContact: updatedMessagesByContact));
    } catch (e) {
      // Gérer les erreurs silencieusement pour cette opération
    }
  }
}