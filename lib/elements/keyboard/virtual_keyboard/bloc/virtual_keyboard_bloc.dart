import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

part 'virtual_keyboard_event.dart';

part 'virtual_keyboard_state.dart';

class VirtualKeyboardBloc
    extends Bloc<VirtualKeyboardEvent, VirtualKeyboardState> {
  VirtualKeyboardBloc({bool isVisible = false})
      : super(
          VirtualKeyboardState(
            isVisible: isVisible,
          ),
        ) {
    on<ChangeVisibility>(_onVisibilityChange);
    on<ChangeType>(_onKeyboardTypeChange);
    on<ChangeShift>(_onKeyboardShiftChange);
  }

  void _onVisibilityChange(
    ChangeVisibility event,
    Emitter<VirtualKeyboardState> emit,
  ) {
    emit(
      state.copyWith(isVisible: event.isVisibile),
    );
  }

  void _onKeyboardTypeChange(
    ChangeType event,
    Emitter<VirtualKeyboardState> emit,
  ) {
    emit(state.copyWith(keyboardType: event.keyboardType));
  }

  void _onKeyboardShiftChange(
    ChangeShift event,
    Emitter<VirtualKeyboardState> emit,
  ) {
    emit(state.copyWith(isShiftEnabled: !state.isShiftEnabled));
  }
}
