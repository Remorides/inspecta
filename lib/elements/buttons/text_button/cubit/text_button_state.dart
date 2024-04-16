part of 'text_button_cubit.dart';

/// State of [TextButtonCubit]
@immutable
final class TextButtonState extends Equatable {
  /// Create [TextButtonState] instance
  const TextButtonState({
    this.enabled = true,
  });

  /// Enabled or not button click
  final bool enabled;

  @override
  List<Object?> get props => [enabled];
}
