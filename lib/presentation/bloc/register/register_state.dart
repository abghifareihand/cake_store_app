part of 'register_bloc.dart';

sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}

final class RegisterLoading extends RegisterState {}

final class RegisterLoaded extends RegisterState {
  final RegisterResponse registerResponse;
  RegisterLoaded({required this.registerResponse});
}

final class RegisterError extends RegisterState {
  final String message;
  RegisterError({required this.message});
}
