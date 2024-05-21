import 'package:flutter/material.dart';
import 'package:omdk/elements/elements.dart';

class FieldString extends StatefulWidget {
  /// Create [FieldString] instance
  const FieldString({
    required this.labelText,
    required this.onChanged,
    this.focusNode,
    super.key,
    this.initialText,
    this.bloc,
    this.nextFocusNode,
    this.fieldValue,
    this.isEnabled = true,
    this.isNullable = true,
    this.isEmptyAllowed = true,
    this.onTapBloc,
    this.onCursorPosition,
    this.keyboardBloc,
  });

  final String labelText;
  final SimpleTextBloc? bloc;
  final double? fieldValue;
  final bool isEnabled;
  final bool isNullable;
  final bool isEmptyAllowed;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final void Function(String?) onChanged;
  final void Function(int)? onCursorPosition;
  final VirtualKeyboardBloc? keyboardBloc;
  final void Function(SimpleTextBloc)? onTapBloc;
  final String? initialText;

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
          isNullable: widget.isNullable,
          isEmptyAllowed: widget.isEmptyAllowed,
        );
    if (widget.initialText != null) {
      widgetBloc.add(TextChanged(widget.initialText!, 0));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SimpleTextField(
      key: widget.key,
      enabled: widget.isEnabled,
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
      onEditingComplete: (newValue) {
        if (newValue == null) return widget.onChanged(null);
        widget.onChanged(newValue);
      },
      labelText: widget.labelText.toUpperCase(),
      textFocusNode: widget.focusNode,
      nextFocusNode: widget.nextFocusNode,
      onFocus: () {
        if (!widget.keyboardBloc!.state.isVisible) {
          widget.keyboardBloc?.add(ChangeType());
        } else {
          widget.keyboardBloc
            ?..add(ChangeType())
            ..add(ChangeVisibility(isVisibile: true));
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
    );
  }
}
