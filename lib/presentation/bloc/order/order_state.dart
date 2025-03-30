part of 'order_bloc.dart';

sealed class OrderState {}

final class OrderInitial extends OrderState {}

final class OrderLoading extends OrderState {}

final class OrderLoaded extends OrderState {
  final OrderResponse orderResponse;

  OrderLoaded({required this.orderResponse});
}

final class OrderError extends OrderState {
  final String message;

  OrderError({required this.message});
}
