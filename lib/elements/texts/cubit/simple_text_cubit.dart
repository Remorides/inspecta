import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:omdk_inspecta/elements/texts/enum/enum.dart';

part 'simple_text_state.dart';

class SimpleTextCubit extends Cubit<SimpleTextState> {
  /// Create [SimpleTextCubit] instance
  SimpleTextCubit({
    bool isActionEnabled = true,
    bool isInputTextEnabled = true,
    bool obscureText = false,
    String? initialText,
    int cursorPosition = 0,
  }) : super(
          SimpleTextState(
            controller: TextEditingController(text: initialText),
            text: initialText,
            isActionEnabled: isActionEnabled,
            isInputTextEnabled: isInputTextEnabled,
            obscureText: obscureText,
            cursorPosition: cursorPosition,
          ),
        );

  TextEditingController get controller => state.controller;

  void changeText(String? newText) => emit(state.copyWith(text: newText));

  void setText(String? newText) {
    if (newText == null) return;
    state.controller.text = newText;
    emit(state.copyWith(text: newText));
  }

  void setError(FieldTextError error) => emit(
        state.copyWith(errorText: error, text: ''),
      );

  void enableInputText() => emit(state.copyWith(isInputTextEnabled: true));

  void enableAction() => emit(state.copyWith(isActionEnabled: true));

  void disableInputText() => emit(state.copyWith(isInputTextEnabled: false));

  void disableAction() => emit(state.copyWith(isActionEnabled: false));

  void resetText() => state.controller.text = '';

  void toggleVisibility() =>
      emit(state.copyWith(obscureText: !state.obscureText));
}
