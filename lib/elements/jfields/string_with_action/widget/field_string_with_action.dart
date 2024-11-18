import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdk_inspecta/elements/elements.dart';

class FieldStringWithAction extends StatelessWidget {
  /// Create [FieldStringWithAction] instance
  const FieldStringWithAction({
    required this.labelText,
    required this.actionIcon,
    super.key,
    this.focusNode,
    this.actionFocusNode,
    this.initialText,
    this.cubit,
    this.nextFocusNode,
    this.isInputTextEnabled = false,
    this.isActionEnabled = true,
    this.withBorder = true,
    this.autofocus = false,
    this.onTap,
    this.onChanged,
    this.onSubmit,
    this.onBuildedCubit,
    this.placeholder,
    this.onTapAction,
    this.fieldNote,
    this.suffixText,
    this.validator,
  });

  final String labelText;
  final SimpleTextCubit? cubit;
  final bool isInputTextEnabled;
  final bool isActionEnabled;
  final bool withBorder;
  final bool autofocus;
  final FocusNode? focusNode;
  final FocusNode? actionFocusNode;
  final FocusNode? nextFocusNode;
  final void Function(String?)? onChanged;
  final void Function(String?)? onSubmit;
  final void Function()? onTap;
  final void Function()? onTapAction;
  final void Function(SimpleTextCubit)? onBuildedCubit;
  final String? initialText;
  final String? placeholder;
  final Icon actionIcon;
  final String? fieldNote;
  final String? suffixText;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final wCubit = cubit ??
        SimpleTextCubit(
          initialText: initialText,
          isInputTextEnabled: isInputTextEnabled,
          isActionEnabled: isActionEnabled,
        );
    onBuildedCubit?.call(wCubit);
    return BlocProvider.value(
      value: wCubit,
      child: SimpleTextField(
        key: key,
        actionIcon: actionIcon,
        autofocus: autofocus,
        labelText: labelText,
        placeholder: placeholder,
        actionFocusNode: actionFocusNode,
        textFocusNode: focusNode,
        nextFocusNode: nextFocusNode,
        withBorder: withBorder,
        withAction: true,
        onTap: onTap,
        onTapAction: onTapAction,
        onSubmit: onSubmit,
        onChanged: onChanged,
        fieldNote: fieldNote,
        suffixText: suffixText,
        validator: validator,
      ),
    );
  }
}
