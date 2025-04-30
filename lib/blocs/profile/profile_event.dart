// lib/blocs/profile/profile_event.dart
abstract class ProfileEvent {}

class LoadProfileStats extends ProfileEvent {}

class IncrementHandledOrders extends ProfileEvent {}