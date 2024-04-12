import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdk/elements/texts/simple_text_field/simple_text_field.dart';
import 'package:omdk_repo/omdk_repo.dart';

/// Generic input text field
class SimpleTextField extends StatelessWidget {
  /// Create [SimpleTextField] instance
  const SimpleTextField({
    required this.onEditingComplete,
    required this.labelText,
    required this.textFocusNode,
    this.initialText = '',
    this.nextFocusNode,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction = TextInputAction.next,
    this.maxLines = 1,
    this.placeholder,
    this.enabled = true,
    this.isObscured = false,
    this.customBoxBorder,
    this.isEmptyAllowed = false,
    this.isTextValueNullable = false,
    super.key,
  });

  /// Result function with input data
  final void Function(String?) onEditingComplete;

  /// Label text
  final String labelText;

  /// Focus node of current widget
  final FocusNode textFocusNode;

  /// If exist, pass next focus node to autofocus if on editing complete
  final FocusNode? nextFocusNode;

  /// initial text of widget
  final String initialText;

  /// Set input type of data with [TextInputType] enum
  final TextInputType keyboardType;

  /// If input data is text you can capitalize is
  final TextCapitalization textCapitalization;

  /// Specify special action on complete
  final TextInputAction textInputAction;

  /// Max allowed string lines
  final int maxLines;

  /// If exist, set widget placeholder
  final String? placeholder;

  /// Enable or not widget
  final bool enabled;

  /// Obscure text (like password)
  final bool isObscured;

  /// Allow nullable text value
  final bool isTextValueNullable;

  /// Allow empty text
  final bool isEmptyAllowed;

  /// Specify custom border to add on the widget
  final BoxBorder? customBoxBorder;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SimpleTextBloc(
        isEmptyAllowed: isEmptyAllowed,
        isNullable: isTextValueNullable,
      ),
      child: _SimpleTextFieldView(
        labelText: labelText,
        textFocusNode: textFocusNode,
        initialText: initialText,
        nextFocusNode: nextFocusNode,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        textInputAction: textInputAction,
        maxLines: maxLines,
        placeholder: placeholder,
        enabled: enabled,
        onEditingComplete: onEditingComplete,
        customBoxBorder: customBoxBorder,
        isObscured: isObscured,
      ),
    );
  }
}

class _SimpleTextFieldView extends StatefulWidget {
  const _SimpleTextFieldView({
    required this.labelText,
    required this.textFocusNode,
    required this.onEditingComplete,
    this.initialText = '',
    this.nextFocusNode,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction = TextInputAction.next,
    this.maxLines = 1,
    this.placeholder,
    this.enabled = true,
    this.isObscured = false,
    this.customBoxBorder,
  });

  final void Function(String?) onEditingComplete;
  final String labelText;
  final FocusNode textFocusNode;
  final FocusNode? nextFocusNode;
  final String initialText;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction textInputAction;
  final int maxLines;
  final String? placeholder;
  final bool enabled;
  final bool isObscured;
  final BoxBorder? customBoxBorder;

  @override
  State<_SimpleTextFieldView> createState() => _SimpleTextFieldViewState();
}

class _SimpleTextFieldViewState extends State<_SimpleTextFieldView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SimpleTextBloc, SimpleTextState>(
      builder: (context, state) {
        if (state.status == SimpleTextStatus.success) {
          widget.onEditingComplete(state.text);
        }
        return SizedBox(
          height: (100 + ((widget.maxLines - 1) * 16)).toDouble(),
          child: Stack(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      widget.labelText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: state.status == SimpleTextStatus.failure
                          ? context.theme?.inputDecorationTheme.errorStyle
                          : context.theme?.inputDecorationTheme.labelStyle,
                    ),
                  ),
                ],
              ),
              Opacity(
                opacity: (!widget.enabled) ? 0.5 : 1,
                child: AbsorbPointer(
                  absorbing: false,
                  child: Container(
                    margin: const EdgeInsets.only(
                      top: 22,
                      left: 10,
                      right: 15,
                    ),
                    constraints: BoxConstraints(
                      minHeight: (52 + ((widget.maxLines - 1) * 16)).toDouble(),
                    ),
                    child: Focus(
                      onFocusChange: (bool focus) {
                        if (!focus) {
                          context.read<SimpleTextBloc>().add(ValidateData());
                        }
                      },
                      child: TextField(
                        readOnly: !widget.enabled,
                        focusNode: widget.textFocusNode,
                        keyboardType: widget.keyboardType,
                        textCapitalization: widget.textCapitalization,
                        textInputAction: widget.textInputAction,
                        obscureText: widget.isObscured,
                        maxLines:
                            widget.textInputAction == TextInputAction.newline
                                ? null
                                : widget.maxLines,
                        onChanged: (text) => context
                            .read<SimpleTextBloc>()
                            .add(TextChanged(text)),
                        onEditingComplete: () {
                          context.read<SimpleTextBloc>().add(ValidateData());
                          if (widget.nextFocusNode != null) {
                            FocusScope.of(context)
                                .requestFocus(widget.nextFocusNode);
                          } else {
                            FocusScope.of(context).unfocus();
                            FocusScope.of(context).requestFocus(FocusNode());
                          }
                        },
                        style: context.theme?.textTheme.bodyMedium,
                        decoration: InputDecoration(
                          filled: false,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          alignLabelWithHint: true,
                          helperText: '',
                          hintText: widget.placeholder,
                          hintMaxLines: widget.maxLines,
                          hintStyle:
                              context.theme?.inputDecorationTheme.hintStyle,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (state.status == SimpleTextStatus.failure)
                Positioned(
                  bottom: 5,
                  child: Text(
                    state.errorText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.theme?.inputDecorationTheme.errorStyle,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
