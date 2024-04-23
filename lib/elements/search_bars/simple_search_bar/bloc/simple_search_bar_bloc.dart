import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'simple_search_bar_event.dart';

part 'simple_search_bar_state.dart';

class SimpleSearchBarBloc
    extends Bloc<SimpleSearchBarEvent, SimpleSearchBarState> {
  /// Create [SimpleSearchBarBloc] instance
  SimpleSearchBarBloc() : super(const SimpleSearchBarState()) {
    on<NewSearch>(_onNewSearch);
  }

  Future<void> _onNewSearch(
    NewSearch event,
    Emitter<SimpleSearchBarState> emit,
  ) async {
    emit(state.copyWith(searchText: event.searchText));
  }
}
