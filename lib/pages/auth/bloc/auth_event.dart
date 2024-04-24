part of 'auth_bloc.dart';

///[AuthEvent] class
sealed class AuthEvent extends Equatable {
  const AuthEvent();
}

/// Authentication is changed
final class _AuthStatusChanged extends AuthEvent {
  const _AuthStatusChanged(this.status);

  final AuthStatus status;

  @override
  List<Object?> get props => [];
}

/// User request to logout
final class LogoutRequested extends AuthEvent {
  @override
  List<Object?> get props => [];
}

/// Register to auth stream event
final class RestoreSession extends AuthEvent {
  @override
  List<Object?> get props => [];
}

/// Request to validate input
final class ValidateOTP extends AuthEvent {

  const ValidateOTP({required this.otp});

  final String otp;

  @override
  List<Object?> get props => [otp];
}
