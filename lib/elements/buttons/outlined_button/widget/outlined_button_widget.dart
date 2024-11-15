import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdk_inspecta/elements/buttons/buttons.dart';

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
    this.focusNode,
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
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return cubit != null
        ? BlocProvider.value(value: cubit!, child: _child)
        : BlocProvider(
            create: (_) => OutlinedButtonCubit(enabled: enabled),
            child: _child,
          );
  }

  Widget get _child => _OMDKOutlinedButton(
        key: key,
        onPressed: onPressed,
        onLongPress: onLongPress,
        onHover: onHover,
        onFocusChange: onFocusChange,
        style: style,
        autofocus: autofocus,
        focusNode: focusNode,
        child: child,
      );
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
    this.focusNode,
  });

  final void Function() onPressed;
  final void Function()? onLongPress;
  final void Function(bool)? onHover;
  final void Function(bool)? onFocusChange;
  final ButtonStyle? style;
  final bool autofocus;
  final FocusNode? focusNode;
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
          : Theme.of(context).outlinedButtonTheme.style?.copyWith(
                overlayColor: WidgetStateProperty.all<Color>(
                  Theme.of(context).disabledColor.withOpacity(0.8),
                ),
                side: WidgetStateProperty.all<BorderSide>(
                  BorderSide(
                    width: 1.5,
                    color: Theme.of(context).disabledColor.withOpacity(0.8),
                  ),
                ),
              ),
      autofocus: autofocus,
      focusNode: focusNode,
      child: child,
    );
  }
}
