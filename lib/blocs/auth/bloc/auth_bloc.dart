import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:omdk_repo/omdk_repo.dart';
import 'package:opera_api_auth/opera_api_auth.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// Authentication bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  /// create [AuthBloc] instance
  AuthBloc({
    required AuthRepo authRepo,
  }): _authRepo = authRepo, super(const AuthState.unknown()) {
    on<_AuthStatusChanged>(_onAuthStatusChanged);
    on<LogoutRequested>(_onAuthLogoutRequested);
    on<RestoreSession>(_onRestoreSession);
    on<ValidateOTP>(_onOTPValidate);
    _authStatusSubscription = _authRepo.status.listen(
            (status) => add(_AuthStatusChanged(status)),
    );
  }

  final AuthRepo _authRepo;
  late StreamSubscription<AuthStatus> _authStatusSubscription;

  @override
  Future<void> close() {
    _authStatusSubscription.cancel();
    _authRepo.localData.sessionManager.deleteSession();
    return super.close();
  }

  Future<void> _onRestoreSession(
      RestoreSession event,
      Emitter<AuthState> emit,
      ) async {
    await _authRepo.restoreLastSession();
  }

  Future<void> _onAuthStatusChanged(
      _AuthStatusChanged event,
      Emitter<AuthState> emit,
      ) async {
    switch (event.status) {
      case AuthStatus.unauthenticated:
        return emit(const AuthState.unauthenticated());
      case AuthStatus.authenticated:
        final user = _authRepo.user;
        return emit(
          user != null
              ? AuthState.authenticated(user)
              : const AuthState.unauthenticated(),
        );
      case AuthStatus.unknown:
        return emit(const AuthState.unknown());
      case AuthStatus.otpFailed:
        return emit(const AuthState.otpFails());
    }
  }

  Future<void> _onOTPValidate(
      ValidateOTP event,
      Emitter<AuthState> emit,
      ) async {
    await _authRepo.validateOTP(
      authOTP: AuthOTP(otp: event.otp),
    );
  }

  void _onAuthLogoutRequested(
      LogoutRequested event,
      Emitter<AuthState> emit,
      ) {
    _authRepo.logOut();
  }
}
