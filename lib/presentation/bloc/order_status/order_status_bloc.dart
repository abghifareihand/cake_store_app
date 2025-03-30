import 'package:cake_store_app/data/repositories/order_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'order_status_event.dart';
part 'order_status_state.dart';

class OrderStatusBloc extends Bloc<OrderStatusEvent, OrderStatusState> {
  final OrderRepository _orderRepository;
  OrderStatusBloc(this._orderRepository) : super(OrderStatusInitial()) {
    on<CheckOrderStatus>((event, emit) async {
      emit(OrderStatusLoading());
      final orderStatus = await _orderRepository.checkOrderStatus(event.orderId);
      orderStatus.fold(
        (error) => emit(OrderStatusError(message: error)),
        (success) => emit(OrderStatusLoaded(status: success)),
      );
    });
  }
}
