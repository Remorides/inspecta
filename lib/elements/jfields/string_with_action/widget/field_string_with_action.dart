import 'package:flutter/material.dart';
import 'package:omdk/elements/elements.dart';

class FieldStringWithAction extends StatefulWidget {
  /// Create [FieldStringWithAction] instance
  const FieldStringWithAction({
    required this.labelText,
    required this.focusNode,
    required this.actionIcon,
    required this.onSubmit,
    super.key,
    this.initialText,
    this.bloc,
    this.nextFocusNode,
    this.fieldValue,
    this.isInputTextEnabled = false,
    this.isActionEnabled = true,
    this.isNullable = true,
    this.isEmptyAllowed = true,
    this.withBorder = false,
    this.onTap,
    this.onCursorPosition,
    this.onChanged,
    this.onBuildedBloc,
    this.placeholder,
    this.onTapAction,
  });

  final String labelText;
  final SimpleTextBloc? bloc;
  final double? fieldValue;
  final bool isInputTextEnabled;
  final bool isActionEnabled;
  final bool isNullable;
  final bool isEmptyAllowed;
  final bool withBorder;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;
  final void Function(String?)? onChanged;
  final void Function(String?) onSubmit;
  final void Function()? onTap;
  final void Function()? onTapAction;
  final void Function(SimpleTextBloc)? onBuildedBloc;
  final void Function(int)? onCursorPosition;
  final String? initialText;
  final String? placeholder;
  final Icon actionIcon;

  @override
  State<FieldStringWithAction> createState() => _FieldStringWithActionState();
}

class _FieldStringWithActionState extends State<FieldStringWithAction> {
  late SimpleTextBloc widgetBloc;

  @override
  void initState() {
    super.initState();
    widgetBloc = widget.bloc ??
        SimpleTextBloc(
          isInputTextEnabled: widget.isInputTextEnabled,
          isActionEnabled: widget.isActionEnabled,
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
  void dispose() {
    super.dispose();
    widget.focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleTextField(
      key: widget.key,
      isInputTextEnabled: widget.isInputTextEnabled,
      simpleTextBloc: widgetBloc,
      actionIcon: widget.actionIcon,
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
      withAction: true,
      onTap: widget.onTap,
      onTapAction: widget.onTapAction,
      onSubmit: widget.onSubmit,
      onChanged: widget.onChanged,
    );
  }
}
