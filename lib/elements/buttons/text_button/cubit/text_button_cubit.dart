import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'text_button_state.dart';

/// Cubit to manage TextButton state
class TextButtonCubit extends Cubit<TextButtonState> {
  /// create [TextButtonCubit] instance with default [TextButtonState]
  TextButtonCubit() : super(const TextButtonState());

  /// Set current tab on home page
  void enable() => emit(const TextButtonState());

  /// Set current tab on home page
  void disable() => emit(const TextButtonState(enabled: false));
}
