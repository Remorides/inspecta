import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdk/elements/buttons/outlined_button/outlined_button.dart';
import 'package:omdk_repo/omdk_repo.dart';

class OMDKOutlinedButton extends StatelessWidget {
  /// Create [OMDKOutlinedButton] instance
  const OMDKOutlinedButton({
    required this.onPressed,
    required this.child,
    super.key,
    this.cubit,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.style,
    this.enabled = true,
    this.autofocus = true,
  });

  final OutlinedButtonCubit? cubit;
  final void Function() onPressed;
  final void Function()? onLongPress;
  final void Function(bool)? onHover;
  final void Function(bool)? onFocusChange;
  final ButtonStyle? style;
  final bool autofocus;
  final bool enabled;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => cubit ?? OutlinedButtonCubit(enabled: enabled),
      child: _OMDKOutlinedButton(
        key: key,
        onPressed: onPressed,
        onLongPress: onLongPress,
        onHover: onHover,
        onFocusChange: onFocusChange,
        style: style,
        autofocus: autofocus,
        child: child,
      ),
    );
  }
}

class _OMDKOutlinedButton extends StatelessWidget {
  const _OMDKOutlinedButton({
    required this.onPressed,
    required this.child,
    super.key,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.style,
    this.autofocus = false,
  });

  final void Function() onPressed;
  final void Function()? onLongPress;
  final void Function(bool)? onHover;
  final void Function(bool)? onFocusChange;
  final ButtonStyle? style;
  final bool autofocus;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final state = context.select((OutlinedButtonCubit cubit) => cubit.state);
    return OutlinedButton(
      key: key,
      onPressed: state.enabled ? onPressed : null,
      onLongPress: state.enabled ? onLongPress : null,
      onHover: onHover,
      onFocusChange: onFocusChange,
      style: state.enabled
          ? style
          : context.theme?.outlinedButtonTheme.style?.copyWith(
              overlayColor: MaterialStateProperty.all<Color>(
                context.theme!.disabledColor.withOpacity(0.8),
              ),
              side: MaterialStateProperty.all<BorderSide>(
                BorderSide(
                  width: 1.5,
                  color: context.theme!.disabledColor.withOpacity(0.8),
                ),
              ),
            ),
      autofocus: autofocus,
      child: child,
    );
  }
}