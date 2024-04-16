import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:omdk/pages/home/enums/home_tab.dart';

part 'home_state.dart';

/// Cubit to manage HomeCubit state
class HomeCubit extends Cubit<HomeState> {
  /// create [HomeCubit] instance with default [HomeState]
  HomeCubit() : super(const HomeState());

  /// Set current tab on home page
  void setTab(HomeTab tab) => emit(HomeState(tab: tab));
}