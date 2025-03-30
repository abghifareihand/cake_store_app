import 'package:cake_store_app/data/models/order_model.dart';
import 'package:cake_store_app/data/repositories/order_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'order_history_event.dart';
part 'order_history_state.dart';

class OrderHistoryBloc extends Bloc<OrderHistoryEvent, OrderHistoryState> {
  final OrderRepository _orderRepository;
  OrderHistoryBloc(this._orderRepository) : super(OrderHistoryInitial()) {
    on<GetOrderHistory>((event, emit) async {
      emit(OrderHistoryLoading());
      final orderHistory = await _orderRepository.getOrderHistory();
      orderHistory.fold(
        (error) => emit(OrderHistoryError(message: error)),
        (success) => emit(OrderHistoryLoaded(orderHistoryResponse: success)),
      );
    });
  }
}
