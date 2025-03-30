part of 'cart_bloc.dart';

sealed class CartState {}

final class CartInitial extends CartState {}

final class CartLoading extends CartState {}

final class CartLoaded extends CartState {
  final CartResponse cartResponse;
  CartLoaded({required this.cartResponse});
}

final class CartError extends CartState {
  final String message;
  CartError({required this.message});
}
