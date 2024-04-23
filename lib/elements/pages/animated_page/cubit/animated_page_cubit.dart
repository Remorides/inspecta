import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'animated_page_state.dart';

class OMDKAnimatedPageCubit extends Cubit<OMDKAnimatedPageState> {
  /// Create [OMDKAnimatedPageCubit] instance
  OMDKAnimatedPageCubit({bool isDrawerExpanded = false})
      : super(OMDKAnimatedPageState(isDrawerExpanded: isDrawerExpanded));

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
