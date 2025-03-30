import 'package:cake_store_app/data/models/login_model.dart';
import 'package:cake_store_app/data/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository;
  LoginBloc(this._authRepository) : super(LoginInitial()) {
    on<DoLogin>((event, emit) async {
      emit(LoginLoading());
      final login = await _authRepository.login(event.loginRequest);
      login.fold(
        (error) => emit(LoginError(message: error)),
        (success) => emit(LoginLoaded(loginResponse: success)),
      );
    });
  }
}
