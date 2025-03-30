import 'package:cake_store_app/data/models/message_model.dart';
import 'package:cake_store_app/data/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'logout_event.dart';
part 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final AuthRepository _authRepository;
  LogoutBloc(this._authRepository) : super(LogoutInitial()) {
    on<DoLogout>((event, emit) async {
      emit(LogoutLoading());
      final logout = await _authRepository.logout();
      logout.fold(
        (error) => emit(LogoutError(message: error)),
        (success) => emit(LogoutLoaded(messageResponse: success)),
      );
    });
  }
}
