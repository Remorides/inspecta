import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'outlined_button_state.dart';

/// Cubit to manage TextButton state
class OutlinedButtonCubit extends Cubit<OutlinedButtonState> {
  /// create [OutlinedButtonCubit] instance
  /// with default [OutlinedButtonState]
  OutlinedButtonCubit({bool enabled = true})
      : super(OutlinedButtonState(enabled: enabled));

  /// Set current tab on home page
  void enable() => emit(const OutlinedButtonState());

  /// Set current tab on home page
  void disable() => emit(const OutlinedButtonState(enabled: false));
}
