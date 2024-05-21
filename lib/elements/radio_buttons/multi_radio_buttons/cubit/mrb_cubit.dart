import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'mrb_state.dart';

class MrbCubit extends Cubit<MrbState> {
  /// Create [MrbCubit] instance
  MrbCubit({bool isEnabled = true, int? selected})
      : super(
          MrbState(
            isEnabled: isEnabled,
            selectedRadio: selected,
          ),
        );

  /// Set current tab on home page
  void switchRadio(int selectedRadio) =>
      emit(state.copyWith(selectedRadio: selectedRadio));
}
