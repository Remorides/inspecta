part of 'login_bloc.dart';

@immutable
/// [LoginEvent] class provide all available event on LoginForm widget
sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

/// Event used to notify changes in companyCode field
final class LoginCompanyCodeChanged extends LoginEvent {
  /// [LoginCompanyCodeChanged] instance
  const LoginCompanyCodeChanged(this.companyCode);
  /// User input companyCode
  final String companyCode;

  @override
  List<Object> get props => [companyCode];
}

/// Event used to notify changes in username field
final class LoginUsernameChanged extends LoginEvent {
  /// [LoginUsernameChanged] instance
  const LoginUsernameChanged(this.username);
  /// User input username
  final String username;

  @override
  List<Object> get props => [username];
}

/// Event used to notify changes in password field
final class LoginPasswordChanged extends LoginEvent {
  /// [LoginPasswordChanged] instance
  const LoginPasswordChanged(this.password);
  /// User input password
  final String password;

  @override
  List<Object> get props => [password];
}

/// Event to submit input data and await for result
final class LoginSubmitted extends LoginEvent {
  /// [LoginSubmitted] instance
  const LoginSubmitted();
}

/// Event to submit input data and await for result
final class EmptyField extends LoginEvent {
  /// [EmptyField] instance
  const EmptyField();
}
