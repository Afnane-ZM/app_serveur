// lib/widgets/home/order_card.dart
import 'package:flutter/material.dart';
import '../../data/models/order.dart';
import '../../utils/theme.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback onActionPressed;
  final bool isNew; 

  const OrderCard({
    super.key,
    required this.order,
    required this.onActionPressed,
    required this.isNew,
  });

  @override
  Widget build(BuildContext context) {
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
          
            const CircleAvatar(
              backgroundColor: AppTheme.accentColor,
              child: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            // Détails de la commande
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.id,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    order.tableId,
                    style: const TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    '${order.customerCount} personnes',
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            // Bouton d'action
            ElevatedButton(
              onPressed: onActionPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: isNew ? AppTheme.accentColor : AppTheme.secondaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text(
                isNew ? 'Servir' : 'En Préparation',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}