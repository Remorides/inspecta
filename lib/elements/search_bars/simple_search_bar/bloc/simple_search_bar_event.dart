part of 'simple_search_bar_bloc.dart';

@immutable
sealed class SimpleSearchBarEvent {
  const SimpleSearchBarEvent();
}

/// Event to notify new text
final class NewSearch extends SimpleSearchBarEvent {
  /// Create [NewSearch] instance
  const NewSearch(this.searchText);

  /// New text
  final String searchText;
}

/// Event to request field reset
final class CancelSearch extends SimpleSearchBarEvent {}

/// Event to submit query
final class SubmitSearch extends SimpleSearchBarEvent {}
