part of 'mrb_cubit.dart';

@immutable
final class MrbState extends Equatable {
  const MrbState({
    required this.isEnabled,
    this.selectedRadio,
  });

  final String? selectedRadio;
  final bool isEnabled;

  MrbState copyWith({
    String? selectedRadio,
  }) =>
      MrbState(
        isEnabled: isEnabled,
        selectedRadio: selectedRadio,
      );

  @override
  List<Object?> get props => [selectedRadio];
}
