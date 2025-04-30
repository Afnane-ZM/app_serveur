// lib/blocs/tables/tables_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/tables_repository.dart';
import '../../data/models/order.dart';
import '../../data/models/table.dart';
import 'tables_event.dart';
import 'tables_state.dart';

class TablesBloc extends Bloc<TablesEvent, TablesState> {
  final TablesRepository tablesRepository;

  TablesBloc({required this.tablesRepository}) : super(TablesState()) {
    on<LoadTables>(_onLoadTables);
    on<LoadTableOrders>(_onLoadTableOrders);
    on<ToggleTableStatus>(_onToggleTableStatus);
  }

  Future<void> _onLoadTables(
    LoadTables event,
    Emitter<TablesState> emit,
  ) async {
    emit(state.copyWith(status: TablesStatus.loading));
    try {
      final tables = await tablesRepository.getAllTables();
      
      // Initialize tableOrders with empty lists for each table
      final Map<String, List<Order>> tableOrders = {};
      for (var table in tables) {
        tableOrders[table.id] = [];
      }
      
      emit(state.copyWith(
        status: TablesStatus.loaded,
        tables: tables,
        tableOrders: tableOrders,
      ));
      
      // Load orders for each table after loading tables
      for (var table in tables) {
        add(LoadTableOrders(tableId: table.id));
      }
    } catch (e) {
      emit(state.copyWith(
        status: TablesStatus.error,
        errorMessage: 'Impossible de charger les tables: ${e.toString()}',
      ));
    }
  }

  Future<void> _onLoadTableOrders(
    LoadTableOrders event,
    Emitter<TablesState> emit,
  ) async {
    try {
      final orders = await tablesRepository.getTableOrders(event.tableId);
      
      
      final Map<String, List<Order>> updatedTableOrders = Map.from(state.tableOrders);
      updatedTableOrders[event.tableId] = orders;
      
      emit(state.copyWith(
        tableOrders: updatedTableOrders,
      ));
    } catch (e) {
      // We don't change the status to error to avoid affecting the entire UI
      // Just log the error or handle it appropriately
      print('Error loading orders for table ${event.tableId}: ${e.toString()}');
    }
  }

  Future<void> _onToggleTableStatus(
    ToggleTableStatus event,
    Emitter<TablesState> emit,
  ) async {
    try {
      // Find the table to update
      final tableIndex = state.tables.indexWhere((table) => table.id == event.tableId);
      if (tableIndex == -1) return;
      
      final table = state.tables[tableIndex];
      final updatedTable = await tablesRepository.updateTableStatus(
        event.tableId, 
        !table.isOccupied
      );
      
      // Update the list of tables with the updated table
      final updatedTables = List<RestaurantTable>.from(state.tables);
      updatedTables[tableIndex] = updatedTable;
      
      emit(state.copyWith(
        tables: updatedTables,
        status: TablesStatus.updated,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: TablesStatus.error,
        errorMessage: 'Impossible de mettre à jour le statut de la table: ${e.toString()}',
      ));
    }
  }
}