// lib/screens/notifications/notification_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/notifications/notification_bloc.dart';
import '../../blocs/notifications/notification_event.dart';
import '../../blocs/notifications/notification_state.dart';
import '../../utils/theme.dart';
import '../../utils/constants.dart';
import '../../widgets/notification_item.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    // Charger les notifications au démarrage
    context.read<NotificationBloc>().add(LoadNotifications());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        toolbarHeight: 70, // Augmenter la hauteur de l'AppBar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.accentColor),
          onPressed: () => Navigator.of(context).pop(),
          padding: const EdgeInsets.only(left: 16, top: 8), // Ajuster le padding
        ),
        centerTitle: true, // Centrer le titre
        title: const Padding(
          padding: EdgeInsets.only(top: 8), // Ajuster le padding du titre
          child: Text(
            'Notification',
            style: TextStyle(
              color: AppTheme.accentColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 8), // Ajuster le padding
            child: IconButton(
              icon: const Icon(Icons.chat_bubble_outline, color: AppTheme.accentColor),
              onPressed: () {
                // Rediriger vers l'écran de messagerie (liste des contacts)
                Navigator.of(context).pushNamed(AppConstants.messagesRoute);
              },
            ),
          ),
        ],
      ),
      body: BlocConsumer<NotificationBloc, NotificationState>(
        listener: (context, state) {
          if (state.status == NotificationStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Une erreur est survenue')),
            );
          }
        },
        builder: (context, state) {
          if (state.status == NotificationStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state.notifications.isEmpty) {
            return const Center(
              child: Text(
                'Aucune notification',
                style: TextStyle(
                  color: AppTheme.accentColor,
                  fontSize: 16,
                ),
              ),
            );
          }
          
          return RefreshIndicator(
            onRefresh: () async {
              context.read<NotificationBloc>().add(LoadNotifications());
            },
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12), // Ajouter du padding vertical à la liste
              itemCount: state.notifications.length,
              itemBuilder: (context, index) {
                final notification = state.notifications[index];
                return NotificationItem(notification: notification);
              },
            ),
          );
        },
      ),
    );
  }
}