part of 'login_bloc.dart';

sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginLoaded extends LoginState {
  final LoginResponse loginResponse;
  LoginLoaded({required this.loginResponse});
}

final class LoginError extends LoginState {
  final String message;
  LoginError({required this.message});
}
