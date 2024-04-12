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
final class AuthLogoutRequested extends AuthEvent {
  @override
  List<Object?> get props => [];
}
