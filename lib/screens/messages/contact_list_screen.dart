// lib/screens/messages/contact_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/messages/message_bloc.dart';
import '../../blocs/messages/message_event.dart';
import '../../blocs/messages/message_state.dart';
import '../../utils/theme.dart';
import 'chat_screen.dart';
import '../../widgets/messages/contact_item.dart';

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({super.key});

  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  @override
  void initState() {
    super.initState();
    // Charger les contacts au démarrage
    context.read<MessageBloc>().add(LoadContacts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        toolbarHeight: 70,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.accentColor),
          onPressed: () => Navigator.of(context).pop(),
          padding: const EdgeInsets.only(left: 16, top: 8),
        ),
        centerTitle: true,
        title: const Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text(
            'Messagerie',
            style: TextStyle(
              color: AppTheme.accentColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
      ),
      body: BlocConsumer<MessageBloc, MessageState>(
        listener: (context, state) {
          if (state.status == MessageStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Une erreur est survenue')),
            );
          }
        },
        builder: (context, state) {
          if (state.status == MessageStatus.loading && state.contacts.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state.contacts.isEmpty) {
            return const Center(
              child: Text(
                'Aucun contact',
                style: TextStyle(
                  color: AppTheme.accentColor,
                  fontSize: 16,
                ),
              ),
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: state.contacts.length,
            itemBuilder: (context, index) {
              final contact = state.contacts[index];
              return ContactItem(
                contact: contact,
                onTap: () {
                  // Charger les messages pour ce contact
                  context.read<MessageBloc>().add(LoadMessages(contactId: contact.id));
                  
                  // Naviguer vers l'écran de chat
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(contactId: contact.id, contactName: contact.name),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}