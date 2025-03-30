part of 'order_history_bloc.dart';

sealed class OrderHistoryState {}

final class OrderHistoryInitial extends OrderHistoryState {}

final class OrderHistoryLoading extends OrderHistoryState {}

final class OrderHistoryLoaded extends OrderHistoryState {
  final OrderHistoryResponse orderHistoryResponse;

  OrderHistoryLoaded({required this.orderHistoryResponse});
}

final class OrderHistoryError extends OrderHistoryState {
  final String message;

  OrderHistoryError({required this.message});
}
