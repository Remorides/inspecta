import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'clickable_text_state.dart';

/// Cubit to manage TextButton state
class ClickableTextCubit extends Cubit<ClickableTextState> {
  /// create [ClickableTextCubit] instance with default [ClickableTextState]
  ClickableTextCubit({bool enabled = true})
      : super(ClickableTextState(enabled: enabled));

  /// Set current tab on home page
  void enable() => emit(const ClickableTextState());

  /// Set current tab on home page
  void disable() => emit(const ClickableTextState(enabled: false));
}
