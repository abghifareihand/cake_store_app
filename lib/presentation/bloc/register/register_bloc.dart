import 'package:cake_store_app/data/models/register_model.dart';
import 'package:cake_store_app/data/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository _authRepository;
  RegisterBloc(this._authRepository) : super(RegisterInitial()) {
    on<DoRegister>((event, emit) async {
      emit(RegisterLoading());
      final register = await _authRepository.register(event.registerRequest);
      register.fold(
        (error) => emit(RegisterError(message: error)),
        (success) => emit(RegisterLoaded(registerResponse: success)),
      );
    });
  }
}
