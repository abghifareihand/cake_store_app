part of 'cart_bloc.dart';

sealed class CartEvent {}

final class GetCart extends CartEvent {}

final class AddToCart extends CartEvent {
  final AddToCartRequest addToCartRequest;
  AddToCart({required this.addToCartRequest});
}

final class UpdateCart extends CartEvent {
  final int cartId;
  final UpdateCartRequest updateCartRequest;
  UpdateCart({required this.cartId, required this.updateCartRequest});
}

final class RemoveFromCart extends CartEvent {
  final int cartId;
  RemoveFromCart({required this.cartId});
}

final class ClearCart extends CartEvent {}
