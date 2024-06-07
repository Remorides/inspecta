import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'simple_page_state.dart';

class OMDKSimplePageCubit extends Cubit<OMDKSimplePageState> {
  /// Create [OMDKAnimatedPageCubit] instance
  OMDKSimplePageCubit({bool isDrawerExpanded = false})
      : super(OMDKSimplePageState(isDrawerExpanded: isDrawerExpanded));

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
