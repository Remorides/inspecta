part of 'final_state_cubit.dart';

@immutable
final class FinalStateState extends Equatable {
  const FinalStateState({
    required this.listItem,
    required this.isEnabled,
    this.selectedItem,
    this.errorText = '',
    this.status = LoadingStatus.initial,
  });

  final LoadingStatus status;
  final List<JResultState> listItem;
  final JResultState? selectedItem;
  final String errorText;
  final bool isEnabled;

  FinalStateState copyWith({
    LoadingStatus? status,
    List<JResultState>? listItem,
    JResultState? selectedItem,
    String? errorText,
    bool? isEnabled,
  }) =>
      FinalStateState(
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
