part of 'auth_bloc.dart';

@immutable
class AuthState extends Equatable {
  const AuthState._({
    this.status = AuthStatus.unknown,
    this.user = AuthenticatedUser.empty,
  });

  const AuthState.unknown() : this._();

  const AuthState.authenticated(AuthenticatedUser user)
      : this._(status: AuthStatus.authenticated, user: user);

  const AuthState.unauthenticated()
      : this._(status: AuthStatus.unauthenticated);

  const AuthState.expired()
      : this._(status: AuthStatus.expired);

  final AuthStatus status;
  final AuthenticatedUser user;

  @override
  List<Object> get props => [status, user];
}
