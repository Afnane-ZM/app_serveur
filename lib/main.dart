// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/orders/order_bloc.dart';
import 'blocs/notifications/notification_bloc.dart';
import 'blocs/messages/message_bloc.dart';
import 'blocs/profile/profile_bloc.dart';
import 'blocs/home/home_bloc.dart';
import 'core/routes.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/order_repository.dart';
import 'data/repositories/notification_repository.dart';
import 'data/repositories/message_repository.dart';
import 'data/repositories/profile_repository.dart'; 
import 'data/repositories/home_repository.dart';
import 'utils/theme.dart';
import 'utils/bloc_listener.dart';
import 'data/repositories/tables_repository.dart';
import 'blocs/tables/tables_bloc.dart';

void main() {

  initializeDateFormatting().then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepository(),
        ),
        RepositoryProvider<OrderRepository>(
          create: (context) => OrderRepository(),
        ),
        RepositoryProvider<HomeRepository>(
         create: (context) => HomeRepository(
        orderRepository: context.read<OrderRepository>(),
        ),
        ),

        RepositoryProvider<NotificationRepository>(
          create: (context) => NotificationRepository(),
        ),
        RepositoryProvider<MessageRepository>(
          create: (context) => MessageRepository(),
        ),
        RepositoryProvider<ProfileRepository>( 
          create: (context) => ProfileRepository(),
        ),
        RepositoryProvider<TablesRepository>(
          create: (context) => TablesRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider<OrderBloc>(
            create: (context) => OrderBloc(
              orderRepository: context.read<OrderRepository>(),
            ),
          ),
          BlocProvider<NotificationBloc>(
            create: (context) => NotificationBloc(
              notificationRepository: context.read<NotificationRepository>(),
            ),
          ),
          BlocProvider<MessageBloc>(
            create: (context) => MessageBloc(
              messageRepository: context.read<MessageRepository>(),
            ),
          ),
          BlocProvider<HomeBloc>(
            create: (context) => HomeBloc(
              homeRepository: context.read<HomeRepository>(),
            ),
          ),
          BlocProvider<ProfileBloc>( 
            create: (context) => ProfileBloc(
              profileRepository: context.read<ProfileRepository>(),
            ),
          ),
          BlocProvider<TablesBloc>(
            create: (context) => TablesBloc(
              tablesRepository: context.read<TablesRepository>(),
            ),
          ),
        ],
        child: AppBlocListener(
        child: MaterialApp(
          title: 'Good serve!',
          theme: AppTheme.theme,
          onGenerateRoute: AppRouter().onGenerateRoute,
          initialRoute: '/login',
        ),
      ),
      ),
    );
  }
}