import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdk_inspecta/elements/elements.dart';

class FieldString extends StatelessWidget {
  /// Create [FieldString] instance
  const FieldString({
    required this.labelText,
    super.key,
    this.focusNode,
    this.onSubmit,
    this.onChanged,
    this.initialText,
    this.cubit,
    this.nextFocusNode,
    this.isEnabled = true,
    this.withBorder = true,
    this.autofocus = false,
    this.isObscurable = false,
    this.onTap,
    this.onBuildedCubit,
    this.placeholder,
    this.maxLines = 1,
    this.fieldNote,
    this.suffixText,
    this.textCapitalization = TextCapitalization.none,
    this.validator,
    this.keyboardCubit,
    this.onTapCubit,
  });

  final String labelText;
  final SimpleTextCubit? cubit;
  final bool isEnabled;
  final bool autofocus;
  final bool isObscurable;
  final bool withBorder;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final void Function(String?)? onChanged;
  final void Function(String?)? onSubmit;
  final void Function()? onTap;
  final void Function(SimpleTextCubit)? onBuildedCubit;
  final String? initialText;
  final String? placeholder;
  final int maxLines;
  final String? fieldNote;
  final String? suffixText;
  final TextCapitalization textCapitalization;
  final String? Function(String?)? validator;

  final VirtualKeyboardCubit? keyboardCubit;
  final void Function(SimpleTextCubit)? onTapCubit;

  @override
  Widget build(BuildContext context) {
    final wCubit = cubit ??
        SimpleTextCubit(
          initialText: initialText,
          isInputTextEnabled: isEnabled,
        );
    onBuildedCubit?.call(wCubit);
    return BlocProvider.value(
      value: wCubit,
      child: SimpleTextField(
        key: key,
        autofocus: autofocus,
        isObscurable: isObscurable,
        labelText: labelText,
        placeholder: placeholder,
        textFocusNode: focusNode,
        nextFocusNode: nextFocusNode,
        withBorder: withBorder,
        onTap: () {
          onTapCubit?.call(wCubit);
          if (keyboardCubit != null) {
            keyboardCubit
              ?..changeKeyboardType()
              ..showKeyboard();
          }
          onTap?.call();
        },
        onSubmit: onSubmit,
        onChanged: onChanged,
        maxLines: maxLines,
        fieldNote: fieldNote,
        suffixText: suffixText,
        validator: validator,
      ),
    );
  }

// onFocusChange: (focus) {
// if (focus) {
// if (!widget.keyboardCubit!.state.isVisible) {
// widget.keyboardCubit?.add(ChangeType());
// } else {
// widget.keyboardCubit
// ?..add(ChangeType())
// ..add(ChangeVisibility(isVisibile: true));
// }
// }
// },
// onTap: () {
// widget.onTapBloc?.call(widgetBloc);
// if (widget.keyboardCubit != null) {
// widget.keyboardCubit
// ?..add(ChangeType())
// ..add(ChangeVisibility(isVisibile: true));
// }
// },
// onCursorPosition: (position) {
// widgetBloc.add(
// TextChanged(
// widgetBloc.state.text ?? '',
// position,
// ),
// );
// widget.onCursorPosition?.call(position);
// },
}
