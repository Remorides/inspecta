part of 'switch_cubit.dart';

@immutable
final class SwitchState extends Equatable {
  const SwitchState({
    required this.isActive,
    required this.isEnabled,
  });

  final bool isActive;
  final bool isEnabled;

  SwitchState copyWith({
    bool? isActive,
    bool? isEnabled,
  }) =>
      SwitchState(
        isActive: isActive ?? this.isActive,
        isEnabled: isEnabled ?? this.isEnabled,
      );

  @override
  List<Object?> get props => [isActive, isEnabled];
}
