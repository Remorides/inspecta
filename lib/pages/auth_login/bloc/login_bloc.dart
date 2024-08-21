import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:omdk_inspecta/common/enums/loading_status.dart';
import 'package:omdk_repo/omdk_repo.dart';
import 'package:opera_api_auth/opera_api_auth.dart';

part 'login_event.dart';

part 'login_state.dart';

/// [Bloc] logic in login form widget
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  /// create [LoginBloc] instance
  LoginBloc({
    required AuthRepo authRepo,
  })  : _authRepo = authRepo,
        super(const LoginState()) {
    on<LoginCompanyCodeChanged>(_onCompanyCodeChanged);
    on<LoginUsernameChanged>(_onUsernameChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
    on<EmptyField>(_onEmptyField);
  }

  final AuthRepo _authRepo;

  void _onCompanyCodeChanged(
    LoginCompanyCodeChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(
      state.copyWith(
        status: LoadingStatus.initial,
        companyCode: event.companyCode,
      ),
    );
  }

  void _onUsernameChanged(
    LoginUsernameChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(
      state.copyWith(
        status: LoadingStatus.initial,
        username: event.username,
      ),
    );
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(
      state.copyWith(
        status: LoadingStatus.initial,
        password: event.password,
      ),
    );
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: LoadingStatus.inProgress));

    try {
      await _authRepo.logIn(
        authLogin: AuthLogin(
          companyCode: state.companyCode,
          userName: state.username,
          password: state.password,
        ).toJson(),
      );
      emit(state.copyWith(status: LoadingStatus.done));
    } catch (_) {
      emit(
        state.copyWith(
            status: LoadingStatus.failure,
            errorText: 'Authentication failure, please try again',),
      );
    }
  }

  Future<void> _onEmptyField(
      EmptyField event,
      Emitter<LoginState> emit,
      ) async {
    emit(
      state.copyWith(
        status: LoadingStatus.failure,
        errorText: 'Some field are empty, please check it and retry',),
    );
  }
}
