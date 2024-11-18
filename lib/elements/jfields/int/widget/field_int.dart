import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdk_inspecta/elements/elements.dart';

class FieldInt extends StatelessWidget {
  /// Create [FieldInt] instance
  const FieldInt({
    required this.labelText,
    super.key,
    this.focusNode,
    this.onSubmit,
    this.onChanged,
    this.initialValue,
    this.cubit,
    this.nextFocusNode,
    this.isEnabled = true,
    this.withBorder = true,
    this.autofocus = false,
    this.onTap,
    this.onBuildedCubit,
    this.placeholder,
    this.textAlign = TextAlign.start,
    this.maxLines = 1,
    this.fieldNote,
    this.suffixText,
    this.validator,
    this.keyboardCubit,
    this.onTapCubit,
  });

  final String labelText;
  final SimpleTextCubit? cubit;
  final bool isEnabled;
  final bool autofocus;
  final bool withBorder;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final void Function(int?)? onChanged;
  final void Function(int?)? onSubmit;
  final void Function()? onTap;
  final void Function(SimpleTextCubit)? onBuildedCubit;
  final int? initialValue;
  final String? placeholder;
  final TextAlign textAlign;
  final int maxLines;
  final String? fieldNote;
  final String? suffixText;
  final String? Function(String?)? validator;

  final VirtualKeyboardCubit? keyboardCubit;
  final void Function(SimpleTextCubit)? onTapCubit;

  @override
  Widget build(BuildContext context) {
    final wCubit = cubit ??
        SimpleTextCubit(
          initialText: initialValue?.toString(),
          isInputTextEnabled: isEnabled,
        );
    return BlocProvider.value(
      value: wCubit,
      child: SimpleTextField(
        keyboardType: TextInputType.number,
        onChanged: (newValue) {
          if (newValue == null) {
            onChanged?.call(null);
            return;
          }
          final parsedValue = int.tryParse(newValue);
          if (parsedValue != null) onChanged?.call(parsedValue);
        },
        onSubmit: (newValue) {
          if (newValue == null){
            onSubmit?.call(null);
            return;
          }
          final parsedValue = int.tryParse(newValue);
          if (parsedValue != null) onSubmit?.call(parsedValue);
        },
        textAlign: textAlign,
        labelText: labelText,
        placeholder: placeholder,
        textFocusNode: focusNode,
        nextFocusNode: nextFocusNode,
        withBorder: withBorder,
        fieldNote: fieldNote,
        onTap: () {
          onTapCubit?.call(wCubit);
          keyboardCubit
            ?..changeKeyboardType()
            ..showKeyboard();
          onTap?.call();
        },
      ),
    );
  }
}
