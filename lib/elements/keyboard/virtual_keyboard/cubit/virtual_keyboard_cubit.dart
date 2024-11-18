import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

part 'virtual_keyboard_state.dart';

class VirtualKeyboardCubit extends Cubit<VirtualKeyboardState> {
  VirtualKeyboardCubit({bool isVisible = false})
      : super(
          VirtualKeyboardState(
            isVisible: isVisible,
          ),
        );

  void showKeyboard() => emit(state.copyWith(isVisible: true));

  void hiddenKeyboard() => emit(state.copyWith(isVisible: false));

  void changeKeyboardType({
    VirtualKeyboardType keyboardType = VirtualKeyboardType.Alphanumeric,
  }) =>
      emit(state.copyWith(keyboardType: keyboardType));

  void toggleShift() =>
      emit(state.copyWith(isShiftEnabled: !state.isShiftEnabled));
}
