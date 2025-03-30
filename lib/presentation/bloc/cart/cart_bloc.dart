import 'package:cake_store_app/data/models/cart_model.dart';
import 'package:cake_store_app/data/repositories/cart_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _cartRepository;
  CartBloc(this._cartRepository) : super(CartInitial()) {
    on<GetCart>((event, emit) async {
      final cart = await _cartRepository.getCart();
      cart.fold(
        (error) => emit(CartError(message: error)),
        (success) => emit(CartLoaded(cartResponse: success)),
      );
    });

    on<AddToCart>((event, emit) async {
      final response = await _cartRepository.addToCart(event.addToCartRequest);
      response.fold((error) => emit(CartError(message: error)), (success) => add(GetCart()));
    });

    on<UpdateCart>((event, emit) async {
      final response = await _cartRepository.updateCart(event.cartId, event.updateCartRequest);
      response.fold((error) => emit(CartError(message: error)), (success) => add(GetCart()));
    });

    on<RemoveFromCart>((event, emit) async {
      final response = await _cartRepository.removeCart(event.cartId);
      response.fold((error) => emit(CartError(message: error)), (success) => add(GetCart()));
    });
  }
}
