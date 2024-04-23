part of 'anp_cubit.dart';

final class ANPState extends Equatable {
  const ANPState({
    this.isDrawerExpanded = false,
    this.xOffsetDrawer = 0,
  });

  final bool isDrawerExpanded;
  final double xOffsetDrawer;

  ANPState copyWith({
    bool? isDrawerExpanded,
    double? xOffsetDrawer,
  }) =>
      ANPState(
        isDrawerExpanded: isDrawerExpanded ?? this.isDrawerExpanded,
        xOffsetDrawer: xOffsetDrawer ?? this.xOffsetDrawer,
      );

  @override
  List<Object?> get props => [isDrawerExpanded, xOffsetDrawer];
}
