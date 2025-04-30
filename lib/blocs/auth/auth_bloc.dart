// lib/blocs/auth/auth_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthState.initial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<ChangePasswordRequested>(_onChangePasswordRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.loading());
    try {
      final user = await authRepository.login(
        event.email,
        event.password,
      );
      emit(AuthState.authenticated(user));
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.loading());
    try {
      await authRepository.logout();
      emit(AuthState.unauthenticated());
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  Future<void> _onChangePasswordRequested(
    ChangePasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    // Conserver l'état actuel de l'utilisateur avant de passer à l'état de chargement
    final currentUser = state.user;
    
    // Seulement si nous avons un utilisateur
    if (currentUser != null) {
      emit(AuthState.loading());
      try {
        final success = await authRepository.changePassword(
          event.currentPassword,
          event.newPassword,
        );
        
        if (success) {
          // Très important : on conserve l'utilisateur actuel dans l'état authentifié
          emit(AuthState.authenticated(currentUser));
        } else {
          // Ce cas ne devrait pas se produire car le repository lance une exception en cas d'échec
          // Mais par précaution, nous gérons ce cas
          emit(AuthState.error("Échec du changement de mot de passe"));
        }
      } catch (e) {
        // En cas d'erreur, on reste authentifié mais on indique l'erreur
        emit(AuthState.authenticatedWithError(currentUser, e.toString()));
      }
    } else {
      emit(AuthState.error("Utilisateur non connecté"));
    }
  }
}