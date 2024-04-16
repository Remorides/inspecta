part of 'clickable_text_cubit.dart';

/// State of [ClickableTextCubit]
@immutable
final class ClickableTextState extends Equatable {
  /// Create [ClickableTextState] instance
  const ClickableTextState({
    this.enabled = true,
  });

  /// Enabled or not button click
  final bool enabled;

  @override
  List<Object?> get props => [enabled];
}
