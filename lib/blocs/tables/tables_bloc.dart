// lib/blocs/tables/tables_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import '../../data/repositories/tables_repository.dart';
import '../../data/models/order.dart';
import '../../data/models/table.dart';
import 'tables_event.dart';
import 'tables_state.dart';

class TablesBloc extends Bloc<TablesEvent, TablesState> {
  final TablesRepository tablesRepository;
  final _logger = Logger('TablesBloc');

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

      final Map<String, List<Order>> tableOrders = {};
      for (var table in tables) {
        tableOrders[table.id] = [];
      }
      
      emit(state.copyWith(
        status: TablesStatus.loaded,
        tables: tables,
        tableOrders: tableOrders,
      ));

      for (var table in tables) {
        add(LoadTableOrders(tableId: table.id));
      }
    } catch (e) {
      _logger.severe('Failed to load tables', e);
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

      _logger.warning('Error loading orders for table ${event.tableId}', e);
    }
  }

  Future<void> _onToggleTableStatus(
    ToggleTableStatus event,
    Emitter<TablesState> emit,
  ) async {
    try {

      final tableIndex = state.tables.indexWhere((table) => table.id == event.tableId);
      if (tableIndex == -1) {
        _logger.info('Attempted to toggle non-existent table: ${event.tableId}');
        return;
      }
      
      final table = state.tables[tableIndex];
      final updatedTable = await tablesRepository.updateTableStatus(
        event.tableId, 
        !table.isOccupied
      );
      

      final updatedTables = List<RestaurantTable>.from(state.tables);
      updatedTables[tableIndex] = updatedTable;
      
      emit(state.copyWith(
        tables: updatedTables,
        status: TablesStatus.updated,
      ));
    } catch (e) {
      _logger.severe('Failed to update table status for ${event.tableId}', e);
      emit(state.copyWith(
        status: TablesStatus.error,
        errorMessage: 'Impossible de mettre à jour le statut de la table: ${e.toString()}',
      ));
    }
  }
}