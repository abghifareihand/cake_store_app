part of 'product_bloc.dart';

sealed class ProductState {}

final class ProductInitial extends ProductState {}

final class ProductLoading extends ProductState {}

final class ProductLoaded extends ProductState {
  final ProductResponse productResponse;
  ProductLoaded({required this.productResponse});
}

final class ProductError extends ProductState {
  final String message;
  ProductError({required this.message});
}
