part of 'home_cubit.dart';

/// State of [HomeCubit]
final class HomeState extends Equatable {
  /// Create [HomeState] instance
  const HomeState({
    this.tab = HomeTab.localAsset,
  });

  /// Current active tab
  final HomeTab tab;

  @override
  List<Object?> get props => [tab];
}
