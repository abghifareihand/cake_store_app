part of 'order_status_bloc.dart';

sealed class OrderStatusState {}

final class OrderStatusInitial extends OrderStatusState {}

final class OrderStatusLoading extends OrderStatusState {}

final class OrderStatusLoaded extends OrderStatusState {
  final String status;
  OrderStatusLoaded({required this.status});
}

final class OrderStatusError extends OrderStatusState {
  final String message;
  OrderStatusError({required this.message});
}
