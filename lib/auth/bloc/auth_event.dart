part of 'auth_bloc.dart';

///[AuthEvent] class
sealed class AuthEvent {
  const AuthEvent();
}

/// Authentication is changed
final class _AuthStatusChanged extends AuthEvent {
  const _AuthStatusChanged(this.status);

  final AuthStatus status;
}

/// User request to logout
final class AuthLogoutRequested extends AuthEvent {}