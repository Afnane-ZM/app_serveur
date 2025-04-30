// lib/data/repositories/home_repository.dart
import '../models/order.dart';
import '../models/assistance_request.dart';
import 'order_repository.dart';

class HomeRepository {
  final OrderRepository orderRepository;
  
  HomeRepository({required this.orderRepository});
  
  Future<List<Order>> getPreparingOrders() async {
    final newOrders = await orderRepository.getNewOrders();
    return newOrders.where((order) => order.status == 'preparing').toList();
  }
  
  Future<List<Order>> getReadyOrders() async {
    return orderRepository.getReadyOrders();
  }
  
  
  
  Future<List<AssistanceRequest>> getAssistanceRequests() async {
    return orderRepository.getAssistanceRequests();
  }
  
  Future<void> completeAssistanceRequest(String requestId) async {
    return orderRepository.completeAssistanceRequest(requestId);
  }
}