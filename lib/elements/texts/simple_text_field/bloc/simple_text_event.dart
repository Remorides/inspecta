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

final class EnableInputText extends SimpleTextEvent {
  const EnableInputText();
}

final class EnableAction extends SimpleTextEvent {
  const EnableAction(this.isEnabled);
  /// New text
  final bool isEnabled;
}

/// Event to request field reset
final class ResetText extends SimpleTextEvent {}

/// Event auto-invoked to validate input data
final class ValidateData extends SimpleTextEvent {}
