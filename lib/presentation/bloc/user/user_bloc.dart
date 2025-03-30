import 'package:cake_store_app/data/models/user_model.dart';
import 'package:cake_store_app/data/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final AuthRepository _authRepository;
  UserBloc(this._authRepository) : super(UserInitial()) {
    on<UserEvent>((event, emit) async {
      emit(UserLoading());
      final login = await _authRepository.getUser();
      login.fold(
        (error) => emit(UserError(message: error)),
        (success) => emit(UserLoaded(userResponse: success)),
      );
    });
  }
}
