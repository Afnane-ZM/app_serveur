// lib/data/repositories/profile_repository.dart
import '../models/profile_stats.dart';
import 'dart:async';

class ProfileRepository {
  // Simuler une source de données persistante
  ProfileStats _stats = ProfileStats(handledOrders: 152);
  
  // Récupérer les statistiques de l'utilisateur
  Future<ProfileStats> getProfileStats() async {
    // Simuler un délai réseau
    await Future.delayed(const Duration(milliseconds: 300));
    return _stats;
  }
  
  // Incrémenter le compteur de commandes servies
  Future<ProfileStats> incrementHandledOrders() async {
    // Simuler un délai réseau
    await Future.delayed(const Duration(milliseconds: 300));
    _stats = _stats.copyWith(handledOrders: _stats.handledOrders + 1);
    return _stats;
  }
}