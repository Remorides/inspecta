part of 'simple_text_bloc.dart';

/// State of [SimpleTextBloc]
final class SimpleTextState extends Equatable {
  /// Create [SimpleTextState] instance
  const SimpleTextState({
    required this.isNullable,
    required this.isEmptyAllowed,
    this.status = SimpleTextStatus.initial,
    this.text,
    this.errorText = '',
    this.cursorPosition = 0,
  });

  /// Current state status
  final SimpleTextStatus status;

  /// Current text value
  final String? text;

  /// String with reported error
  final String errorText;

  /// if true data validation method skip nullable control
  final bool isNullable;

  /// if true data validation method skip notEmpty control
  final bool isEmptyAllowed;

  final int cursorPosition;

  /// Update current state
  SimpleTextState copyWith({
    SimpleTextStatus? status,
    String? text,
    String? errorText,
    int? cursorPosition,
  }) =>
      SimpleTextState(
        isNullable: isNullable,
        isEmptyAllowed: isEmptyAllowed,
        status: status ?? this.status,
        text: text ?? this.text,
        errorText: errorText ?? this.errorText,
        cursorPosition: cursorPosition ?? this.cursorPosition,
      );

  @override
  List<Object?> get props => [
        status,
        text,
        errorText,
        cursorPosition,
      ];
}
