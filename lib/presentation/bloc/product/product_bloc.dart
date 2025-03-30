import 'package:cake_store_app/data/models/product_model.dart';
import 'package:cake_store_app/data/repositories/product_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;
  ProductBloc(this._productRepository) : super(ProductInitial()) {
    on<GetProduct>((event, emit) async {
      emit(ProductLoading());
      final product = await _productRepository.getProduct();
      product.fold(
        (error) => emit(ProductError(message: error)),
        (success) => emit(ProductLoaded(productResponse: success)),
      );
    });
  }
}
