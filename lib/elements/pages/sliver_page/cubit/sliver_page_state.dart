part of 'sliver_page_cubit.dart';

final class SliverPageState extends Equatable {
  /// Create [SliverPageState] instance
  const SliverPageState({
    this.isDrawerExpanded = false,
    this.xOffsetDrawer = 0,
    this.initialXOffsetDrawer = -300,
  });

  final bool isDrawerExpanded;
  final double xOffsetDrawer;
  final double initialXOffsetDrawer;

  SliverPageState copyWith({
    bool? isDrawerExpanded,
    double? xOffsetDrawer,
  }) =>
      SliverPageState(
        isDrawerExpanded: isDrawerExpanded ?? this.isDrawerExpanded,
        xOffsetDrawer: xOffsetDrawer ?? this.xOffsetDrawer,
      );

  @override
  List<Object?> get props => [isDrawerExpanded, xOffsetDrawer];
}
