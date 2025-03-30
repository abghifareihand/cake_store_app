part of 'order_bloc.dart';

sealed class OrderEvent {}

final class CheckoutOrder extends OrderEvent {
  final OrderRequest orderRequest;

  CheckoutOrder({required this.orderRequest});
}
