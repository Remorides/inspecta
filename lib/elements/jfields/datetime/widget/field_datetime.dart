import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:omdk_inspecta/elements/elements.dart';
import 'package:omdk_inspecta/elements/jfields/string_with_action/string_with_action.dart';

class FieldDateTime extends StatefulWidget {
  /// Create [FieldDateTime] instance
  const FieldDateTime({
    required this.labelText,
    required this.focusNode,
    super.key,
    this.initialDate,
    this.fieldNote,
    this.isInputTextEnabled = false,
    this.isActionEnabled = true,
    this.isNullable = true,
    this.isEmptyAllowed = true,
    this.bloc,
    this.onChanged,
    this.onSubmit,
    this.onTap,
    this.onBuildedBloc,
  });

  final String labelText;
  final DateTime? initialDate;
  final FocusNode focusNode;
  final String? fieldNote;
  final SimpleTextBloc? bloc;
  final bool isInputTextEnabled;
  final bool isActionEnabled;
  final bool isNullable;
  final bool isEmptyAllowed;
  final void Function()? onTap;
  final void Function(SimpleTextBloc)? onBuildedBloc;
  final void Function(DateTime?)? onChanged;
  final void Function(String?)? onSubmit;

  @override
  State<FieldDateTime> createState() => _FieldDateTimeState();
}

class _FieldDateTimeState extends State<FieldDateTime> {
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
    if (widget.initialDate != null) {
      widgetBloc.add(
        TextChanged(widget.initialDate!.toUtc().toString(), 0),
      );
    }
    widget.onBuildedBloc?.call(widgetBloc);
  }

  @override
  Widget build(BuildContext context) {
    return FieldStringWithAction(
      key: widget.key,
      labelText: widget.labelText,
      focusNode: widget.focusNode,
      isInputTextEnabled: widget.isInputTextEnabled,
      isActionEnabled: widget.isActionEnabled,
      isNullable: widget.isNullable,
      isEmptyAllowed: widget.isEmptyAllowed,
      actionIcon: const Icon(CupertinoIcons.calendar),
      fieldNote: widget.fieldNote,
      bloc: widgetBloc,
      onSubmit: widget.onSubmit,
      onTapAction: _datePicker,
    );
  }

  Future<void> _datePicker() async {
    await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    ).then((date) {
      if (date != null) {
        widgetBloc.add(
          TextChanged(
            date.toString(),
            date.toString().length,
          ),
        );
        widget.onChanged?.call(date);
      }
    });
  }
}
