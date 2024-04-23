part of 'simple_search_bar_bloc.dart';

@immutable
final class SimpleSearchBarState extends Equatable {
  /// Create [SimpleSearchBarState] instance
  const SimpleSearchBarState({
    this.searchText = '',
    this.isEnabled = true,
  });

  final String searchText;
  final bool isEnabled;

  SimpleSearchBarState copyWith({
    String? searchText,
    bool? isEnabled,
  }) =>
      SimpleSearchBarState(
        searchText: searchText ?? this.searchText,
        isEnabled: isEnabled ?? this.isEnabled,
      );

  @override
  List<Object?> get props => [searchText, isEnabled];
}
