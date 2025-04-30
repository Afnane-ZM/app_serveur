// lib/data/models/profile_stats.dart
class ProfileStats {
  final int handledOrders;

  ProfileStats({
    required this.handledOrders,
  });

  ProfileStats copyWith({
    int? handledOrders,
  }) {
    return ProfileStats(
      handledOrders: handledOrders ?? this.handledOrders,
    );
  }

  factory ProfileStats.fromJson(Map<String, dynamic> json) {
    return ProfileStats(
      handledOrders: json['handledOrders'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'handledOrders': handledOrders,
    };
  }
}