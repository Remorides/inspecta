import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:omdk_inspecta/blocs/mode/mode.dart';

class SessionModeCubit extends HydratedCubit<SessionMode> {
  SessionModeCubit() : super(SessionMode.online);

  void changeMode(SessionMode mode) => emit(mode);

  void switchMode() => emit(
        state == SessionMode.online ? SessionMode.offline : SessionMode.online,
      );

  @override
  SessionMode? fromJson(Map<String, dynamic> json) =>
      SessionMode.values.byName(json['value'] as String);

  @override
  Map<String, dynamic>? toJson(SessionMode state) => {'value': state.name};
}
