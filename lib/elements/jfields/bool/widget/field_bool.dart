import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdk/elements/jfields/bool/cubit/field_bool_cubit.dart';
import 'package:omdk_repo/omdk_repo.dart';

class FieldBool extends StatelessWidget {
  /// Create [FieldBool] instance
  const FieldBool({
    required this.labelText,
    required this.onChanged,
    this.cubit,
    this.focusNode,
    super.key,
    this.fieldValue = true,
    this.isEnabled = true,
  });

  final String labelText;
  final FieldBoolCubit? cubit;
  final bool fieldValue;
  final bool isEnabled;
  final FocusNode? focusNode;
  final void Function(bool?) onChanged;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      cubit ??
          FieldBoolCubit(
            isEnabled: isEnabled,
            fieldValue: fieldValue,
          ),
      child: _FieldBool(
        labelText: labelText,
        focusNode: focusNode,
        onChanged: onChanged,
        key: key,
      ),
    );
  }
}

class _FieldBool extends StatelessWidget {

  const _FieldBool({
    required this.labelText,
    required this.onChanged,
    this.focusNode,
    super.key,
  });

  final String labelText;
  final FocusNode? focusNode;
  final void Function(bool?) onChanged;

  @override
  Widget build(BuildContext context) {
    final state = context.select((FieldBoolCubit cubit) => cubit.state);
    return Stack(
      children: [
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Expanded(
                child: Text(
                  labelText.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: context.theme?.colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ],
        ),
        Opacity(
          opacity: (!state.isEnabled) ? 0.5 : 1,
          child: AbsorbPointer(
            absorbing: !state.isEnabled,
            child: Theme(
              data: ThemeData(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: Container(
                margin: const EdgeInsets.only(top: 22),
                decoration: BoxDecoration(
                  color: context.theme?.colorScheme.background,
                  borderRadius: BorderRadius.circular(8),
                ),
                height: 52,
                child: Center(
                  child: CheckboxListTile(
                    value: state.fieldValue,
                    focusNode: focusNode,
                    enableFeedback: false,
                    onChanged: (bool? b) {
                      context.read<FieldBoolCubit>().toggle();
                      onChanged(b);
                    },
                    activeColor: context.theme?.primaryColor,
                    controlAffinity: ListTileControlAffinity
                        .leading,
                    title: Text(
                      labelText,
                      style: TextStyle(
                        color: context.theme?.colorScheme.onBackground,
                      ),
                    ),
                    checkboxShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
