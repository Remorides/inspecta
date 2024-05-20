import 'package:flutter/material.dart';
import 'package:omdk/elements/elements.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

class FieldInt extends StatefulWidget {
  /// Create [FieldInt] instance
  const FieldInt({
    required this.labelText,
    required this.onChanged,
    this.focusNode,
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
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final void Function(int?) onChanged;
  final void Function()? onTap;
  final VirtualKeyboardBloc? keyboardBloc;
  final void Function(SimpleTextBloc)? onTapBloc;

  @override
  State<FieldInt> createState() => _FieldIntState();
}

class _FieldIntState extends State<FieldInt> {

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
      keyboardType: TextInputType.number,
      enabled: widget.isEnabled,
      simpleTextBloc: widgetBloc,
      onEditingComplete: (newValue) {
        if(newValue == null) return widget.onChanged(null);
        widget.onChanged(int.parse(newValue));
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
