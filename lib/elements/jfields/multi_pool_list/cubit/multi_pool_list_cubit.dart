import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:omdk/common/enums/enums.dart';

part 'multi_pool_list_state.dart';

class MultiPoolListCubit extends Cubit<MultiPoolListState> {
  /// Create [PoolListCubit] instance
  MultiPoolListCubit({
    required List<String> listItem,
    bool isEnabled = true,
    List<String> selectedItems = const [],
  }) : super(
    MultiPoolListState(
      listItem: listItem,
      selectedItems: selectedItems,
      isEnabled: isEnabled,
    ),
  );

  /// Set current tab on home page
  void enable() => emit(state.copyWith(isEnabled: true));

  /// Set current tab on home page
  void disable() => emit(state.copyWith(isEnabled: false));
}
