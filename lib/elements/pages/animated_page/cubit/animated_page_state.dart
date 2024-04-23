part of 'animated_page_cubit.dart';

final class OMDKAnimatedPageState extends Equatable {
  /// Create [OMDKAnimatedPageState] instance
  const OMDKAnimatedPageState({
    this.isDrawerExpanded = false,
    this.xOffsetDrawer = 0,
  });

  final bool isDrawerExpanded;
  final double xOffsetDrawer;

  OMDKAnimatedPageState copyWith({
    bool? isDrawerExpanded,
    double? xOffsetDrawer,
  }) =>
      OMDKAnimatedPageState(
        isDrawerExpanded: isDrawerExpanded ?? this.isDrawerExpanded,
        xOffsetDrawer: xOffsetDrawer ?? this.xOffsetDrawer,
      );

  @override
  List<Object?> get props => [isDrawerExpanded, xOffsetDrawer];
}
