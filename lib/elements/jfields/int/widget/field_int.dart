import 'package:flutter/material.dart';
import 'package:omdk_inspecta/elements/elements.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

class FieldInt extends StatefulWidget {
  /// Create [FieldInt] instance
  const FieldInt({
    required this.labelText,
    required this.focusNode,
    super.key,
    this.onSubmit,
    this.onChanged,
    this.initialValue,
    this.bloc,
    this.nextFocusNode,
    this.isEnabled = true,
    this.isNullable = true,
    this.isEmptyAllowed = true,
    this.withBorder = false,
    this.autofocus = false,
    this.onTap,
    this.onTapBloc,
    this.onBuildedBloc,
    this.onCursorPosition,
    this.placeholder,
    this.textAlign = TextAlign.start,
    this.fieldNote,
    this.keyboardBloc,
  });

  final String labelText;
  final SimpleTextBloc? bloc;
  final bool isEnabled;
  final bool autofocus;
  final bool isNullable;
  final bool isEmptyAllowed;
  final bool withBorder;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;
  final void Function(int?)? onChanged;
  final void Function(int?)? onSubmit;
  final void Function()? onTap;
  final void Function(SimpleTextBloc)? onBuildedBloc;
  final void Function(SimpleTextBloc)? onTapBloc;
  final void Function(int)? onCursorPosition;
  final int? initialValue;
  final String? placeholder;
  final TextAlign textAlign;
  final String? fieldNote;
  final VirtualKeyboardBloc? keyboardBloc;

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
    if (widget.initialValue != null) {
      widgetBloc.add(TextChanged(widget.initialValue.toString(), 0));
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
      onCursorPosition: (position) {
        widgetBloc.add(
          TextChanged(
            widgetBloc.state.text ?? '',
            position,
          ),
        );
        widget.onCursorPosition?.call(position);
      },
      onChanged: (newValue) {
        if (newValue == null) return widget.onChanged?.call(null);
        final parsedValue = int.tryParse(newValue);
        if(parsedValue != null) widget.onChanged?.call(parsedValue);
      },
      onSubmit: (newValue) {
        if (newValue == null) return widget.onSubmit?.call(null);
        final parsedValue = int.tryParse(newValue);
        if(parsedValue != null) widget.onSubmit?.call(parsedValue);
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
