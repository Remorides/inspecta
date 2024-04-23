import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'anp_state.dart';

class ANPCubit extends Cubit<ANPState> {
  /// Create [ANPCubit] instance with default [ANPState]
  ANPCubit({bool isDrawerExpanded = false})
      : super(
          ANPState(
            isDrawerExpanded: isDrawerExpanded,
          ),
        );

  void expandDrawer() => emit(
        state.copyWith(
          isDrawerExpanded: true,
          xOffsetDrawer: 300,
        ),
      );

  void collapseDrawer() => emit(
        state.copyWith(
          isDrawerExpanded: false,
          xOffsetDrawer: 0,
        ),
      );
}
