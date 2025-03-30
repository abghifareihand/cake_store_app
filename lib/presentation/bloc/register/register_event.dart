part of 'register_bloc.dart';

sealed class RegisterEvent {}

final class DoRegister extends RegisterEvent {
  final RegisterRequest registerRequest;

  DoRegister({required this.registerRequest});
}
