part of 'auth_bloc.dart';

/// [AuthState]
@immutable
class AuthState extends Equatable {
  const AuthState._({
    this.status = AuthStatus.unknown,
    this.user = AuthenticatedUser.empty,
    this.companyCode = '',
  });

  /// Default state on start app
  const AuthState.unknown() : this._();

  /// Default state on start app
  const AuthState.otpFails()
      : this._(
          status: AuthStatus.otpFailed,
          user: AuthenticatedUser.empty,
        );

  /// User authenticated
  const AuthState.authenticated(
    AuthenticatedUser user,
  ) : this._(
          status: AuthStatus.authenticated,
          user: user,
        );

  /// Session found but request user to login again
  const AuthState.unauthenticated()
      : this._(status: AuthStatus.unauthenticated);

  /// value to show authStatus
  final AuthStatus status;

  /// user authenticated
  final AuthenticatedUser user;

  /// current company code
  final String companyCode;

  @override
  List<Object> get props => [
        status,
        user,
        companyCode,
      ];
}
