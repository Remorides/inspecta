import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'sliver_page_state.dart';

class OMDKSliverPageCubit extends Cubit<SliverPageState> {
  /// Create [OMDKSliverPageCubit] instance
  OMDKSliverPageCubit({bool isDrawerExpanded = false})
      : super(SliverPageState(isDrawerExpanded: isDrawerExpanded));

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
