import 'package:flutter/material.dart';
import 'package:omdk_inspecta/elements/elements.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

class FieldInt extends StatefulWidget {
  /// Create [FieldInt] instance
  const FieldInt({
    required this.labelText,
    required this.onChanged,
    super.key,
    this.onSubmit,
    this.focusNode,
    this.bloc,
    this.nextFocusNode,
    this.fieldValue,
    this.isEnabled = true,
    this.isNullable = true,
    this.isEmptyAllowed = true,
    this.onTap,
    this.onTapBloc,
    this.keyboardBloc,
    this.onBuildedBloc,
    this.initialText,
    this.placeholder,
  });

  final String labelText;
  final SimpleTextBloc? bloc;
  final double? fieldValue;
  final bool isEnabled;
  final bool isNullable;
  final bool isEmptyAllowed;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final void Function(int?) onChanged;
  final void Function(int?)? onSubmit;
  final void Function()? onTap;
  final VirtualKeyboardBloc? keyboardBloc;
  final void Function(SimpleTextBloc)? onBuildedBloc;
  final void Function(SimpleTextBloc)? onTapBloc;
  final int? initialText;
  final String? placeholder;

  @override
  State<FieldInt> createState() => _FieldIntState();
}

class _FieldIntState extends State<FieldInt> {
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
        TextChanged(widget.initialText!.toString(), 0),
      );
    }
    widget.onBuildedBloc?.call(widgetBloc);
  }

  @override
  Widget build(BuildContext context) {
    return SimpleTextField(
      key: widget.key,
      keyboardType: TextInputType.number,
      isInputTextEnabled: widget.isEnabled,
      simpleTextBloc: widgetBloc,
      onChanged: (newValue) {
        if (newValue == null) return widget.onChanged(null);
        widget.onChanged(int.parse(newValue));
      },
      onSubmit: (newValue) {
        if (newValue == null) return widget.onSubmit?.call(null);
        widget.onSubmit?.call(int.parse(newValue));
      },
      labelText: widget.labelText.toUpperCase(),
      textFocusNode: widget.focusNode,
      nextFocusNode: widget.nextFocusNode,
      onFocusChange: (focus) {
        if (focus) {
          if (!widget.keyboardBloc!.state.isVisible) {
            widget.keyboardBloc
                ?.add(ChangeType(keyboardType: VirtualKeyboardType.Numeric));
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
            ?..add(
              ChangeType(keyboardType: VirtualKeyboardType.Numeric),
            )
            ..add(ChangeVisibility(isVisibile: true));
        }
        widget.onTap?.call();
      },
    );
  }
}
