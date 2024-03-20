part of 'login_bloc.dart';

/// Login form bloc
@immutable
final class LoginState extends Equatable {
  /// [LoginState] instance with default data
  const LoginState({
    this.status = LoadingStatus.initial,
    this.companyCode = '',
    this.username = '',
    this.password = '',
  });

  /// Login status enum is used to notify error in authentication
  /// or provide authentication progress status
  final LoadingStatus status;

  /// User company code
  final String companyCode;
  /// User username
  final String username;
  /// User password
  final String password;

  /// Update state with input data
  LoginState copyWith({
    LoadingStatus? status,
    String? companyCode,
    String? username,
    String? password,
  }) {
    return LoginState(
      status: status ?? this.status,
      companyCode: companyCode ?? this.companyCode,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  @override
  List<Object> get props => [status, companyCode, username, password];
}
