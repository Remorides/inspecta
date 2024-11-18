import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdk_inspecta/elements/radio_buttons/multi_radio_buttons/cubit/mrb_cubit.dart';

class PriorityButtons extends StatelessWidget {
  const PriorityButtons({
    required this.labelText,
    super.key,
    this.cubit,
    this.isEnabled = true,
    this.onSelectedPriority,
    this.indexSelectedRadio,
  });

  final String labelText;
  final bool isEnabled;
  final MrbCubit? cubit;
  final int? indexSelectedRadio;
  final void Function(int?)? onSelectedPriority;

  @override
  Widget build(BuildContext context) {
    return cubit != null
        ? BlocProvider.value(value: cubit!, child: _child)
        : BlocProvider(
            create: (_) => MrbCubit(
              isEnabled: isEnabled,
              selected: indexSelectedRadio,
            ),
            child: _child,
          );
  }

  Widget get _child => _PriorityButtons(
        labelText: labelText,
        onSelectedPriority: onSelectedPriority,
      );
}

class _PriorityButtons extends StatelessWidget {
  const _PriorityButtons({
    required this.labelText,
    this.onSelectedPriority,
  });

  final String labelText;
  final void Function(int?)? onSelectedPriority;

  @override
  Widget build(BuildContext context) {
    final state = context.select((MrbCubit cubit) => cubit.state);
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                labelText.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ],
        ),
        Opacity(
          opacity: (!state.isEnabled) ? 0.5 : 1,
          child: AbsorbPointer(
            absorbing: !state.isEnabled,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: highButton(context, state)),
                Expanded(child: mediumButton(context, state)),
                Expanded(child: lowButton(context, state)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget highButton(BuildContext context, MrbState state) => RadioListTile<int>(
        title: const Text(
          'ALTA',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.w600,
          ),
        ),
        value: 3,
        shape: const RoundedRectangleBorder(),
        controlAffinity: ListTileControlAffinity.trailing,
        groupValue: state.selectedRadio,
        onChanged: (value) {
          if (value != null) {
            context.read<MrbCubit>().switchRadio(value);
            onSelectedPriority?.call(value);
          }
        },
      );

  Widget mediumButton(BuildContext context, MrbState state) =>
      RadioListTile<int>(
        title: const Text(
          'MEDIA',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.yellow,
            fontWeight: FontWeight.w600,
          ),
        ),
        value: 2,
        shape: const RoundedRectangleBorder(),
        controlAffinity: ListTileControlAffinity.trailing,
        groupValue: state.selectedRadio,
        onChanged: (value) {
          if (value != null) {
            context.read<MrbCubit>().switchRadio(value);
            onSelectedPriority?.call(value);
          }
        },
      );

  Widget lowButton(BuildContext context, MrbState state) => RadioListTile<int>(
        title: const Text(
          'BASSA',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.w600,
          ),
        ),
        value: 1,
        shape: const RoundedRectangleBorder(),
        controlAffinity: ListTileControlAffinity.trailing,
        groupValue: state.selectedRadio,
        onChanged: (value) {
          if (value != null) {
            context.read<MrbCubit>().switchRadio(value);
            onSelectedPriority?.call(value);
          }
        },
      );
}
