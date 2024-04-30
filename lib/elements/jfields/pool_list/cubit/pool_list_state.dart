part of 'pool_list_cubit.dart';

@immutable
final class PoolListState extends Equatable {
  const PoolListState({
    required this.listItem,
    required this.isEnabled,
    this.selectedItem,
    this.errorText = '',
    this.status = LoadingStatus.initial,
  });

  final LoadingStatus status;
  final List<String> listItem;
  final String? selectedItem;
  final String errorText;
  final bool isEnabled;

  PoolListState copyWith({
    LoadingStatus? status,
    List<String>? listItem,
    String? selectedItem,
    String? errorText,
    bool? isEnabled,
  }) =>
      PoolListState(
        status: status ?? this.status,
        listItem: listItem ?? this.listItem,
        selectedItem: selectedItem ?? this.selectedItem,
        errorText: errorText ?? this.errorText,
        isEnabled: isEnabled ?? this.isEnabled,
      );

  @override
  List<Object?> get props => [
        status,
        listItem,
        selectedItem,
        isEnabled,
        errorText,
      ];
}
