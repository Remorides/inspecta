import 'package:flutter/material.dart';
import 'package:omdk_inspecta/elements/elements.dart';

class FieldString extends StatefulWidget {
  /// Create [FieldString] instance
  const FieldString({
    required this.labelText,
    required this.focusNode,
    super.key,
    this.onSubmit,
    this.onChanged,
    this.initialText,
    this.bloc,
    this.nextFocusNode,
    this.isEnabled = true,
    this.isNullable = true,
    this.isEmptyAllowed = true,
    this.withBorder = false,
    this.autofocus = false,
    this.isObscured = false,
    this.onTap,
    this.onTapBloc,
    this.onBuildedBloc,
    this.onCursorPosition,
    this.placeholder,
    this.maxLines = 1,
    this.fieldNote,
    this.keyboardBloc,
  });

  final String labelText;
  final SimpleTextBloc? bloc;
  final bool isEnabled;
  final bool autofocus;
  final bool isNullable;
  final bool isEmptyAllowed;
  final bool isObscured;
  final bool withBorder;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;
  final VirtualKeyboardBloc? keyboardBloc;
  final void Function(String?)? onChanged;
  final void Function(String?)? onSubmit;
  final void Function()? onTap;
  final void Function(SimpleTextBloc)? onTapBloc;
  final void Function(SimpleTextBloc)? onBuildedBloc;
  final void Function(int)? onCursorPosition;
  final String? initialText;
  final String? placeholder;
  final int maxLines;
  final String? fieldNote;

  @override
  State<FieldString> createState() => _FieldStringState();
}

class _FieldStringState extends State<FieldString> {
  late SimpleTextBloc widgetBloc;

  @override
  void initState() {
    super.initState();
    widgetBloc = widget.bloc ??
        SimpleTextBloc(
          isInputTextEnabled: widget.isEnabled,
          isNullable: widget.isNullable,
          isEmptyAllowed: widget.isEmptyAllowed,
        );
    if (widget.initialText != null) {
      widgetBloc.add(
        TextChanged(widget.initialText!, 0),
      );
    }
    widget.onBuildedBloc?.call(widgetBloc);
  }

  @override
  Widget build(BuildContext context) {
    return SimpleTextField(
      key: widget.key,
      autofocus: widget.autofocus,
      isInputTextEnabled: widget.isEnabled,
      isObscured: widget.isObscured,
      simpleTextBloc: widgetBloc,
      onCursorPosition: (position) {
        widgetBloc.add(
          TextChanged(
            widgetBloc.state.text ?? '',
            position,
          ),
        );
        widget.onCursorPosition?.call(position);
      },
      labelText: widget.labelText.toUpperCase(),
      placeholder: widget.placeholder,
      textFocusNode: widget.focusNode,
      nextFocusNode: widget.nextFocusNode,
      withBorder: widget.withBorder,
      onFocusChange: (focus) {
        if (focus) {
          if (!widget.keyboardBloc!.state.isVisible) {
            widget.keyboardBloc?.add(ChangeType());
          } else {
            widget.keyboardBloc
              ?..add(ChangeType())
              ..add(ChangeVisibility(isVisibile: true));
          }
        }
      },
      onTap: () {
        widget.onTapBloc?.call(widgetBloc);
        if (widget.keyboardBloc != null) {
          widget.keyboardBloc
            ?..add(ChangeType())
            ..add(ChangeVisibility(isVisibile: true));
        }
      },
      onSubmit: widget.onSubmit,
      onChanged: widget.onChanged,
      maxLines: widget.maxLines,
      fieldNote: widget.fieldNote,
    );
  }
}
