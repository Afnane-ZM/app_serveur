// lib/widgets/notifications/notification_item.dart
import 'package:flutter/material.dart';
import '../../data/models/notification.dart';
import '../../utils/theme.dart';

class NotificationItem extends StatelessWidget {
  final UserNotification notification;

  const NotificationItem({
    Key? key,
    required this.notification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16), // Augmenter les marges
      padding: const EdgeInsets.all(14), // Augmenter le padding interne
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [  // Ajouter une légère ombre pour plus de profondeur
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icône de notification
          const Icon(
            Icons.notifications_active,
            color: AppTheme.primaryColor,
            size: 26,  // Agrandir légèrement l'icône
          ),
          const SizedBox(width: 12),  // Augmenter l'espacement
          
          // Contenu de la notification
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.content,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,  // Police légèrement plus grande
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),  // Plus d'espace entre le texte et l'horodatage
                Text(
                  notification.getTimeAgo(),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}