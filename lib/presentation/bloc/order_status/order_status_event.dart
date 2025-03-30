part of 'order_status_bloc.dart';

sealed class OrderStatusEvent {}

final class CheckOrderStatus extends OrderStatusEvent {
  final int orderId;
  CheckOrderStatus({required this.orderId});
}
