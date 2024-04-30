part of 'multi_pool_list_cubit.dart';

@immutable
final class MultiPoolListState extends Equatable {
  const MultiPoolListState({
    required this.listItem,
    required this.isEnabled,
    required this.selectedItems,
    this.errorText = '',
    this.status = LoadingStatus.initial,
  });

  final LoadingStatus status;
  final List<String> listItem;
  final List<String> selectedItems;
  final String errorText;
  final bool isEnabled;

  MultiPoolListState copyWith({
    LoadingStatus? status,
    List<String>? listItem,
    List<String>? selectedItems,
    String? errorText,
    bool? isEnabled,
  }) =>
      MultiPoolListState(
        status: status ?? this.status,
        listItem: listItem ?? this.listItem,
        selectedItems: selectedItems ?? this.selectedItems,
        errorText: errorText ?? this.errorText,
        isEnabled: isEnabled ?? this.isEnabled,
      );

  @override
  List<Object?> get props => [
        status,
        listItem,
        selectedItems,
        isEnabled,
        errorText,
      ];
}
