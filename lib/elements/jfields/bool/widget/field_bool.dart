import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdk_inspecta/elements/jfields/bool/cubit/field_bool_cubit.dart';

class FieldBool extends StatelessWidget {
  /// Create [FieldBool] instance
  const FieldBool({
    required this.labelText,
    required this.onChanged,
    this.focusNode,
    this.cubit,
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
    return cubit != null
        ? BlocProvider.value(
            value: cubit!,
            child: _child,
          )
        : BlocProvider(
            create: (context) => FieldBoolCubit(
              isEnabled: isEnabled,
              fieldValue: fieldValue,
            ),
            child: _child,
          );
  }

  Widget get _child => _FieldBool(
        labelText: labelText,
        focusNode: focusNode,
        onChanged: onChanged,
        key: key,
      );
}

class _FieldBool extends StatelessWidget {
  const _FieldBool({
    required this.labelText,
    required this.onChanged,
    required this.focusNode,
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
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ),
          ],
        ),
        Opacity(
          opacity: (!state.isEnabled) ? 0.5 : 1,
          child: AbsorbPointer(
            absorbing: !state.isEnabled,
            child: Container(
              margin: const EdgeInsets.only(top: 22),
              decoration: BoxDecoration(
                color: Theme.of(context).inputDecorationTheme.fillColor,
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
                  activeColor: Theme.of(context).colorScheme.primary,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(
                    labelText,
                    style: Theme.of(context).inputDecorationTheme.labelStyle,
                  ),
                  checkboxShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
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
