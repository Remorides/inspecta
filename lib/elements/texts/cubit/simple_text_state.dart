part of 'simple_text_cubit.dart';

final class SimpleTextState extends Equatable {
  /// Create [SimpleTextState] instance
  const SimpleTextState({
    required this.controller,
    this.isActionEnabled = true,
    this.isInputTextEnabled = true,
    this.obscureText = false,
    this.text,
    this.errorText,
    this.cursorPosition = 0,
  });

  final TextEditingController controller;
  final String? text;
  final FieldTextError? errorText;
  final bool isInputTextEnabled;
  final bool isActionEnabled;
  final bool obscureText;
  final int cursorPosition;

  SimpleTextState copyWith({
    TextEditingController? controller,
    String? text,
    FieldTextError? errorText,
    bool? isInputTextEnabled,
    bool? isActionEnabled,
    bool? obscureText,
    int? cursorPosition,
  }) {
    return SimpleTextState(
      controller: controller ?? this.controller,
      text: text ?? this.text,
      errorText: errorText ?? this.errorText,
      isInputTextEnabled: isInputTextEnabled ?? this.isInputTextEnabled,
      isActionEnabled: isActionEnabled ?? this.isActionEnabled,
      obscureText: obscureText ?? this.obscureText,
      cursorPosition: cursorPosition ?? this.cursorPosition,
    );
  }

  @override
  List<Object?> get props => [
        controller,
        text,
        errorText,
        isInputTextEnabled,
        isActionEnabled,
        obscureText,
        cursorPosition,
      ];
}
