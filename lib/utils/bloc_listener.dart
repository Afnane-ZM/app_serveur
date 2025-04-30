// lib/utils/bloc_listener.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/orders/order_bloc.dart';
import '../blocs/orders/order_state.dart';
import '../blocs/profile/profile_bloc.dart';
import '../blocs/profile/profile_event.dart';

class AppBlocListener extends StatelessWidget {
  final Widget child;

  const AppBlocListener({super.key,required this.child}) ;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<OrderBloc, OrderState>(
          listenWhen: (previous, current) => 
              previous.status != current.status && 
              current.status == OrderStatus.served,
          listener: (context, state) {
            
            context.read<ProfileBloc>().add(IncrementHandledOrders());
          },
        ),
      ],
      child: child,
    );
  }
}