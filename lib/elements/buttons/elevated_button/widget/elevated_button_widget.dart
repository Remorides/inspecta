import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdk/elements/buttons/elevated_button/elevated_button.dart';
import 'package:omdk_repo/omdk_repo.dart';

class OMDKElevatedButton extends StatelessWidget {
  /// Create [OMDKElevatedButton] instance
  const OMDKElevatedButton({
    required this.onPressed,
    required this.child,
    super.key,
    this.cubit,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.style,
    this.enabled = true,
    this.autofocus = false,
    this.focusNode,
  });

  final ElevatedButtonCubit? cubit;
  final void Function() onPressed;
  final void Function()? onLongPress;
  final void Function(bool)? onHover;
  final void Function(bool)? onFocusChange;
  final ButtonStyle? style;
  final bool autofocus;
  final bool enabled;
  final Widget child;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => cubit ?? ElevatedButtonCubit(enabled: enabled),
      child: _OMDKElevatedButton(
        key: key,
        onPressed: onPressed,
        onLongPress: onLongPress,
        onHover: onHover,
        onFocusChange: onFocusChange,
        style: style,
        autofocus: autofocus,
        focusNode: focusNode,
        child: child,
      ),
    );
  }
}

class _OMDKElevatedButton extends StatelessWidget {
  const _OMDKElevatedButton({
    required this.onPressed,
    required this.child,
    super.key,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.style,
    this.autofocus = false,
    this.focusNode,
  });

  final void Function() onPressed;
  final void Function()? onLongPress;
  final void Function(bool)? onHover;
  final void Function(bool)? onFocusChange;
  final ButtonStyle? style;
  final bool autofocus;
  final Widget child;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final state = context.select((ElevatedButtonCubit cubit) => cubit.state);
    return ElevatedButton(
      key: key,
      onPressed: state.enabled ? onPressed : null,
      onLongPress: state.enabled ? onLongPress : null,
      onHover: onHover,
      onFocusChange: onFocusChange,
      style: state.enabled
          ? style
          : style?.copyWith(
              backgroundColor: MaterialStateProperty.all<Color>(
                context.theme!.disabledColor.withOpacity(0.8),
              ),
            ),
      autofocus: autofocus,
      focusNode: focusNode,
      child: child,
    );
  }
}
