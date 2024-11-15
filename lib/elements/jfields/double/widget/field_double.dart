import 'package:flutter/material.dart';
import 'package:omdk_inspecta/elements/elements.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

class FieldDouble extends StatefulWidget {
  /// Create [FieldDouble] instance
  const FieldDouble({
    required this.labelText,
    required this.onChanged,
    required this.focusNode,
    super.key,
    this.onSubmit,
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
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;
  final void Function(double?) onChanged;
  final void Function(double?)? onSubmit;
  final void Function()? onTap;
  final VirtualKeyboardBloc? keyboardBloc;
  final void Function(SimpleTextBloc)? onBuildedBloc;
  final void Function(SimpleTextBloc)? onTapBloc;
  final int? initialText;
  final String? placeholder;

  @override
  State<FieldDouble> createState() => _FieldDoubleState();
}

class _FieldDoubleState extends State<FieldDouble> {
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
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      isInputTextEnabled: widget.isEnabled,
      simpleTextBloc: widgetBloc,
      onChanged: (newValue) {
        if (newValue == null) return widget.onChanged(null);
        widget.onChanged(double.parse(newValue));
      },
      onSubmit: (newValue) {
        if (newValue == null) return widget.onSubmit?.call(null);
        widget.onSubmit?.call(double.parse(newValue));
      },
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
      labelText: widget.labelText.toUpperCase(),
      textFocusNode: widget.focusNode,
      nextFocusNode: widget.nextFocusNode,
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
