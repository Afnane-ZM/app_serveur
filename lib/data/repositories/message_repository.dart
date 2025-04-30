// lib/data/repositories/message_repository.dart
import 'dart:async';
import '../models/message.dart';

class MessageRepository {
  // ID de l'utilisateur actuel (simulé)
  final String currentUserId = 'current_user';

  // Méthode pour récupérer la liste des contacts
  Future<List<Contact>> getContacts() async {
    // Simuler un délai réseau
    await Future.delayed(const Duration(milliseconds: 600));
    
    // Données simulées pour les contacts
    return [
      Contact(
        id: 'manager_id',
        name: 'Manager',
        avatarUrl: 'assets/images/manager_avatar.png',
        lastMessage: 'Veuillez vérifier la table 5',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 1)),
        unreadCount: 2,
      ),
      Contact(
        id: 'chef_id',
        name: 'Chef',
        avatarUrl: 'assets/images/chef_avatar.png',
        lastMessage: 'Commande prête pour la table 3',
        lastMessageTime: DateTime.now().subtract(const Duration(minutes: 30)),
        unreadCount: 0,
      ),
    ];
  }

  // Méthode pour récupérer les messages avec un contact spécifique
  Future<List<ChatMessage>> getMessagesWithContact(String contactId) async {
    // Simuler un délai réseau
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Simulation de la date actuelle pour générer des timestamps
    final now = DateTime.now();
    
    // Données simulées pour les messages
    if (contactId == 'manager_id') {
      return [
        ChatMessage(
          id: '1',
          senderId: 'manager_id',
          receiverId: currentUserId,
          content: 'Bonjour, comment se passe le service aujourd\'hui?',
          timestamp: now.subtract(const Duration(hours: 3)),
          isRead: true,
        ),
        ChatMessage(
          id: '2',
          senderId: currentUserId,
          receiverId: 'manager_id',
          content: 'Tout se passe bien, nous avons beaucoup de clients',
          timestamp: now.subtract(const Duration(hours: 2, minutes: 55)),
          isRead: true,
        ),
        ChatMessage(
          id: '3',
          senderId: 'manager_id',
          receiverId: currentUserId,
          content: 'Parfait! N\'oubliez pas de vérifier la table 5, ils attendent depuis un moment',
          timestamp: now.subtract(const Duration(hours: 1)),
          isRead: false,
        ),
        ChatMessage(
          id: '4',
          senderId: 'manager_id',
          receiverId: currentUserId,
          content: 'Et aussi préparez la réservation pour 20h',
          timestamp: now.subtract(const Duration(minutes: 30)),
          isRead: false,
        ),
      ];
    } else if (contactId == 'chef_id') {
      return [
        ChatMessage(
          id: '5',
          senderId: 'chef_id',
          receiverId: currentUserId,
          content: 'La commande pour la table 3 est prête',
          timestamp: now.subtract(const Duration(minutes: 30)),
          isRead: true,
        ),
        ChatMessage(
          id: '6',
          senderId: currentUserId,
          receiverId: 'chef_id',
          content: 'Je m\'en occupe tout de suite',
          timestamp: now.subtract(const Duration(minutes: 25)),
          isRead: true,
        ),
      ];
    }
    
    // Par défaut, retourner une liste vide
    return [];
  }

  // Méthode pour envoyer un message
  Future<ChatMessage> sendMessage(String receiverId, String content) async {
    // Simuler un délai réseau
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Créer un nouveau message
    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: currentUserId,
      receiverId: receiverId,
      content: content,
      timestamp: DateTime.now(),
    );
    
    return newMessage;
  }

  // Méthode pour marquer les messages comme lus
  Future<void> markMessagesAsRead(String contactId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    // Dans une vraie application, cette méthode mettrait à jour la base de données
    return;
  }
}