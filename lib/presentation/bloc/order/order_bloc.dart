import 'package:cake_store_app/data/models/order_model.dart';
import 'package:cake_store_app/data/repositories/order_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository _orderRepository;
  OrderBloc(this._orderRepository) : super(OrderInitial()) {
    on<CheckoutOrder>((event, emit) async {
      emit(OrderLoading());
      final order = await _orderRepository.checkoutOrder(event.orderRequest);
      order.fold(
        (error) => emit(OrderError(message: error)),
        (success) => emit(OrderLoaded(orderResponse: success)),
      );
    });
  }
}
