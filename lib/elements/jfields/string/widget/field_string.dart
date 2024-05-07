import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:omdk/elements/elements.dart';
import 'package:omdk/pages/open_ticket/bloc/open_ticket_bloc.dart';

class FieldString extends StatefulWidget {
  /// Create [FieldString] instance
  const FieldString({
    required this.labelText,
    required this.focusNode,
    required this.onChanged,
    super.key,
    this.initialText,
    this.bloc,
    this.nextFocusNode,
    this.fieldValue,
    this.isEnabled = true,
    this.onTap,
    this.keyboardBloc,
    this.pageBloc,
  });

  final String labelText;
  final SimpleTextBloc? bloc;
  final double? fieldValue;
  final bool isEnabled;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;
  final void Function(String?) onChanged;
  final void Function()? onTap;
  final VirtualKeyboardBloc? keyboardBloc;
  final Bloc<dynamic, dynamic>? pageBloc;
  final String? initialText;

  @override
  State<FieldString> createState() => _FieldStringState();
}

class _FieldStringState extends State<FieldString> {
  late SimpleTextBloc widgetBloc;

  @override
  void initState() {
    super.initState();
    widgetBloc =
        widget.bloc ?? SimpleTextBloc(isNullable: true, isEmptyAllowed: true);
    if (widget.initialText != null) {
      widgetBloc.add(TextChanged(widget.initialText!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SimpleTextField(
      key: widget.key,
      enabled: widget.isEnabled,
      simpleTextBloc: widgetBloc,
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
        widget.pageBloc?.add(TicketEditing(bloc: widgetBloc));
        if (widget.keyboardBloc != null) {
          widget.keyboardBloc
            ?..add(ChangeType())
            ..add(ChangeVisibility(isVisibile: true));
        }
        widget.onTap?.call();
      },
    );
  }
}
