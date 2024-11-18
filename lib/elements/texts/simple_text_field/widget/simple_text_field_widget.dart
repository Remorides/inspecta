import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdk_inspecta/elements/elements.dart';
import 'package:omdk_inspecta/elements/texts/enum/enum.dart';

/// Generic input text field
class SimpleTextField extends StatelessWidget {
  /// Create [SimpleTextField] instance
  const SimpleTextField({
    required this.labelText,
    this.textFocusNode,
    this.actionFocusNode,
    this.onSubmit,
    this.onChanged,
    this.nextFocusNode,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction = TextInputAction.next,
    this.maxLines = 1,
    this.placeholder,
    this.customBoxBorder,
    this.onTap,
    this.onTapAction,
    this.withBorder = false,
    this.withAction = false,
    this.autofocus = false,
    this.isObscurable = false,
    this.actionIcon,
    this.textAlign = TextAlign.start,
    this.fieldNote,
    this.suffixText,
    this.validator,
    super.key,
  });

  /// Result function with input data
  final void Function(String?)? onChanged;

  final void Function(String?)? onSubmit;

  /// Manage on tap event
  final void Function()? onTap;

  /// Label text
  final String labelText;

  /// Focus node of current widget
  final FocusNode? textFocusNode;

  final FocusNode? actionFocusNode;

  /// If exist, pass next focus node to autofocus if on editing complete
  final FocusNode? nextFocusNode;

  /// Set input type of data with [TextInputType] enums
  final TextInputType keyboardType;

  /// If input data is text you can capitalize is
  final TextCapitalization textCapitalization;

  /// Specify special action on complete
  final TextInputAction textInputAction;

  /// Max allowed string lines
  final int maxLines;

  /// If exist, set widget placeholder
  final String? placeholder;

  /// Enable or not autofocus
  final bool autofocus;

  /// Obscure text (like password)
  final bool isObscurable;

  /// Show or not field border
  final bool withBorder;

  /// Show or not action button
  final bool withAction;

  /// Manage on tap event on action button
  final void Function()? onTapAction;

  /// Icon of action button
  final Icon? actionIcon;

  /// Specify custom border to add on the widget
  final BoxBorder? customBoxBorder;

  final TextAlign textAlign;

  final String? fieldNote;

  final String? suffixText;

  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                labelText.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
          ],
        ),
        const Space.vertical(5),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(flex: 12, child: _textField),
              if (withAction) Expanded(flex: 2, child: _action),
            ],
          ),
        ),
        if (fieldNote != null)
          Row(
            children: [
              Expanded(
                child: Text(
                  '$fieldNote',
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget get _action => BlocSelector<SimpleTextCubit, SimpleTextState, bool>(
        selector: (state) => state.isActionEnabled,
        builder: (context, isActionEnabled) => Opacity(
          opacity: (!isActionEnabled) ? 0.7 : 1,
          child: AbsorbPointer(
            absorbing: !isActionEnabled,
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              child: Material(
                elevation: 1,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  focusNode: actionFocusNode,
                  borderRadius: BorderRadius.circular(8),
                  onTap: onTapAction,
                  child: actionIcon,
                ),
              ),
            ),
          ),
        ),
      );

  Widget get _textField => BlocBuilder<SimpleTextCubit, SimpleTextState>(
        builder: (context, state) => TextFormField(
          key: key,
          controller: state.controller,
          onTap: onTap,
          autofocus: autofocus,
          enabled: state.isInputTextEnabled,
          readOnly: !state.isInputTextEnabled,
          focusNode: textFocusNode,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          textInputAction: textInputAction,
          textAlign: textAlign,
          obscureText: isObscurable && !state.obscureText,
          maxLines: maxLines,
          onChanged: (text) {
            context.read<SimpleTextCubit>().changeText(text);
            onChanged?.call(text);
          },
          onFieldSubmitted: onSubmit,
          validator: validator,
          onTapOutside: (e) => FocusScope.of(context).unfocus(),
          decoration: InputDecoration(
            border: withBorder
                ? OutlineInputBorder(borderRadius: BorderRadius.circular(10))
                : null,
            hintText: placeholder,
            hintMaxLines: maxLines,
            errorText: state.errorText?.localizateError(context),
            suffixText: suffixText,
            suffixIcon: isObscurable ? _suffixIcon : null,
            suffixIconColor: Colors.grey,
          ),
        ),
      );

  Widget get _suffixIcon =>
      BlocSelector<SimpleTextCubit, SimpleTextState, bool>(
        selector: (state) => state.obscureText,
        builder: (context, isObscured) => IconButton(
          icon: Icon(
            isObscured ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () => context.read<SimpleTextCubit>().toggleVisibility(),
        ),
      );
}
