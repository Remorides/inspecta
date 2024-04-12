part of 'home_cubit.dart';

final class HomeState extends Equatable {
  const HomeState({this.tab = HomeTab.localAsset});

  final HomeTab tab;

  @override
  List<Object?> get props => [tab];
}
