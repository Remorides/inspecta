import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'mrb_state.dart';

class MrbCubit extends Cubit<MrbState> {
  MrbCubit({bool isEnabled = true})
      : super(MrbState(isEnabled: isEnabled));

  /// Set current tab on home page
  void switchRadio(String selectedRadio) =>
      emit(state.copyWith(selectedRadio: selectedRadio));
}
