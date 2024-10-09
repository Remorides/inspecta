part of 'mrb_cubit.dart';

@immutable
final class MrbState extends Equatable {
  const MrbState({
    required this.isEnabled,
    this.selectedRadio,
  });

  final int? selectedRadio;
  final bool isEnabled;

  MrbState copyWith({
    int? selectedRadio,
  }) =>
      MrbState(
        isEnabled: isEnabled,
        selectedRadio: selectedRadio,
      );

  @override
  List<Object?> get props => [isEnabled, selectedRadio];
}
