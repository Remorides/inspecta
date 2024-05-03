import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:omdk/common/enums/enums.dart';

part 'pool_list_state.dart';

class PoolListCubit extends Cubit<PoolListState> {
  /// Create [PoolListCubit] instance
  PoolListCubit({
    required List<String> listItem,
    bool isEnabled = true,
    String? selectedItem,
  }) : super(
          PoolListState(
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
