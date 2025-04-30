// lib/widgets/assistance_request_card.dart
import 'package:flutter/material.dart';
import '../data/models/assistance_request.dart';
import '../utils/theme.dart';

class AssistanceRequestCard extends StatelessWidget {
  final AssistanceRequest request;
  final VoidCallback onCompletePressed;

  const AssistanceRequestCard({
    super.key, // Changed to super parameter syntax
    required this.request,
    required this.onCompletePressed,
  });

  @override
  Widget build(BuildContext context) {
    // Déterminer si la demande est terminée
    final bool isCompleted = request.status == 'completed';
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Avatar pour l'icône utilisateur
            CircleAvatar(
              backgroundColor: isCompleted ? Colors.green : AppTheme.accentColor,
              child: Icon(
                isCompleted ? Icons.check : Icons.person,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            // Détails de la demande d'assistance
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    request.userId,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    request.tableId,
                    style: const TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                  // Afficher le statut si terminé
                  if (isCompleted)
                    const Text(
                      'Terminée',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
            // Bouton d'action (masqué si terminé)
            if (!isCompleted)
              ElevatedButton(
                onPressed: onCompletePressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.secondaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: const Text(
                  'Terminer',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            // Afficher une icône ou indication si terminé
            if (isCompleted)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1), // Fixed deprecated withOpacity
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Terminée',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}