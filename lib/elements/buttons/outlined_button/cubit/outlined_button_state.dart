part of 'outlined_button_cubit.dart';

/// State of [OutlinedButtonState]
@immutable
final class OutlinedButtonState extends Equatable {
  /// Create [OutlinedButtonState] instance
  const OutlinedButtonState({
    this.enabled = true,
  });

  /// Enabled or not button click
  final bool enabled;

  @override
  List<Object?> get props => [enabled];
}
