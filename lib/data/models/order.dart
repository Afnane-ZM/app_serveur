// lib/data/models/order.dart
class Order {
  final String id;
  final String tableId;

  final int customerCount;
  final String status;
  final String userId;
  final DateTime createdAt;
  final List<dynamic> items;
  Order({
    required this.id,
    required this.tableId,

    required this.customerCount,
    required this.status,
    required this.userId,
    required this.createdAt,
    required this.items,
  });

Order copyWith({
  String? id,
  String? tableId,
  String? tableName,
  int? customerCount,
  String? status,
  String? userId,
  DateTime? createdAt,
  List<dynamic>? items,
}) {
  return Order(
    id: id ?? this.id,
    tableId: tableId ?? this.tableId,

    customerCount: customerCount ?? this.customerCount,
    status: status ?? this.status,
    userId: userId ?? this.userId,
    createdAt: createdAt ?? this.createdAt,
    items: items ?? this.items,
  );
}

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      tableId: json['tableId'] as String,

      customerCount: json['customerCount'] as int,
      status: json['status'] as String,
      userId: json['userId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tableId': tableId,

      'customerCount': customerCount,
      'status': status,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class OrderItem {
  final String id;
  final String name;
  final int quantity;
  final double price;

  OrderItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] as String,
      name: json['name'] as String,
      quantity: json['quantity'] as int,
      price: json['price'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'price': price,
    };
  }
}