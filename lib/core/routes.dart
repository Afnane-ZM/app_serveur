// lib/core/routes.dart
import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/notifications/notification_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/orders/orders_screen.dart'; 
import '../screens/tables/tables_screen.dart';
import '../utils/constants.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
      case AppConstants.loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppConstants.homeRoute:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case AppConstants.notificationsRoute:
        return MaterialPageRoute(builder: (_) => const NotificationScreen());
     
      case '/profile':
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case '/orders': // Nouvelle route pour l'écran des commandes
        return MaterialPageRoute(builder: (_) => const OrdersScreen());
      case AppConstants.tablesRoute:
        return MaterialPageRoute( builder: (_) => const TablesScreen(), );
            
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Route inconnue'),
            ),
          ),
        );
    }
  }
}