part of 'elevated_button_cubit.dart';

/// State of [ElevatedButtonState]
@immutable
final class ElevatedButtonState extends Equatable {
  /// Create [ElevatedButtonState] instance
  const ElevatedButtonState({
    this.enabled = true,
  });

  /// Enabled or not button click
  final bool enabled;

  @override
  List<Object?> get props => [enabled];
}
