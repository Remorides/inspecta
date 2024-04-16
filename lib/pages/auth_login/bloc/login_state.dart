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
    this.errorText = '',
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

  /// User password
  final String errorText;

  /// Update state with input data
  LoginState copyWith({
    LoadingStatus? status,
    String? companyCode,
    String? username,
    String? password,
    String? errorText,
  }) {
    return LoginState(
      status: status ?? this.status,
      companyCode: companyCode ?? this.companyCode,
      username: username ?? this.username,
      password: password ?? this.password,
      errorText: errorText ?? this.errorText,
    );
  }

  @override
  List<Object> get props => [
        status,
        companyCode,
        username,
        password,
        errorText,
      ];
}
