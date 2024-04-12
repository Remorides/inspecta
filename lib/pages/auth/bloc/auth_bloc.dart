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
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    _authStatusSubscription = _authRepo.status.listen(
          (status) => add(_AuthStatusChanged(status)),
    );
  }

  final AuthRepo _authRepo;
  late StreamSubscription<AuthStatus> _authStatusSubscription;

  @override
  Future<void> close() {
    _authStatusSubscription.cancel();
    return super.close();
  }

  Future<void> _onAuthStatusChanged(
      _AuthStatusChanged event,
      Emitter<AuthState> emit,
      ) async {
    switch (event.status) {
      case AuthStatus.unauthenticated:
        return emit(const AuthState.unauthenticated());
      case AuthStatus.authenticated:
        final user = await _authRepo.user;
        return emit(
          user != null
              ? AuthState.authenticated(user)
              : const AuthState.unauthenticated(),
        );
      case AuthStatus.unknown:
        return emit(const AuthState.unknown());
    }
  }

  void _onAuthLogoutRequested(
      AuthLogoutRequested event,
      Emitter<AuthState> emit,
      ) {
    _authRepo.logOut();
  }
}
