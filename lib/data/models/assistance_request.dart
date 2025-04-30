// lib/data/models/assistance_request.dart

class AssistanceRequest {
  final String id;
  final String tableId;
  
  final String userId;
  final DateTime createdAt;
  final String status; // 'pending', 'completed', etc.

  AssistanceRequest({
    required this.id,
    required this.tableId,
    
    required this.userId,
    required this.createdAt,
    required this.status,
  });

  factory AssistanceRequest.fromJson(Map<String, dynamic> json) {
    return AssistanceRequest(
      id: json['id'] as String,
      tableId: json['tableId'] as String,
      
      userId: json['userId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tableId': tableId,
     
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
    };
  }

  AssistanceRequest copyWith({
    String? id,
    String? tableId,
    String? tableName,
    String? userId,
    DateTime? createdAt,
    String? status,
  }) {
    return AssistanceRequest(
      id: id ?? this.id,
      tableId: tableId ?? this.tableId,
  
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }
}