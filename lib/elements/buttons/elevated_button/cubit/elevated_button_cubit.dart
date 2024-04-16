import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'elevated_button_state.dart';

/// Cubit to manage TextButton state
class ElevatedButtonCubit extends Cubit<ElevatedButtonState> {
  /// create [ElevatedButtonCubit] instance with default [ElevatedButtonState]
  ElevatedButtonCubit({bool enabled = true})
      : super(ElevatedButtonState(enabled: enabled));

  /// Set current tab on home page
  void enable() => emit(const ElevatedButtonState());

  /// Set current tab on home page
  void disable() => emit(const ElevatedButtonState(enabled: false));
}
