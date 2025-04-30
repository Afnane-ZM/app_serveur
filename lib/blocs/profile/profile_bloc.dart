// lib/blocs/profile/profile_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/profile_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;

  ProfileBloc({required this.profileRepository}) : super(ProfileState.initial()) {
    on<LoadProfileStats>(_onLoadProfileStats);
    on<IncrementHandledOrders>(_onIncrementHandledOrders);
  }

  Future<void> _onLoadProfileStats(
    LoadProfileStats event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileState.loading());
    try {
      final stats = await profileRepository.getProfileStats();
      emit(ProfileState.loaded(stats));
    } catch (e) {
      emit(ProfileState.error(e.toString()));
    }
  }

  Future<void> _onIncrementHandledOrders(
    IncrementHandledOrders event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      final stats = await profileRepository.incrementHandledOrders();
      emit(ProfileState.loaded(stats));
    } catch (e) {
      emit(ProfileState.error(e.toString()));
    }
  }
}