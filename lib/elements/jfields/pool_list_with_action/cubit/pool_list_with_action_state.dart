part of 'pool_list_with_action_cubit.dart';

@immutable
final class PoolListWithActionState extends Equatable {
  const PoolListWithActionState({
    required this.listItem,
    required this.isEnabled,
    this.selectedItem,
    this.errorText = '',
    this.status = LoadingStatus.initial,
  });

  final LoadingStatus status;
  final List<String?> listItem;
  final String? selectedItem;
  final String errorText;
  final bool isEnabled;

  PoolListWithActionState copyWith({
    LoadingStatus? status,
    List<String>? listItem,
    String? selectedItem,
    String? errorText,
    bool? isEnabled,
  }) =>
      PoolListWithActionState(
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
