import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:omdk_inspecta/common/enums/enums.dart';
import 'package:omdk_opera_api/omdk_opera_api.dart';

part 'final_state_state.dart';

class FinalStateCubit extends Cubit<FinalStateState> {
  /// Create [FinalStateCubit] instance
  FinalStateCubit({
    required List<JResultState> listItem,
    bool isEnabled = true,
    JResultState? selectedItem,
  }) : super(
          FinalStateState(
            listItem: listItem,
            selectedItem: selectedItem,
            isEnabled: isEnabled,
          ),
        );

  /// Enable widget
  void enable() => emit(state.copyWith(isEnabled: true));

  /// Disable widget
  void disable() => emit(state.copyWith(isEnabled: false));

  /// Change selected item
  void changeSelected(JResultState? s) => emit(state.copyWith(selectedItem: s));
}
