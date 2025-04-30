// lib/blocs/tables/tables_state.dart
import '../../data/models/table.dart';
import '../../data/models/order.dart';

enum TablesStatus {
  initial,
  loading,
  loaded,
  updated,
  error,
}

class TablesState {
  final TablesStatus status;
  final List<RestaurantTable> tables;
  final Map<String, List<Order>> tableOrders;
  final String? errorMessage;

  TablesState({
    this.status = TablesStatus.initial,
    this.tables = const [],
    this.tableOrders = const {},
    this.errorMessage,
  });

  TablesState copyWith({
    TablesStatus? status,
    List<RestaurantTable>? tables,
    Map<String, List<Order>>? tableOrders,
    String? errorMessage,
  }) {
    return TablesState(
      status: status ?? this.status,
      tables: tables ?? this.tables,
      tableOrders: tableOrders ?? this.tableOrders,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}