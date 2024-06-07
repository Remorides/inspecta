part of 'simple_page_cubit.dart';

final class OMDKSimplePageState extends Equatable {
  /// Create [OMDKSimplePageState] instance
  const OMDKSimplePageState({
    this.isDrawerExpanded = false,
    this.xOffsetDrawer = 0,
  });

  final bool isDrawerExpanded;
  final double xOffsetDrawer;

  OMDKSimplePageState copyWith({
    bool? isDrawerExpanded,
    double? xOffsetDrawer,
  }) =>
      OMDKSimplePageState(
        isDrawerExpanded: isDrawerExpanded ?? this.isDrawerExpanded,
        xOffsetDrawer: xOffsetDrawer ?? this.xOffsetDrawer,
      );

  @override
  List<Object?> get props => [isDrawerExpanded, xOffsetDrawer];
}
