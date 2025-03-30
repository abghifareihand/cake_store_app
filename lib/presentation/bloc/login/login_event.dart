part of 'login_bloc.dart';

sealed class LoginEvent {}

final class DoLogin extends LoginEvent {
  final LoginRequest loginRequest;

  DoLogin({required this.loginRequest});
}
