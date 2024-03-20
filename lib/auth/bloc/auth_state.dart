part of 'auth_bloc.dart';

/// [AuthState]
@immutable
class AuthState extends Equatable {
  const AuthState._({
    this.status = AuthStatus.unknown,
    this.user = AuthenticatedUser.empty,
  });

  /// Default state on start app
  const AuthState.unknown() : this._();

  /// User authenticated
  const AuthState.authenticated(AuthenticatedUser user)
      : this._(status: AuthStatus.authenticated, user: user);

  /// Session found but request user to login again
  const AuthState.unauthenticated()
      : this._(status: AuthStatus.unauthenticated);

  /// value to show authStatus
  final AuthStatus status;
  /// user authenticated
  final AuthenticatedUser user;

  @override
  List<Object> get props => [status, user];
}
