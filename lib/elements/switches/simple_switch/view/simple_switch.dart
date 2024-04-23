import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdk/elements/switches/simple_switch/cubit/switch_cubit.dart';

/// Generic input text field
class OMDKSwitch extends StatelessWidget {
  /// Create [OMDKSwitch] instance
  const OMDKSwitch({
    required this.isEnabled,
    required this.isActive,
    super.key,
    this.cubit,
    this.focusNode,
  });

  /// Optional param to allow user to create bloc externally
  final SwitchCubit? cubit;

  /// Enable or not widget
  final bool isEnabled;

  /// Starting value
  final bool isActive;

  /// If needed, you can provide focus node
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          cubit ??
          SwitchCubit(
            isEnabled: isEnabled,
            isActive: isActive,
          ),
      child: _OMDKSwitch(focusNode),
    );
  }
}

class _OMDKSwitch extends StatelessWidget {
  const _OMDKSwitch(this.focusNode);

  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final state = context.select((SwitchCubit cubit) => cubit.state);
    return SizedBox(
      child: Opacity(
        opacity: !state.isEnabled ? 0.5 : 1,
        child: AbsorbPointer(
          absorbing: !state.isEnabled,
          child: Switch(
            focusNode: focusNode,
            value: state.isActive,
            onChanged: (bool value) {
              context.read<SwitchCubit>().toggle(value);
            },
            inactiveTrackColor: Colors.grey,
            inactiveThumbColor: Colors.white.withOpacity(0.3),
          ),
        ),
      ),
    );
  }

}
