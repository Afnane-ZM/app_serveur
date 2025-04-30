// lib/blocs/tables/tables_event.dart
abstract class TablesEvent {}

class LoadTables extends TablesEvent {}

class LoadTableOrders extends TablesEvent {
  final String tableId;
  LoadTableOrders({required this.tableId});
}

class ToggleTableStatus extends TablesEvent {
  final String tableId;
  ToggleTableStatus({required this.tableId});
}