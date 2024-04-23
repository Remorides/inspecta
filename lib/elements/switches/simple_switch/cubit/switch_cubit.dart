import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'switch_state.dart';

class SwitchCubit extends Cubit<SwitchState> {
  /// Create [SwitchCubit] instance
  SwitchCubit({
    bool isActive = false,
    bool isEnabled = true,
  }) : super(
          SwitchState(
            isActive: isActive,
            isEnabled: isEnabled,
          ),
        );

  void toggle(bool value) => emit(
    state.copyWith(
      isActive: value,
    ),
  );
}
