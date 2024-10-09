import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:omdk_inspecta/common/common.dart';

part 'pool_list_with_action_state.dart';

class PoolListWithActionCubit extends Cubit<PoolListWithActionState> {
  /// Create [PoolListWithActionCubit] instance
  PoolListWithActionCubit({
    required List<String?> listItem,
    bool isEnabled = true,
    String? selectedItem,
  }) : super(
          PoolListWithActionState(
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
  void changeSelected(String? s) => emit(state.copyWith(selectedItem: s));
}
