import 'package:flutter/material.dart';
import 'package:omdk/elements/elements.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

class FieldDouble extends StatefulWidget {
  /// Create [FieldDouble] instance
  const FieldDouble({
    required this.labelText,
    required this.focusNode,
    required this.onChanged,
    super.key,
    this.bloc,
    this.nextFocusNode,
    this.fieldValue,
    this.isEnabled = true,
    this.onTap,
    this.keyboardBloc,
    this.onTapBloc,
  });

  final String labelText;
  final SimpleTextBloc? bloc;
  final double? fieldValue;
  final bool isEnabled;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;
  final void Function(double?) onChanged;
  final void Function()? onTap;
  final VirtualKeyboardBloc? keyboardBloc;
  final void Function(SimpleTextBloc)? onTapBloc;

  @override
  State<FieldDouble> createState() => _FieldDoubleState();
}

class _FieldDoubleState extends State<FieldDouble> {

  late SimpleTextBloc widgetBloc;

  @override
  void initState(){
    super.initState();
    widgetBloc = widget.bloc ?? SimpleTextBloc();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleTextField(
      key: widget.key,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      enabled: widget.isEnabled,
      simpleTextBloc: widgetBloc,
      onEditingComplete: (newValue) {
        if(newValue == null) return widget.onChanged(null);
        widget.onChanged(double.parse(newValue));
      },
      labelText: widget.labelText.toUpperCase(),
      textFocusNode: widget.focusNode,
      nextFocusNode: widget.nextFocusNode,
      onTap: (){
        widget.onTapBloc?.call(widgetBloc);
        if(widget.keyboardBloc != null){
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
