part of 'simple_text_bloc.dart';

/// [SimpleTextBloc] events class
@immutable
final class SimpleTextEvent{
  const SimpleTextEvent();
}

/// Event to notify new text
final class TextChanged extends SimpleTextEvent {
  /// Create [TextChanged] instance
  const TextChanged(this.text, this.cursorPosition);

  /// New text
  final String text;
  final int cursorPosition;
}

/// Event to set initial text
final class InitialText extends SimpleTextEvent {
  /// Create [InitialText] instance
  const InitialText(this.initialText);

  /// New text
  final String initialText;
}

/// Event to request field reset
final class ResetText extends SimpleTextEvent {}

/// Event auto-invoked to validate input data
final class ValidateData extends SimpleTextEvent {}
